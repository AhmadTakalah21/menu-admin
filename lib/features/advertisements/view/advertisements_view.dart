import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/advertisements/cubit/advertisements_cubit.dart';
import 'package:user_admin/features/advertisements/model/advertisement_model/advertisement_model.dart';
import 'package:user_admin/features/advertisements/view/widgets/add_advertisement_widget.dart';
import 'package:user_admin/features/advertisements/view/widgets/advertisement_tile.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';

abstract class AdvertisementsViewCallBacks {
  void onAddTap();

  Future<void> onRefresh();

  void onEditTap(AdvertisementModel advertisement);

  void onDeleteTap(AdvertisementModel advertisement);

  void onSaveDeleteTap(AdvertisementModel advertisement);

  void onTryAgainTap();
}

class AdvertisementsView extends StatelessWidget {
  const AdvertisementsView({super.key, required this.signInModel});

  final SignInModel signInModel;

  @override
  Widget build(BuildContext context) {
    return AdvertisemntsPage(signInModel: signInModel);
  }
}

class AdvertisemntsPage extends StatefulWidget {
  const AdvertisemntsPage({super.key, required this.signInModel});

  final SignInModel signInModel;

  @override
  State<AdvertisemntsPage> createState() => _AdvertisemntsPageState();
}

class _AdvertisemntsPageState extends State<AdvertisemntsPage>
    implements AdvertisementsViewCallBacks {
  late final AdvertisementsCubit advertisementsCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  late final StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    advertisementsCubit.getAdvertisements(isRefresh: true);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        advertisementsCubit.getAdvertisements(isRefresh: true);
      } else {
        advertisementsCubit.getAdvertisements(isRefresh: false);
      }
    });
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) {
        return const AddAdvertisementWidget(isEdit: false);
      },
    );
  }

  @override
  void onDeleteTap(AdvertisementModel advertisement) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: advertisement,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onEditTap(AdvertisementModel advertisement) {
    showDialog(
      context: context,
      builder: (context) {
        return AddAdvertisementWidget(
          advertisement: advertisement,
          isEdit: true,
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    advertisementsCubit.getAdvertisements(isRefresh: true);
  }

  @override
  void onTryAgainTap() {
    advertisementsCubit.getAdvertisements(isRefresh: true);
  }

  @override
  void onSaveDeleteTap(AdvertisementModel advertisement) {
    deleteCubit.deleteItem<AdvertisementModel>(advertisement);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int addIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "advertisement.add",
    );
    int editIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "advertisement.update",
    );
    int deleteIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "advertisement.delete",
    );
    bool isAdd = addIndex != -1;
    bool isEdit = editIndex != -1;
    bool isDelete = deleteIndex != -1;

    final restColor = widget.signInModel.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState) {
          advertisementsCubit.getAdvertisements(isRefresh: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        drawer: MainDrawer(signInModel: widget.signInModel),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                children: [
                  MainBackButton(color: restColor ?? AppColors.black),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "advertisements".tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      MainActionButton(
                        padding: AppConstants.padding10,
                        onPressed: onRefresh,
                        text: "",
                        child:
                            const Icon(Icons.refresh, color: AppColors.white),
                      ),
                      if (isAdd) const SizedBox(width: 10),
                      if (isAdd)
                        MainActionButton(
                          padding: AppConstants.padding10,
                          onPressed: onAddTap,
                          text: "Add Category",
                          child: const Icon(
                            Icons.add_circle,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AdvertisementsCubit, GeneralAdvertisementsState>(
                    buildWhen: (previous, current) =>
                        current is AdvertisementsState,
                    builder: (context, state) {
                      if (state is AdvertisementsLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is AdvertisementsSuccess) {
                        return Padding(
                          padding: AppConstants.paddingH60,
                          child: ListView.separated(
                            itemCount: state.advertisements.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final advertisement = state.advertisements[index];
                              return AdvertisementTile(
                                advertisement: advertisement,
                                restaurant: widget.signInModel.restaurant,
                                onEditTap: isEdit ? onEditTap : null,
                                onDeleteTap: isDelete ? onDeleteTap : null,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                          ),
                        );
                      } else if (state is AdvertisementsEmpty) {
                        return MainErrorWidget(error: state.message);
                      } else if (state is AdvertisementsFail) {
                        return MainErrorWidget(
                          error: state.error,
                          onTryAgainTap: onTryAgainTap,
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
