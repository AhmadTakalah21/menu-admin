import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/tables/view/table_orders_view.dart';
import 'package:user_admin/features/tables/view/widgets/edit_table_widget.dart';
import 'package:user_admin/features/tables/view/widgets/table_details_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';

import '../../../global/di/di.dart';
import '../../../global/model/restaurant_model/restaurant_model.dart';
import '../../../global/model/role_model/role_model.dart';
import '../../../global/widgets/invoice_widget.dart';
import '../../../global/widgets/main_add_button.dart';
import '../../../global/widgets/main_app_bar.dart';
import '../../../global/widgets/main_snack_bar.dart';
import '../../add_order/view/add_order_view.dart';
import '../../coupons/service/coupon_service.dart';
import '../../drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import '../cubit/tables_cubit.dart';
import 'package:user_admin/features/invoices/cubit/invoices_cubit.dart';




abstract class TablesViewCallBacks {
  void onAddTableTap();
  Future<void> onRefresh();
  void onEditTap(TableModel table);
  void onDeleteTap(TableModel table);
  void onSaveDeleteTap(TableModel table);
  void onShowDetails(TableModel table);
  void onShowTableOrders(TableModel table);
  void onSelectPageTap(int page);
  void onTryAgainTap();
}

class TablesView extends StatelessWidget {
  const TablesView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<InvoicesCubit>(),
      child: TablesPage(permissions: permissions, restaurant: restaurant),
    );  }
}

