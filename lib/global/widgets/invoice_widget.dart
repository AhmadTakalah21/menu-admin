import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/global/localization/supported_locales.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/info_tile.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

import '../../features/sign_in/model/sign_in_model/sign_in_model.dart';

class CouponOption {
  final int id;
  final String code;
  final int? percent;
  const CouponOption({
    required this.id,
    required this.code,
    this.percent,
  });

  String get label => percent == null ? code : '$code — ${percent}%';
}

class TitleValueModel {
  final String title;
  final String value;
  TitleValueModel(this.title, this.value);
}

class InvoiceWidget extends StatefulWidget {
  const InvoiceWidget({
    super.key,
    required this.invoice,

    this.fetchCoupons,

    this.applyCoupon,

    this.onClose,
  });

  final DrvierInvoiceModel invoice;

  final Future<List<CouponOption>> Function()? fetchCoupons;

  final Future<DrvierInvoiceModel> Function(int couponId)? applyCoupon;

  final VoidCallback? onClose;

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  late DrvierInvoiceModel _invoice;
  final ScreenshotController _screenshotController = ScreenshotController();
  late final locale = context.locale;

  bool _applyingCoupon = false;
  CouponOption? _appliedCoupon;

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;
  }

  Future<Uint8List> _generatePdf([DrvierInvoiceModel? inv]) async {
    final invoice = inv ?? _invoice;

    final price = invoice.price;
    final deliveryPrice = invoice.deliveryPrice;
    final discount = invoice.discount;
    final total = invoice.total;
    final consumerSpending = invoice.consumerSpending;
    final localAdministration = invoice.localAdministration;
    final reconstruction = invoice.reconstruction;

    final orderDetailsTitles = [
      "name".tr(),
      "price".tr(),
      "count".tr(),
      "total".tr(),
    ];
    final invoiceSummary = [
      TitleValueModel("invoice_id".tr(), invoice.number.toString()),
      TitleValueModel("order_date".tr(), invoice.createdAt),
    ];

    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/Tajawal-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    final textDirection = locale == SupportedLocales.arabic
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;

    pw.Widget _kv(String k, String v) => pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text('${k.tr()} : ', style: pw.TextStyle(font: ttf, fontSize: 14)),
        pw.Text(v, style: pw.TextStyle(font: ttf, fontSize: 15)),
      ],
    );

    pdf.addPage(
      pw.Page(
        textDirection: textDirection,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("invoice_summary".tr(), style: pw.TextStyle(font: ttf, fontSize: 17)),
            pw.SizedBox(height: 12),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              columnWidths: const {
                0: pw.FractionColumnWidth(1.2 / 3),
                1: pw.FractionColumnWidth(1.8 / 3),
              },
              children: invoiceSummary
                  .map(
                    (e) => pw.TableRow(
                  decoration: e.title == "invoice_id".tr()
                      ? const pw.BoxDecoration(color: PdfColors.grey)
                      : null,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        e.title,
                        style: pw.TextStyle(font: ttf, color: PdfColors.black, fontSize: 14),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        e.value,
                        style: pw.TextStyle(font: ttf, color: PdfColors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )
                  .toList(),
            ),
            pw.SizedBox(height: 16),
            pw.Text("invoice_details".tr(), style: pw.TextStyle(font: ttf, fontSize: 20)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey),
                  children: orderDetailsTitles
                      .map(
                        (e) => pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(e, style: pw.TextStyle(font: ttf, fontSize: 14)),
                    ),
                  )
                      .toList(),
                ),
                ...invoice.orders.map((e) {
                  final orderDetailsInfo = [
                    locale == SupportedLocales.arabic ? e.nameAr : e.nameEn,
                    e.price.toString(),
                    e.count.toString(),
                    e.total?.toString() ?? (e.price * e.count).toString(),
                  ];
                  return pw.TableRow(
                    children: orderDetailsInfo
                        .map(
                          (v) => pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(v ?? "_", style: pw.TextStyle(font: ttf, fontSize: 14)),
                      ),
                    )
                        .toList(),
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Text("additional_info".tr(), style: pw.TextStyle(font: ttf, fontSize: 17)),
            pw.SizedBox(height: 10),
            if (price != null) _kv('sum', price),
            if (consumerSpending != null) pw.SizedBox(height: 6),
            if (consumerSpending != null) _kv('consumer_spending', consumerSpending.toString()),
            if (localAdministration != null) pw.SizedBox(height: 6),
            if (localAdministration != null) _kv('local_administration', localAdministration.toString()),
            if (reconstruction != null) pw.SizedBox(height: 6),
            if (reconstruction != null) _kv('reconstruction', reconstruction.toString()),
            if (deliveryPrice != null && !deliveryPrice.contains("null")) pw.SizedBox(height: 6),
            if (deliveryPrice != null && !deliveryPrice.contains("null"))
              _kv('delivery_price', deliveryPrice.toString()),
            if (discount != null) pw.SizedBox(height: 6),
            if (discount != null) _kv('discount', discount),
            if (total != null && total != price) pw.SizedBox(height: 6),
            if (total != null && total != price) _kv('total', total),
            if (_appliedCoupon != null) pw.SizedBox(height: 6),
            if (_appliedCoupon != null) _kv('coupon', _appliedCoupon!.label),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  // ===== Actions =====
  Future<void> _onShareTap() async {
    final pdfBytes = await _generatePdf();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/invoice.pdf';

    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    final xFile = XFile(file.path, mimeType: 'application/pdf', name: 'invoice.pdf');
    final result = await Share.shareXFiles([xFile]);

    if (!mounted) return;
    if (result.status == ShareResultStatus.success) {
      MainSnackBar.showSuccessMessage(context, "shared_successfully".tr());
    } else if (result.status == ShareResultStatus.dismissed) {
      MainSnackBar.showErrorMessage(context, "share_dismissed".tr());
    }
  }

  Future<void> _onPrintTap() async {
    final bytes = await _generatePdf();
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> _showCouponPicker() async {
    if (widget.fetchCoupons == null || widget.applyCoupon == null) {
      MainSnackBar.showErrorMessage(context, "operation_not_supported".tr());
      return;
    }

    try {
      final options = await widget.fetchCoupons!.call();
      if (!mounted) return;

      final selected = await showModalBottomSheet<CouponOption>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  height: 4, width: 44,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "choose_coupon".tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),

                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (ctx, i) {
                      final c = options[i];
                      return ListTile(
                        leading: const Icon(Icons.local_offer_outlined),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.code, // الكود
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (c.percent != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${c.percent}%',
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                          ],
                        ),
                        onTap: () => Navigator.of(ctx).pop(c),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );

      if (selected == null) return;

      setState(() => _applyingCoupon = true);

      final updatedInvoice = await widget.applyCoupon!(selected.id);
      if (!mounted) return;

      setState(() {
        _invoice = updatedInvoice;
        _appliedCoupon = selected;
        _applyingCoupon = false;
      });

      MainSnackBar.showSuccessMessage(context, "coupon_applied".tr());
    } catch (e) {
      if (!mounted) return;
      setState(() => _applyingCoupon = false);
      MainSnackBar.showErrorMessage(context, e.toString());
    }
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    final SignInModel signInModel;
    final price = _invoice.price;
    final deliveryPrice = _invoice.deliveryPrice;
    final discount = _invoice.discount;
    final total = _invoice.total;
    final consumerSpending = _invoice.consumerSpending;
    final localAdministration = _invoice.localAdministration;
    final reconstruction = _invoice.reconstruction;

    final orderDetailsTitles = [
      "name".tr(),
      "price".tr(),
      "count".tr(),
      "total".tr(),
    ];
    final invoiceSummary = [
      TitleValueModel("invoice_id".tr(), _invoice.number.toString()),
      TitleValueModel("order_date".tr(), _invoice.createdAt),
    ];

    void onClose() {
      Navigator.pop(context);
      widget.onClose?.call();
    }

    final screenW = MediaQuery.sizeOf(context).width;
    final maxSide = screenW * 0.85;
    final side = maxSide.clamp(525.0, 850.0);
    final dlgWidth = math.min(MediaQuery.sizeOf(context).width * 0.99, 560.0);

    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SizedBox(
        width: dlgWidth,
        height: side,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // رأس أنيق
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(.95),
                ),
                child: Row(
                  children: [
                    Text(
                      "invoice_details".tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: 'Close',
                    )
                  ],
                ),
              ),

              // المحتوى
              Expanded(
                child: Screenshot(
                  controller: _screenshotController,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [

                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "invoice_summary".tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Table(
                                  border: TableBorder.symmetric(
                                    inside: const BorderSide(color: AppColors.grey, width: .5),
                                  ),
                                  columnWidths: const {
                                    0: FractionColumnWidth(1.2 / 3),
                                    1: FractionColumnWidth(1.8 / 3),
                                  },
                                  children: invoiceSummary
                                      .map(
                                        (e) => TableRow(
                                      decoration: e.title == "invoice_id".tr()
                                          ? BoxDecoration(color: AppColors.grey.withOpacity(0.2))
                                          : null,
                                      children: [
                                        Padding(
                                          padding: AppConstants.padding6,
                                          child: Text(e.title, style: const TextStyle(fontSize: 13)),
                                        ),
                                        Padding(
                                          padding: AppConstants.padding6,
                                          child: Text(e.value, style: const TextStyle(fontSize: 13)),
                                        ),
                                      ],
                                    ),
                                  )
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "order_details".tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SingleChildScrollView(
                                      child: Table(
                                        border: TableBorder.all(width: 0.5, color: AppColors.grey),
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.15)),
                                            children: orderDetailsTitles
                                                .map(
                                                  (e) => Padding(
                                                padding: AppConstants.padding6,
                                                child: Text(e, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                              ),
                                            )
                                                .toList(),
                                          ),
                                          ..._invoice.orders.map((e) {
                                            final orderDetailsInfo = [
                                              locale == SupportedLocales.arabic ? e.nameAr : e.nameEn,
                                              e.price.toString(),
                                              e.count.toString(),
                                              e.total?.toString() ?? (e.price * e.count).toString(),
                                            ];
                                            return TableRow(
                                              children: orderDetailsInfo
                                                  .map(
                                                    (v) => Padding(
                                                  padding: AppConstants.padding6,
                                                  child: Text(v ?? "_", style: const TextStyle(fontSize: 13)),
                                                ),
                                              )
                                                  .toList(),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // العمود الأيمن: ملخص مالي + كوبون + أزرار
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "additional_info".tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (price != null)
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.money, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: InfoTile(
                                                "sum".tr(),
                                                price,
                                                titleSize: 14,
                                                titleFontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (consumerSpending != null) const Divider(height: 14),
                                      if (consumerSpending != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.money, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: InfoTile(
                                                "consumer_spending".tr(),
                                                consumerSpending.toString(),
                                                titleSize: 14,
                                                titleFontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (localAdministration != null) const Divider(height: 14),
                                      if (localAdministration != null)
                                        Row(
                                          children: [
                                            const Icon(FontAwesomeIcons.building, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: InfoTile(
                                                "local_administration".tr(),
                                                localAdministration.toString(),
                                                titleSize: 14,
                                                titleFontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (reconstruction != null) const Divider(height: 14),
                                      if (reconstruction != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.construction, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: InfoTile(
                                                "reconstruction".tr(),
                                                reconstruction.toString(),
                                                titleSize: 14,
                                                titleFontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (deliveryPrice != null && !deliveryPrice.contains("null"))
                                        const Divider(height: 14),
                                      if (deliveryPrice != null && !deliveryPrice.contains("null"))
                                        Row(
                                          children: [
                                            const Icon(Icons.pedal_bike, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: InfoTile(
                                                "delivery_price".tr(),
                                                deliveryPrice.toString(),
                                                titleSize: 14,
                                                titleFontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (discount != null) const Divider(height: 14),
                                      if (discount != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.percent, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: InfoTile(
                                                "discount".tr(),
                                                discount,
                                                titleSize: 14,
                                                titleFontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),

                                      if (_appliedCoupon != null) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.local_offer, size: 16),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Wrap(
                                                children: [
                                                  Chip(
                                                    label: Text(
                                                      _appliedCoupon!.label,
                                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                                    ),
                                                    backgroundColor: Colors.green.shade50,
                                                    avatar: const Icon(Icons.check, size: 16, color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],

                                      if (total != null && total != price) const Divider(height: 14),
                                      if (total != null && total != price)
                                        Row(
                                          children: [
                                            const Icon(Icons.description, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: InfoTile(
                                                "total".tr(),
                                                total,
                                                titleSize: 14,
                                                titleFontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),

                                      if (widget.fetchCoupons != null && widget.applyCoupon != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton.icon(
                                              onPressed: _applyingCoupon ? null : _showCouponPicker,
                                              icon: _applyingCoupon
                                                  ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              )
                                                  : const Icon(Icons.local_offer_outlined),
                                              label: Text(
                                                _appliedCoupon == null
                                                    ? "add_coupon".tr()
                                                    : "change_coupon".tr(),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      MainActionButton(
                                        padding: AppConstants.padding10,
                                        onPressed: _onShareTap,
                                        text: "share_pdf".tr(),
                                      ),
                                      MainActionButton(
                                        padding: AppConstants.padding10,
                                        onPressed: _onPrintTap,
                                        text: "print".tr(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
