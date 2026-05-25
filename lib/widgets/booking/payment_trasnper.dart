import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/payment_controller.dart';
import 'package:flight_app/app/service.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/warning_notices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

class PaymentTransfer extends StatelessWidget {
  const PaymentTransfer({
    super.key,
    required this.transferCode,
    required this.iban,
    required this.bankName,
    required this.accountName,
    required this.onVerify,
  });

  final String transferCode; // Гүйлгээний утга e.g. "1876"
  final String iban; // MN 9500 1500 3405159225
  final String bankName; // Голомт банк
  final String accountName; // Чайна бүүкинг ХХК
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final paymentController = Get.find<PaymentController>();
    print("payment status: ${paymentController.paymentStatus.value}");
    final formatter = NumberFormat("#,###");
    final totalPrice =
        paymentController.orderResponse.value?.result.amount.toDouble();
    final formattedPrice = '${formatter.format(totalPrice)}₮';

    return Container(
        margin: EdgeInsets.all(spacingUnit(2)),
        padding: EdgeInsets.all(spacingUnit(2)),
        decoration: BoxDecoration(
          color: colorScheme(context).surface,
          borderRadius: ThemeRadius.medium,
          border: Border.all(color: colorScheme(context).outlineVariant),
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──────────────────────────────────────────────────
              Center(
                child: Text(
                  localization.paymentInfo,
                  style: ThemeText.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: spacingUnit(1)),
              Divider(
                color: colorScheme(context).outlineVariant,
                height: 1,
                indent: 0,
                endIndent: 0,
              ),
              SizedBox(height: spacingUnit(2)),

              // ── Bank logo ───────────────────────────────────────────────
              // Container(
              //   width: 48,
              //   height: 48,
              //   decoration: BoxDecoration(
              //     borderRadius: ThemeRadius.medium,
              //   ),
              //   child:
              //       Center(child: Image.asset("assets/images/golomt_bank.jpg")),
              // ),
              // SizedBox(height: spacingUnit(1)),
              // Divider(
              //   color: colorScheme(context).primary,
              //   height: 1,
              //   thickness: 2,
              // ),
              // SizedBox(height: spacingUnit(2)),

              // ── Info rows ───────────────────────────────────────────────
              _InfoRow(
                label: localization.totalAmount,
                value: formattedPrice,
                valuePrimary: true,
                copyable: true,
                copyText: totalPrice.toString(),
                context: context,
              ),
              SizedBox(height: spacingUnit(1) + 4),

              _InfoRow(
                label: localization.transactionValue,
                value: transferCode,
                valuePrimary: true,
                copyable: true,
                copyText: transferCode,
                context: context,
              ),
              SizedBox(height: spacingUnit(1) + 4),

              _InfoRow(
                label: localization.bank,
                value: bankName,
                valuePrimary: true,
                context: context,
              ),
              SizedBox(height: spacingUnit(1) + 4),

              _InfoRow(
                label: 'IBAN',
                value: iban,
                valuePrimary: true,
                copyable: true,
                copyText: iban.replaceAll(' ', ''),
                context: context,
              ),
              SizedBox(height: spacingUnit(1) + 4),

              _InfoRow(
                label: localization.accountHolder,
                value: accountName,
                valuePrimary: true,
                context: context,
              ),

              SizedBox(height: spacingUnit(2)),

              // // ── QR placeholder ──────────────────────────────────────────
              // Center(
              //   child: Container(
              //     width: 56,
              //     height: 56,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //           color: colorScheme(context).outlineVariant, width: 2),
              //       borderRadius: ThemeRadius.small,
              //     ),
              //     child: Icon(
              //       Icons.qr_code_2,
              //       size: 40,
              //       color: colorScheme(context).onSurfaceVariant,
              //     ),
              //   ),
              // ),

              SizedBox(height: spacingUnit(2)),

              // ── Expire time ─────────────────────────────────────────────
              Center(
                  child: RichText(
                text: TextSpan(
                  style: ThemeText.subtitle.copyWith(
                    color: colorScheme(context).onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(text: '${localization.expiryTime}: '),
                    TextSpan(
                      text:
                          paymentController.formattedTime, // ✅ use Rx properly
                      style: ThemeText.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme(context).onSurface,
                      ),
                    ),
                  ],
                ),
              )),

              SizedBox(height: spacingUnit(2)),

              // ── Status warning ──────────────────────────────────────────
              paymentController.paymentStatus.value != "TIMEOUT"
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: spacingUnit(2),
                        vertical: spacingUnit(1) + 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme(context).primary),
                        borderRadius: ThemeRadius.small,
                      ),
                      child: Text(
                        paymentController.message.value,
                        style: ThemeText.paragraph.copyWith(
                          color: colorScheme(context).primary,
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: spacingUnit(2),
                        vertical: spacingUnit(1) + 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme(context).primary),
                        borderRadius: ThemeRadius.small,
                      ),
                      child: Text(
                        localization.paymentExpiredWarning,
                        style: ThemeText.paragraph.copyWith(
                          color: colorScheme(context).primary,
                        ),
                      ),
                    ),

              SizedBox(height: spacingUnit(2)),

              // ── Total ───────────────────────────────────────────────────
              Row(
                children: [
                  Text(
                    localization.totalAmount,
                    style: ThemeText.paragraph.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formattedPrice,
                    style: ThemeText.subtitle.copyWith(
                      color: colorScheme(context).primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacingUnit(2)),

              // ── Verify button ───────────────────────────────────────────
              paymentController.paymentStatus.value != "TIMEOUT"
                  ? SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          // Check Payment товч
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                paymentController
                                    .checkPayment(paymentController.oid.value);
                              },
                              style:
                                  ThemeButton.btnBig.merge(ThemeButton.primary),
                              icon: const Icon(Icons.check_circle_outline,
                                  size: 20, color: Colors.white),
                              label: Text(
                                localization.checkPayment,
                                style: ThemeText.subtitle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const VSpace(),
                          // Card Payment товч
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final success =
                                    await StripePaymentService.instance.pay(
                                  amount:
                                      totalPrice!.toInt() * 100, 
                                );
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(localization.paymentSuccess),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: colorScheme(context)
                                          .onPrimaryContainer,
                                    ),
                                  );
                                  NotificationService.instance.showNotification(
                                      title: localization.paymentSuccess,
                                      body: localization.paymentSuccessDesc,
                                      type: "success");
                                  Get.offNamed(AppLink.paymentStatus);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(localization.paymentFailed),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: colorScheme(context)
                                          .onPrimaryContainer,
                                    ),
                                  );
                                }

                                // Get.toNamed('/payment/status');
                              },
                              style: ThemeButton.btnBig.merge(
                                OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: colorScheme(context).primary),
                                ),
                              ),
                              icon: Icon(Icons.credit_card,
                                  size: 20,
                                  color: colorScheme(context).primary),
                              label: Text(
                                localization.cardPayment,
                                style: ThemeText.subtitle.copyWith(
                                  color: colorScheme(context).primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Get.toNamed(AppLink.home);
                        },
                        style: ThemeButton.btnBig.merge(ThemeButton.primary),
                        child: Text(
                          localization.backToHome,
                          style: ThemeText.subtitle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

              SizedBox(height: spacingUnit(2)),

              // ── Notice text ─────────────────────────────────────────────
              Text(
                localization.paymentInstructions,
                style: ThemeText.paragraph.copyWith(
                  color: colorScheme(context).onSurfaceVariant,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
              VSpace(),
              SizedBox(height: spacingUnit(2)),
              Divider(color: colorScheme(context).outlineVariant, height: 1),
              SizedBox(height: spacingUnit(2)),
              WarningNotice()
            ],
          ),
        ));
  }
}

// ── Info row with optional copy button ────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.context,
    this.valuePrimary = false,
    this.copyable = false,
    this.copyText,
  });

  final String label;
  final String value;
  final bool valuePrimary;
  final bool copyable;
  final String? copyText;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    final localization = AppLocalizations.of(context)!;
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: ThemeText.paragraph.copyWith(
              color: colorScheme(context).onSurface,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: ThemeText.paragraph.copyWith(
              color: valuePrimary
                  ? colorScheme(context).primary
                  : colorScheme(context).onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (copyable)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: copyText ?? value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label ${localization.copied}'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Icon(
              Icons.copy_rounded,
              size: 18,
              color: colorScheme(context).onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