class TablesPage extends StatefulWidget {
  const TablesPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage>
    implements TablesViewCallBacks {
  late final TablesCubit tablesCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();
  late final InvoicesCubit invoicesCubit = context.read<InvoicesCubit>();
  bool _waitingInvoice = false;

  bool canAdd = false;
  bool canEdit = false;
  bool canDelete = false;


  int selectedPage = 1;

  final Map<int, int> _liveStatuses = {};

  void onSocketStatus(int tableId, int status) {
    setState(() => _liveStatuses[tableId] = status);
  }

  @override
  void initState() {
    super.initState();
    tablesCubit.getTables(page: selectedPage);
    final names = widget.permissions.map((e) => e.name).toSet();
    canAdd    = names.contains('table.add')    || names.contains('tables.add');
    canEdit   = names.contains('table.update') || names.contains('tables.update');
    canDelete = names.contains('table.delete') || names.contains('tables.delete');

  }

  @override
  void onAddTableTap() {
    showDialog(
      context: context,
      builder: (context) => const EditTableWidget(isEdit: false),
    );
  }

  @override
  void onShowDetails(TableModel table) {
    showDialog(
      context: context,
      builder: (context) => TableDetailsWidget(
        qrCode: table.qrCode ?? "",
        title: table.tableNumber.toString(),
      ),
    );
  }

  @override
  void onShowTableOrders(TableModel table) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TableOrdersView(
          restaurant: widget.restaurant,
          table: table,
          permissions: widget.permissions,
        ),
      ),
    );
  }

  @override
  void onDeleteTap(TableModel table) {
    showDialog(
      context: context,
      builder: (context) => InsureDeleteWidget(
        isDelete: true,
        item: table,
        onSaveTap: onSaveDeleteTap,
      ),
    );
  }

  @override
  void onEditTap(TableModel table) {
    showDialog(
      context: context,
      builder: (context) => EditTableWidget(
        table: table,
        isEdit: true,
      ),
    );
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() => selectedPage = page);
      tablesCubit.getTables(page: page);
    }
  }

  @override
  Future<void> onRefresh() async {
    tablesCubit.getTables(page: selectedPage);
  }

  @override
  void onTryAgainTap() {
    tablesCubit.getTables(page: selectedPage);
  }

  @override
  void onSaveDeleteTap(TableModel table) {
    deleteCubit.deleteItem<TableModel>(table);
  }

  Color _statusColorFrom(int? s) {
    switch (s) {
      case 1:
        return AppColors.red;
      case 2:
        return AppColors.yellow;
      case 3:
        return AppColors.green;
      default:
        return AppColors.grey;
    }
  }

  int _columnsForWidth(double w) {
    if (w >= 1200) return 4;
    if (w >= 900) return 3;
    if (w >= 600) return 2;
    return 2;
  }
  String _prettyError(BuildContext context, Object? error) {
    // 'error.network'           : 'تحقّق من اتصال الإنترنت ثم أعد المحاولة'
    // 'error.timeout'           : 'انتهت مهلة الطلب، حاول مجدداً'
    // 'error.unauthorized'      : 'ليست لديك صلاحية لتنفيذ هذه العملية'
    // 'error.server'            : 'خطأ في الخادم، حاول لاحقاً'
    // 'error.unknown'           : 'حدث خطأ غير متوقع'
    // 'invoice.export_failed'   : 'فشل تصدير الفاتورة'

    String t(String k) => k.tr();

    if (error == null) {
      return '${t('invoice.export_failed')} • ${t('error.unknown')}';
    }

    // إن كان String من السيرفر
    final raw = error.toString();

    // كشف أخطاء الشبكة الشائعة
    final lower = raw.toLowerCase();
    if (error is SocketException ||
        lower.contains('failed host lookup') ||
        lower.contains('network') ||
        lower.contains('connection')) {
      return '${t('invoice.export_failed')} • ${t('error.network')}';
    }

    if (lower.contains('timeout')) {
      return '${t('invoice.export_failed')} • ${t('error.timeout')}';
    }

    if (lower.contains('unauthorized') ||
        lower.contains('forbidden') ||
        lower.contains('401') ||
        lower.contains('403')) {
      return '${t('invoice.export_failed')} • ${t('error.unauthorized')}';
    }

    if (lower.contains('500') ||
        lower.contains('server') ||
        lower.contains('format')) {
      return '${t('invoice.export_failed')} • ${t('error.server')}';
    }

    final safe = raw.trim();
    if (safe.isNotEmpty && safe.length < 160) {
      return '${t('invoice.export_failed')} • $safe';
    }

    return '${t('invoice.export_failed')} • ${t('error.unknown')}';
  }

  void _showSnack(
      BuildContext context, {
        required String msg,
        IconData icon = Icons.info_outline,
        Color color = const Color(0xFF2E7D32),
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          elevation: 8,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _ = [
      "table_num".tr(),
      "event".tr(),
    ];

    final addIndex = widget.permissions
        .indexWhere((e) => e.name == "table.add");
    final editIndex = widget.permissions
        .indexWhere((e) => e.name == "table.update");
    final deleteIndex = widget.permissions
        .indexWhere((e) => e.name == "table.delete");
    final orderIndex = widget.permissions
        .indexWhere((e) => e.name == "order.index");
    final isAdd = addIndex != -1;
    final isEdit = editIndex != -1;
    final isDelete = deleteIndex != -1;
    final isOrder = orderIndex != -1;

    final restColor =
        widget.restaurant.color ?? const Color(0xFF2E4D2F);

    return MultiBlocListener(
      listeners: [
        BlocListener<AppManagerCubit, AppManagerState>(
          listener: (context, state) {
            if (state is DeletedState) {
              tablesCubit.getTables(page: selectedPage);
            }
          },
        ),

        BlocListener<InvoicesCubit, GeneralInvoicesState>(
          listenWhen: (_, s) => s is AddInvoiceToTableState,
          listener: (context, state) async {
            if (state is AddInvoiceToTableLoading) {
              _waitingInvoice = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
              return;
            }

            if (_waitingInvoice) {
              Navigator.of(context, rootNavigator: true).pop();
              _waitingInvoice = false;
            }

            if (state is AddInvoiceToTableSuccess) {
              await showDialog(
                context: context,
                builder: (_) {
                  final couponService = get<CouponService>();
                  final invoicesCubit = context.read<InvoicesCubit>();

                  return InvoiceWidget(
                    invoice: state.invoice,

                    fetchCoupons: () async {
                      final page1 = await couponService.getCoupons(page: 1);
                      return page1.data.map((c) => CouponOption(
                        id: c.id,
                        code: c.code ?? 'Coupon #${c.id}',
                        percent: c.percent,

                      )).toList();
                    },

                    applyCoupon: (couponId) {
                      return invoicesCubit.applyCouponOnce(
                        invoiceId: state.invoice.id,
                        couponId: couponId,
                        tableId: state.invoice.tableId,

                      );
                    },
                  );

                },
              );
              MainSnackBar.showSuccessMessage(context, 'invoice.export_success'.tr());

              return;
            }

            if (state is AddInvoiceToTableFail) {
              final msg = _prettyError(context, state.error);
              _showSnack(
                context,
                msg: msg,
                icon: Icons.error_outline,
                color: const Color(0xFFE53935),
              );
            }

          },
        ),
      ],
      child: Scaffold(
        appBar: MainAppBar(restaurant: widget.restaurant,
            title: "tables".tr(),
          onSearchChanged: (q) => tablesCubit.searchByName(q),
          onSearchSubmitted: (q) => tablesCubit.searchByName(q),
          onSearchClosed: () => tablesCubit.searchByName(''),
        ),

        drawer: MainDrawer(
          permissions: widget.permissions,
          restaurant: widget.restaurant,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: canAdd
            ? MainAddButton(
          onTap: onAddTableTap,
          color: widget.restaurant.color ?? const Color(0xFFE3170A),
          // heroTag: 'fab-add-coupons',
          // tooltip: 'add_coupon',
        )
            : null,
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MainBackButton(color: restColor),
                  // const SizedBox(height: 20),

                  // Row(
                  //   children: [
                  //     Text(
                  //       "tables".tr(),
                  //       style: const TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //     if (isAdd) const SizedBox(width: 10),
                  //     if (isAdd) _AddTableChip(onTap: onAddTableTap),
                  //   ],
                  // ),

                  const SizedBox(height: 20),

                  BlocBuilder<TablesCubit, GeneralTablesState>(
                    buildWhen: (previous, current) => current is TablesStates,
                    builder: (context, state) {
                      if (state is TablesLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 80),
                            child:
                            LoadingIndicator(color: AppColors.black),
                          ),
                        );
                      } else if (state is TablesSuccess) {
                        final data = state.tables.data;
                        if (data.isEmpty) {
                          return MainErrorWidget(error: "no_data".tr());
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final w = constraints.maxWidth;
                            final cols = _columnsForWidth(w);

                            const spacing = 16.0;
                            final tileWidth =
                                (w - (cols - 1) * spacing) / cols;
                            final tileHeight = tileWidth;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                                mainAxisExtent: tileHeight,
                              ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final table = data[index];

                                final live = _liveStatuses[table.id];
                                final effectiveStatus =
                                    live ?? table.tableStatus;
                                final statusClr =
                                _statusColorFrom(effectiveStatus);

                                return _TableCard(
                                  table: table,
                                  primaryColor: restColor,
                                  statusColor: statusClr,
                                  assetImagePath:
                                  'assets/images/table.png',
                                  onCardTap: () =>
                                      onShowTableOrders(table),
                                  onAddOrder: isOrder
                                      ? () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AddOrderView(
                                        restaurant: widget.restaurant,
                                        permissions: widget.permissions,
                                      ),
                                    ),
                                  )
                                      : null,

                                  onDetails: () =>
                                      onShowDetails(table),
                                  onEdit: isEdit
                                      ? () => onEditTap(table)
                                      : null,
                                  onDelete: isDelete
                                      ? () => onDeleteTap(table)
                                      : null,
                                  onExportInvoice: () {
                                    final inv = context.read<InvoicesCubit>();


                                    inv.addInvoiceTableId = table.id!;
                                    inv.addInvoiceToTable();
                                  },

                                );
                              },
                            );
                          },
                        );
                      } else if (state is TablesEmpty) {
                        return MainErrorWidget(error: state.message);
                      } else if (state is TablesFail) {
                        return Center(
                          child: MainErrorWidget(
                            error: state.error,
                            onTryAgainTap: onTryAgainTap,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TableCard extends StatelessWidget {
  const _TableCard({
    required this.table,
    required this.primaryColor,
    required this.statusColor,
    required this.assetImagePath,
    required this.onCardTap,
    this.onAddOrder,
    this.onDetails,
    this.onEdit,
    this.onDelete,
    this.onExportInvoice,
    this.onAddCoupon,
  });

  final TableModel table;
  final Color primaryColor;
  final Color statusColor;
  final String assetImagePath;

  final VoidCallback onCardTap;
  final VoidCallback? onAddOrder;
  final VoidCallback? onDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onExportInvoice;
  final VoidCallback? onAddCoupon;

  static const double _radius = 18.0;
  static const double _barHeight = 56.0;
  static const double kActionsGap = 22.0;


  Color _onColor(Color bg) =>
      bg.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

  @override
  Widget build(BuildContext context) {
    final onTopTextColor = _onColor(statusColor);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onCardTap,
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0, bottom: _barHeight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                color: statusColor.withOpacity(0.16),
              ),
            ),

            Positioned(
              top: 0, left: 0, right: 0, bottom: _barHeight,
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.88,
                  heightFactor: 0.88,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: Image.asset(
                      assetImagePath,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.chair, size: 72, color: Colors.black45),
                    ),
                  ),
                ),
              ),
            ),

            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      (table.tableNumber ?? '').toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: onTopTextColor,
                        shadows: const [Shadow(blurRadius: 6, color: Colors.black54)],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: _barHeight,
                  padding: const EdgeInsets.symmetric(horizontal: kActionsGap, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(_radius),
                      bottomRight: Radius.circular(_radius),
                    ),
                  ),
                  child: Row(
                    children: [
                      _BarIconButton(icon: Icons.add, onTap: onAddOrder),
                      const SizedBox(width: kActionsGap),
                      _BarIconButton(icon: Icons.receipt_long_outlined, onTap: onExportInvoice),
                      // const SizedBox(width: kActionsGap),
                      // _BarIconButton(icon: Icons.local_offer_outlined, onTap: onAddCoupon),

                      const Spacer(),

                      _MoreActionsButton(
                        onDetails: onDetails,
                        onEdit: onEdit,
                        onDelete: onDelete,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _MoreActionsButton extends StatelessWidget {
  const _MoreActionsButton({
    this.onDetails,
    this.onEdit,
    this.onDelete,
  });

  final VoidCallback? onDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      tooltip: 'إجراءات',
      onPressed: () => _showActionsSheet(context),
    );
  }

  void _showActionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionTile(
                icon: Icons.remove_red_eye_outlined,
                label: 'عرض التفاصيل',
                onTap: onDetails,
              ),
              _ActionTile(
                icon: Icons.edit_outlined,
                label: 'تعديل',
                onTap: onEdit,
              ),
              _ActionTile(
                icon: Icons.delete_outline,
                label: 'حذف',
                isDestructive: true,
                onTap: onDelete,
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFE53935) : Colors.black87;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
      },
    );
  }
}


class _BarIconButton extends StatelessWidget {
  const _BarIconButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const side = 28.5;
    const iconSize = 23.0;

    return SizedBox(
      width: side,
      height: side,
      child: InkResponse(
        onTap: onTap,
        radius: side / 2 + 4,
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}

class _AddTableChip extends StatelessWidget {
  const _AddTableChip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 36,
        padding: const EdgeInsetsDirectional.only(start: 12, end: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Text(
              'إضافة طاولة',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
              ),
            ),
            SizedBox(width: 8),
            CircleAvatar(
              radius: 11,
              backgroundColor: Colors.white,
              child: Icon(Icons.add, size: 16, color: Color(0xFFE53935)),
            ),
          ],
        ),
      ),
    );
  }
}
