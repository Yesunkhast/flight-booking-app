import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/payment/credit_card_info.dart';
import 'package:flight_app/widgets/payment/identity_form.dart';

class PaymentDetailCC extends StatelessWidget {
  const PaymentDetailCC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new)
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Get.toNamed('/faq');
            },
          )
        ],
        centerTitle: true,
        title: const Text('Payment', style: ThemeText.subtitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ThemeSize.sm
          ),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: const CreditCardInfo(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(spacingUnit(2)),
                child: const IdentityForm()
              ),
            ),
            Container(
              color: colorScheme(context).surfaceContainerLowest,
              padding: EdgeInsets.only(
                top: spacingUnit(1),
                bottom: spacingUnit(4),
                left: spacingUnit(2),
                right: spacingUnit(2)
              ),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total Including tax 12%: ', style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSurfaceVariant)),
                    Text('\$630.00', style: ThemeText.title2.copyWith(color: ThemePalette.primaryMain, fontWeight: FontWeight.bold),),
                  ]),
                  SizedBox(height: spacingUnit(1)),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ThemeButton.btnBig.merge(ThemeButton.outlinedPrimary(context)),
                          child: const Text('BACK')
                        ),
                      ),
                      SizedBox(width: spacingUnit(1)),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Get.toNamed('/payment/status');
                          },
                          style: ThemeButton.btnBig.merge(ThemeButton.primary),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.lock_outline),
                            SizedBox(width: 4),
                            Text('SECURE PAY')
                          ])
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      )
    );
  }
}