import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/ratings/cubit/ratings_cubit.dart';
import 'package:user_admin/features/ratings/model/rate_model/rate_model.dart';
import 'package:user_admin/features/ratings/view/ratings_view.dart';
import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/model/drawer_tile_enum.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key, required this.signInModel});

  final SignInModel signInModel;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late final AppManagerCubit appManagerCubit = context.read();
  late final RatingsCubit ratingsCubit = context.read();
  late final SignInCubit signInCubit = context.read();

  bool isShowSubRating = false;
  bool isShowSubEmployeesDetails = false;

  @override
  void initState() {
    super.initState();
    ratingsCubit.getRatings(null);
  }

  void onRatingTap(bool canExportExcel) {
    if (canExportExcel) {
      setState(() {
        isShowSubRating = !isShowSubRating;
      });
    } else {
      onShowRatingsView();
    }
  }

  void onShowRatingsView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingsView(signInModel: widget.signInModel),
      ),
    );
  }

  Future<void> goToUserInterface() async {
    final url = Uri.parse("https://menu-new-f.medical-clinic.serv00.net/messi");
    if (!await launchUrl(url)) {
      if (!mounted) return;
      MainSnackBar.showErrorMessage(context, 'Could not go to user app');
    }
  }

  Future<void> onExportRatingsData(List<RateModel> ratings) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }

    List<List<CellValue?>> list = [
      [
        TextCellValue("rating".tr()),
        TextCellValue("note".tr()),
        TextCellValue("name".tr()),
        TextCellValue("restaurant_name".tr()),
      ],
    ];
    final listOfData = List.generate(
      ratings.length,
          (index) {
        return [
          TextCellValue(ratings[index].rate.toString()),
          TextCellValue(ratings[index].note),
          TextCellValue(ratings[index].name),
          TextCellValue(widget.signInModel.restaurant.name ?? ""),
        ];
      },
    );
    for (var data in listOfData) {
      list.add(data);
    }

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    CellStyle cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);

    for (int rowIndex = 0; rowIndex < list.length; rowIndex++) {
      var row = list[rowIndex];
      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        var cell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
        );
        cell.value = row[colIndex];
        cell.cellStyle = cellStyle;
      }
    }

    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    String outputFile = "${directory!.path}/Ratings.xlsx";

    final fileBytes = excel.encode();
    final file = File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    final result = await Share.shareXFiles([XFile(file.path)]);

    if (!mounted) return;
    if (result.status == ShareResultStatus.success) {
      MainSnackBar.showSuccessMessage(context, "shared_successfully".tr());
    } else if (result.status == ShareResultStatus.dismissed) {
      MainSnackBar.showErrorMessage(context, "share_dismissed".tr());
    }
  }

  void logout() {
    signInCubit.signOut();
  }

  @override
  Widget build(BuildContext context) {
    int exportExcel = widget.signInModel.permissions.indexWhere(
          (element) => element.name == "excel",
    );
    bool canExportExcel = exportExcel != -1;
    return Drawer(
      backgroundColor: AppColors.mainColor,
      child: Padding(
        padding: AppConstants.padding16,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "admin".tr(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Image.asset(
                "assets/images/logo.png",
              ),
              Column(
                children: List.generate(
                  DrawerTileEnum.values.length,
                      (index) {
                    final tile = DrawerTileEnum.values[index];
                    Widget? trailing;
                    var onTap = tile.onTap(context, widget.signInModel);
                    if (tile == DrawerTileEnum.logout) {
                      onTap = logout;
                    } else if (tile == DrawerTileEnum.ratings) {
                      onTap = () => onRatingTap(canExportExcel);
                      trailing = canExportExcel
                          ? const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.white,
                      )
                          : null;
                    } else if (tile == DrawerTileEnum.userUi) {
                      onTap = () => goToUserInterface();
                    }
                    return Column(
                      children: [
                        if (tile
                            .isHasPermission(widget.signInModel.permissions))
                          BlocBuilder<SignInCubit, GeneralSignInState>(
                            builder: (context, state) {
                              Widget leading = Icon(
                                tile.icon,
                                color: AppColors.white,
                              );
                              if (state is SignInLoading &&
                                  tile == DrawerTileEnum.logout) {
                                leading = const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: LoadingIndicator(size: 30),
                                );
                                onTap = () {};
                              }
                              return ListTile(
                                onTap: onTap,
                                leading: leading,
                                title: Text(
                                  tile.displayName,
                                  style:
                                  const TextStyle(color: AppColors.white),
                                ),
                                trailing: trailing,
                              );
                            },
                          ),
                        if (isShowSubRating && tile == DrawerTileEnum.ratings)
                          Padding(
                            padding: AppConstants.paddingH8,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: onShowRatingsView,
                                  leading:
                                  Icon(tile.icon, color: AppColors.white),
                                  title: Text(
                                    tile.displayName,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (canExportExcel)
                                  BlocBuilder<RatingsCubit,
                                      GeneralRatingsState>(
                                    builder: (context, state) {
                                      if (state is RatingsLoading) {
                                        return const LoadingIndicator();
                                      } else if (state is RatingsSuccess) {
                                        final ratings =
                                            state.paginatedModel.data;
                                        return ListTile(
                                          onTap: () =>
                                              onExportRatingsData(ratings),
                                          leading: const Icon(
                                            Icons.logout,
                                            color: AppColors.white,
                                          ),
                                          title: Text(
                                            "export_ratings_data".tr(),
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
