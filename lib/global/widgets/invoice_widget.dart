import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/global/localization/supported_locales.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/info_tile.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:user_admin/global/widgets/main_snack_bar.dart';

class TitleValueModel {
  final String title;
  final String value;

  TitleValueModel(this.title, this.value);
}

class InvoiceWidget extends StatefulWidget {
  const InvoiceWidget({super.key, required this.invoice});

  final DrvierInvoiceModel invoice;

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  ScreenshotController screenshotController = ScreenshotController();
  late final locale = context.locale;

  Future<Uint8List> generatePdf() async {
    final price = widget.invoice.price;
    final deliveryPrice = widget.invoice.deliveryPrice;
    final discount = widget.invoice.discount;
    final total = widget.invoice.total;
    final consumerSpending = widget.invoice.consumerSpending;
    final localAdministration = widget.invoice.localAdministration;
    final reconstruction = widget.invoice.reconstruction;
    final orderDetailsTitles = [
      "name".tr(),
      "price".tr(),
      "count".tr(),
      "total".tr(),
    ];
    final invoiceSummary = [
      TitleValueModel("invoice_id".tr(), widget.invoice.number.toString()),
      TitleValueModel("order_date".tr(), widget.invoice.createdAt),
    ];

    final pdf = pw.Document();

    final font = await rootBundle.load("assets/fonts/Tajawal-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    final textDirection = locale == SupportedLocales.arabic
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;

    final crossAlignment = locale == SupportedLocales.arabic
        ? pw.CrossAxisAlignment.end
        : pw.CrossAxisAlignment.start;

    final mainAlignment = locale == SupportedLocales.arabic
        ? pw.MainAxisAlignment.end
        : pw.MainAxisAlignment.start;
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: crossAlignment,
          children: [
            pw.Text(
              "invoice_summary".tr(),
              style: pw.TextStyle(
                font: ttf,
                fontSize: 17,
                color: PdfColors.black,
              ),
              textDirection: textDirection,
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              columnWidths: const {
                0: pw.FractionColumnWidth(1.2 / 3),
                1: pw.FractionColumnWidth(1.8 / 3),
              },
              children: invoiceSummary.map(
                (e) {
                  return pw.TableRow(
                    decoration: e.title == "invoice_id".tr()
                        ? const pw.BoxDecoration(
                            color: PdfColors.grey,
                          )
                        : null,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          e.title,
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontSize: 14,
                          ),
                          textDirection: textDirection,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          e.value,
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontSize: 14,
                          ),
                          textDirection: textDirection,
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "invoice_details".tr(),
              style: pw.TextStyle(
                font: ttf,
                fontSize: 20,
                color: PdfColors.black,
              ),
              textDirection: textDirection,
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey),
                  children: orderDetailsTitles.map(
                    (e) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          e,
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontSize: 14,
                          ),
                          textDirection: textDirection,
                        ),
                      );
                    },
                  ).toList(),
                ),
                ...widget.invoice.orders.map(
                  (e) {
                    final orderDetailsInfo = [
                      locale == SupportedLocales.arabic ? e.nameAr : e.nameEn,
                      e.price.toString(),
                      e.count.toString(),
                      e.total?.toString() ?? (e.price * e.count).toString(),
                    ];
                    return pw.TableRow(
                      children: orderDetailsInfo.map(
                        (e) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              e ?? "_",
                              style: pw.TextStyle(
                                font: ttf,
                                color: PdfColors.black,
                                fontSize: 14,
                              ),
                              textDirection: textDirection,
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "additional_info".tr(),
              style: pw.TextStyle(
                font: ttf,
                fontSize: 17,
                color: PdfColors.black,
              ),
              textDirection: textDirection,
            ),
            pw.SizedBox(height: 20),
            pw.Column(
              children: [
                if (price != null)
                  pw.Row(
                    mainAxisAlignment: mainAlignment,
                    children: [
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? price
                            : "${"sum".tr()} : ",
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 16,
                        ),
                        textDirection: textDirection,
                      ),
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? "${"sum".tr()} : "
                            : price,
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.black,
                          fontSize: 17,
                        ),
                        textDirection: textDirection,
                      ),
                    ],
                  ),
                if (consumerSpending != null) pw.Divider(height: 10),
                if (consumerSpending != null)
                  pw.Row(
                    mainAxisAlignment: mainAlignment,
                    children: [
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? consumerSpending.toString()
                            : "${"consumer_spending".tr()} : ",
                        style: pw.TextStyle(font: ttf, fontSize: 16),
                        textDirection: textDirection,
                      ),
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? "${"consumer_spending".tr()} : "
                            : consumerSpending.toString(),
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.black,
                          fontSize: 17,
                        ),
                        textDirection: textDirection,
                      ),
                    ],
                  ),
                if (localAdministration != null) pw.Divider(height: 10),
                if (localAdministration != null)
                  pw.Row(
                    mainAxisAlignment: mainAlignment,
                    children: [
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? localAdministration.toString()
                            : "${"local_administration".tr()} : ",
                        style: pw.TextStyle(font: ttf, fontSize: 16),
                        textDirection: textDirection,
                      ),
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? "${"local_administration".tr()} : "
                            : localAdministration.toString(),
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.black,
                          fontSize: 17,
                        ),
                        textDirection: textDirection,
                      ),
                    ],
                  ),
                if (reconstruction != null) pw.Divider(height: 10),
                if (reconstruction != null)
                  pw.Row(
                    mainAxisAlignment: mainAlignment,
                    children: [
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? reconstruction.toString()
                            : "${"reconstruction".tr()} : ",
                        style: pw.TextStyle(font: ttf, fontSize: 16),
                        textDirection: textDirection,
                      ),
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? "${"reconstruction".tr()} : "
                            : reconstruction.toString(),
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.black,
                          fontSize: 17,
                        ),
                        textDirection: textDirection,
                      ),
                    ],
                  ),
                if (deliveryPrice != null && !deliveryPrice.contains("null"))
                  pw.Divider(height: 10),
                if (deliveryPrice != null && !deliveryPrice.contains("null"))
                  pw.Row(
                    mainAxisAlignment: mainAlignment,
                    children: [
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? deliveryPrice.toString()
                            : "${"delivery_price".tr()} : ",
                        style: pw.TextStyle(font: ttf, fontSize: 16),
                        textDirection: textDirection,
                      ),
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? "${"delivery_price".tr()} : "
                            : deliveryPrice.toString(),
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.black,
                          fontSize: 17,
                        ),
                        textDirection: textDirection,
                      ),
                    ],
                  ),
                if (discount != null) pw.Divider(height: 10),
                if (discount != null)
                  pw.Row(
                    mainAxisAlignment: mainAlignment,
                    children: [
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? discount
                            : "${"discount".tr()} : ",
                        style: pw.TextStyle(font: ttf, fontSize: 16),
                        textDirection: textDirection,
                      ),
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? "${"discount".tr()} : "
                            : discount,
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.black,
                          fontSize: 17,
                        ),
                        textDirection: textDirection,
                      ),
                    ],
                  ),
                if (total != null && total != price) pw.Divider(height: 10),
                if (total != null && total != price)
                  pw.Row(
                    mainAxisAlignment: mainAlignment,
                    children: [
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? total
                            : "${"total".tr()} : ",
                        style: pw.TextStyle(font: ttf, fontSize: 16),
                        textDirection: textDirection,
                      ),
                      pw.Text(
                        locale == SupportedLocales.arabic
                            ? "${"total".tr()} : "
                            : total,
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.black,
                          fontSize: 17,
                        ),
                        textDirection: textDirection,
                      ),
                    ],
                  ),
              ],
            )
          ],
        ),
      ),
    );
    return pdf.save();
  }

  Future<void> onShareTap() async {
    final pdfBytes = await generatePdf();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/invoice.pdf';

    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    final xFile = XFile(
      file.path,
      mimeType: 'application/pdf',
      name: 'invoice.pdf',
    );

    final result = await Share.shareXFiles([xFile]);

    if (!mounted) return;

    if (result.status == ShareResultStatus.success) {
      MainSnackBar.showSuccessMessage(context, "shared_successfully".tr());
    } else if (result.status == ShareResultStatus.dismissed) {
      MainSnackBar.showErrorMessage(context, "share_dismissed".tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.invoice.price;
    final deliveryPrice = widget.invoice.deliveryPrice;
    final discount = widget.invoice.discount;
    final total = widget.invoice.total;
    final consumerSpending = widget.invoice.consumerSpending;
    final localAdministration = widget.invoice.localAdministration;
    final reconstruction = widget.invoice.reconstruction;

    final orderDetailsTitles = [
      "name".tr(),
      "price".tr(),
      "count".tr(),
      "total".tr(),
    ];
    final invoiceSummary = [
      TitleValueModel("invoice_id".tr(), widget.invoice.number.toString()),
      TitleValueModel("order_date".tr(), widget.invoice.createdAt),
    ];

    void onIgnoreTap(BuildContext context) {
      Navigator.pop(context);
    }

    return AlertDialog(
      scrollable: true,
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding12,
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "invoice_details".tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
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
            Screenshot(
              controller: screenshotController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "invoice_summary".tr(),
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(width: 0.5, color: AppColors.grey),
                    columnWidths: const {
                      0: FractionColumnWidth(1.2 / 3),
                      1: FractionColumnWidth(1.8 / 3),
                    },
                    children: invoiceSummary.map(
                      (e) {
                        return TableRow(
                          decoration: e.title == "invoice_id".tr()
                              ? BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.2),
                                )
                              : null,
                          children: [
                            Padding(
                              padding: AppConstants.padding4,
                              child: Text(
                                e.title,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: AppConstants.padding4,
                              child: Text(
                                e.value,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "order_details".tr(),
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(width: 0.5, color: AppColors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(0.2),
                        ),
                        children: orderDetailsTitles.map(
                          (e) {
                            return Padding(
                              padding: AppConstants.padding4,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      ...widget.invoice.orders.map(
                        (e) {
                          final orderDetailsInfo = [
                            locale == SupportedLocales.arabic
                                ? e.nameAr
                                : e.nameEn,
                            e.price.toString(),
                            e.count.toString(),
                            e.total?.toString() ??
                                (e.price * e.count).toString(),
                          ];
                          return TableRow(
                            children: orderDetailsInfo.map(
                              (e) {
                                return Padding(
                                  padding: AppConstants.padding4,
                                  child: Text(
                                    e ?? "_",
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "additional_info".tr(),
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (price != null)
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.money, size: 16),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 200,
                          child: InfoTile(
                            "sum".tr(),
                            price,
                            titleSize: 16,
                            titleFontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  if (consumerSpending != null) const Divider(height: 10),
                  if (consumerSpending != null)
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.money, size: 16),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 200,
                          child: InfoTile(
                            "consumer_spending".tr(),
                            consumerSpending.toString(),
                            titleSize: 16,
                            titleFontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  if (localAdministration != null) const Divider(height: 10),
                  if (localAdministration != null)
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(FontAwesomeIcons.building, size: 16),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 200,
                          child: InfoTile(
                            "local_administration".tr(),
                            localAdministration.toString(),
                            titleSize: 16,
                            titleFontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  if (reconstruction != null) const Divider(height: 10),
                  if (reconstruction != null)
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.construction, size: 16),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 200,
                          child: InfoTile(
                            "reconstruction".tr(),
                            reconstruction.toString(),
                            titleSize: 16,
                            titleFontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  if (deliveryPrice != null && !deliveryPrice.contains("null"))
                    const Divider(height: 10),
                  if (deliveryPrice != null && !deliveryPrice.contains("null"))
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.pedal_bike, size: 16),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 200,
                          child: InfoTile(
                            "delivery_price".tr(),
                            deliveryPrice.toString(),
                            titleSize: 16,
                            titleFontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  if (discount != null) const Divider(height: 10),
                  if (discount != null)
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.percent, size: 16),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 200,
                          child: InfoTile(
                            "discount".tr(),
                            discount,
                            titleSize: 16,
                            titleFontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  if (total != null && total != price)
                    const Divider(height: 10),
                  if (total != null && total != price)
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.description, size: 16),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 200,
                          child: InfoTile(
                            "total".tr(),
                            total,
                            titleSize: 16,
                            titleFontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: MainActionButton(
                padding: AppConstants.padding10,
                onPressed: onShareTap,
                text: "share_pdf".tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
