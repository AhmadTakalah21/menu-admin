import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/utils/app_colors.dart';

import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

abstract class DeleteModel {
  String get apiDeleteUrl;

  String get apiDeactivateUrl;

  bool get isActive;
}

class InsureDeleteWidget<T extends DeleteModel> extends StatefulWidget {
  const InsureDeleteWidget({
    super.key,
    required this.item,
    required this.onSaveTap,
    required this.isDelete,
  });

  final bool isDelete;
  final T item;
  final ValueSetter<T> onSaveTap;

  @override
  State<InsureDeleteWidget<T>> createState() => _InsureDeleteWidgetState<T>();
}

class _InsureDeleteWidgetState<T extends DeleteModel>
    extends State<InsureDeleteWidget<T>> {
  late final AppManagerCubit appManagerCubit = context.read();
  late final ItemsCubit itemsCubit = context.read();

  void onIgnoreTap(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isDelete
                    ? "insure_delete".tr()
                    : widget.item.isActive
                        ? "insure_deactivate".tr()
                        : "insure_activate".tr(),
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () => onIgnoreTap(context),
                child: const Icon(
                  Icons.close,
                  color: AppColors.greyShade,
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Text(
            widget.isDelete
                ? "sure_delete_order".tr()
                : widget.item.isActive
                    ? "sure_deactivation".tr()
                    : "sure_activation".tr(),
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
            ),
          ),
          const Divider(height: 30),
          Row(
            children: [
              BlocConsumer<DeleteCubit, DeleteState>(
                listener: (context, state) {
                  if (state is DeleteSuccess) {
                    appManagerCubit.emitDeleteSuccess(widget.item);

                    onIgnoreTap(context);
                    MainSnackBar.showSuccessMessage(context, state.message);
                  } else if (state is DeleteFail) {
                    MainSnackBar.showErrorMessage(context, state.error);
                  } else if (state is ActivateSuccess) {
                    appManagerCubit.emitDeleteSuccess(widget.item);
                    
                    onIgnoreTap(context);
                    MainSnackBar.showSuccessMessage(context, state.message);
                  } else if (state is ActivateFail) {
                    MainSnackBar.showErrorMessage(context, state.error);
                  }
                },
                builder: (context, state) {
                  var onTap = widget.onSaveTap;
                  Widget? child;
                  if (state is DeleteLoading) {
                    onTap = (T order) {};
                    child = const LoadingIndicator(size: 20);
                  }
                  return MainActionButton(
                    padding: AppConstants.padding6,
                    buttonColor: AppColors.redShade,
                    onPressed: () => onTap(widget.item),
                    text: "save".tr(),
                    child: child,
                  );
                },
              ),
              const SizedBox(width: 5),
              MainActionButton(
                padding: AppConstants.padding6,
                buttonColor: AppColors.greyShade,
                onPressed: () => onIgnoreTap(context),
                text: "ignore".tr(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
