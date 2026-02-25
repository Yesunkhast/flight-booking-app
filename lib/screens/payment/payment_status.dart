import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/utils/col_row.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/models/booking.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/stepper/step_progress.dart';
import 'package:flight_app/widgets/title/title_basic.dart';

class PaymentStatus extends StatelessWidget {
  const PaymentStatus({super.key});

  Color statusColor(String status) {
    switch(status) {
      case 'error':
        return Colors.red;
      case 'waiting':
        return Colors.orangeAccent;
      case 'success':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

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
      body: Column(children: [
        StepProgress(activeIndex: 6, items: bookingSteps,),
        /// PAYMENT STATUS
        Center(
          child: Container(
            margin: EdgeInsets.all(spacingUnit(2)),
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              borderRadius: ThemeRadius.medium,
              color: statusColor('success')
            ),
            constraints: BoxConstraints(
              maxWidth: ThemeSize.sm
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.check_circle_outline_sharp, color: Colors.white, size: 24),
                  SizedBox(width: spacingUnit(1)),
                  Text('Payment Success', style: ThemeText.subtitle.copyWith(color: Colors.white))
                ]),
                SizedBox(height: spacingUnit(2),),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                  decoration: BoxDecoration(
                    color: colorScheme(context).surface,
                    borderRadius: const BorderRadius.all(Radius.circular(40))
                  ),
                  child: Text('\$705.6', style: ThemeText.title.copyWith(color: statusColor('success'), fontWeight: FontWeight.bold)),
                )
              ],
            )
          ),
        ),

        Expanded(
          /// LIST DETAIL
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ThemeSize.sm
            ),
            child: ListView(
              shrinkWrap: true,
              primary: true,
              padding: EdgeInsets.symmetric(vertical: spacingUnit(1),
              horizontal: spacingUnit(2)),
              children: const [
                VSpaceShort(),
                TitleBasicSmall(title: 'Detail Transaction'),
                VSpaceShort(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Date:'),
                  Text('22 Jun 2025', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                LineList(spacing: 8,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Transaction Number:'),
                  Text('A1234567890SSR', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                LineList(spacing: 8,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Price:'),
                  Text('\$630', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                LineList(spacing: 8,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Tax 12%:'),
                  Text('\$75.6', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                LineList(spacing: 8,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total:', style: ThemeText.subtitle),
                  Text('\$705.6', style: ThemeText.subtitle),
                ]),
              ]
            ),
          ),
        ),

        /// OTHER ACTIONS
        Container(
          padding: EdgeInsets.all(spacingUnit(1)),
          constraints: BoxConstraints(
            maxWidth: ThemeSize.sm
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            InkWell(
              onTap: () {
                Get.toNamed(AppLink.orderHistory);
              },
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  alignment: Alignment.center,
                    children: [
                    CircleAvatar(
                      backgroundColor: ThemePalette.tertiaryLight,
                      radius: 22,
                    ),
                    Icon(Icons.history, size: 32, color: ThemePalette.tertiaryDark),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Order History', style: ThemeText.caption)
              ]),
            ),
            InkWell(
              onTap: () {},
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: ThemePalette.primaryLight,
                      radius: 22,
                    ),
                    Transform.flip(
                      flipX: true,
                      child: Icon(Icons.reply, size: 32, color: ThemePalette.primaryDark)
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Share', style: ThemeText.caption)
              ]),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(AppLink.eTicket);
              },
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: ThemePalette.secondaryLight,
                      radius: 22,
                    ),
                    Icon(Icons.airplane_ticket, size: 32, color: ThemePalette.secondaryDark),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Show E Ticket', style: ThemeText.caption)
              ]),
            ),
          ]),
        ),

        const VSpaceShort(),
        
        /// ACTION BUTTON
        Container(
          padding: EdgeInsets.all(spacingUnit(1)),
          child: ColRow(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            switched: ThemeBreakpoints.smUp(context),
            children: <Widget>[
              SizedBox(
                width: ThemeBreakpoints.smUp(context) ? 250 : double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Get.toNamed(AppLink.ticketDetail);
                  },
                  style: ThemeButton.btnBig.merge(ThemeButton.tonalPrimary(context)),
                  child: const Text('GO TO MY TICKET')
                ),
              ),
              SizedBox(
                height: ThemeBreakpoints.smUp(context) ? 0 : spacingUnit(2),
                width: ThemeBreakpoints.smUp(context) ? spacingUnit(2) : 0,
              ),
              SizedBox(
                width: ThemeBreakpoints.smUp(context) ? 250 : double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppLink.home);
                  },
                  style: ThemeButton.btnBig.merge(ThemeButton.outlinedPrimary(context)),
                  child: const Text('GO TO HOMEPAGE')
                ),
              ),
            ],
          ),
        ),
        const VSpace()
      ])
    );
  }
}
