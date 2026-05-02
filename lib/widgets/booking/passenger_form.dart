// import 'package:flight_app/models/booking.dart';
// import 'package:flight_app/models/list_item.dart';
// import 'package:flight_app/app/constants/app_const.dart';
// import 'package:flight_app/utils/picker.dart';
// import 'package:flight_app/widgets/booking/passenger_options.dart';
// import 'package:flight_app/models/user.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/app/controller/passenger_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/passenger.dart';
import 'package:flight_app/models/realModel/user.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_input/app_input_box.dart';
import 'package:flight_app/widgets/title/title_action.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';

class PassengerForm extends StatefulWidget {
  const PassengerForm({super.key, required this.totalPassengers});

  final int totalPassengers;

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  final detailController = Get.find<FlightDetailController>();
  final passengerController = Get.find<PassengerController>();
  final userController = Get.find<UserController>();
  User get user => userController.user.value!;
  List<Passenger> get _passengers => passengerController.passengers;
  List<Passenger> _bookingPassengers = [];
  int counter = 0;

  @override
  void initState() {
    super.initState();

    _bookingPassengers = List.generate(
      widget.totalPassengers,
      (_) => passengerInit,
    );
  }

  void openUserPicker(BuildContext context, int index, String title) {
    final localization = AppLocalizations.of(context)!;
    int selectedId = 0;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setBottomState) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme(context).surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Handle bar ─────────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme(context).outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // ── Title ──────────────────────────────────────────────────
                Text(title, style: ThemeText.subtitle),
                const SizedBox(height: 8),

                // ── List ───────────────────────────────────────────────────
                Flexible(
                  child: _passengers.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(spacingUnit(2)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_off_outlined,
                                size: 48,
                                color: colorScheme(context).onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                localization.noPassengers,
                                style: ThemeText.paragraph.copyWith(
                                  color: colorScheme(context).onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () {
                                  Get.back();
                                  Get.toNamed(AppLink.addPassengger);
                                },
                                icon: const Icon(Icons.add, size: 16),
                                label: Text(localization.addNewPassengger),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                          itemCount: _passengers.length,
                          separatorBuilder: (_, __) => Divider(
                            color: colorScheme(context).outlineVariant,
                            height: 1,
                          ),
                          itemBuilder: (context, i) {
                            final p = _passengers[i];
                            // final isUsedElsewhere =
                            //     otherSelectedIds.contains(p.id);
                            // final isSelected = selectedId == p.id;

                            return ListTile(
                              // enabled: !isUsedElsewhere,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              leading: Radio<int?>(
                                value: p.id,
                                groupValue: selectedId,
                                activeColor: colorScheme(context).primary,
                                onChanged:
                                    //  isUsedElsewhere
                                    //     ? null
                                    //     :
                                    (val) =>
                                        setBottomState(() => selectedId = val!),
                              ),
                              title: Text(
                                p.fullName,
                                style: ThemeText.paragraphBold.copyWith(
                                  color:
                                      // isUsedElsewhere
                                      //     ? colorScheme(context).onSurfaceVariant
                                      //     :
                                      colorScheme(context).onSurface,
                                ),
                              ),
                              subtitle: Text(
                                'ID: ${p.idCard}',
                                style: ThemeText.caption.copyWith(
                                  color: colorScheme(context).onSurfaceVariant,
                                ),
                              ),
                              // ✅ Show "already selected" badge
                              // trailing:
                              //     // true
                              //     //     ? Container(
                              //     //         padding: const EdgeInsets.symmetric(
                              //     //             horizontal: 6, vertical: 2),
                              //     //         decoration: BoxDecoration(
                              //     //           color: colorScheme(context)
                              //     //               .surfaceContainerHighest,
                              //     //           borderRadius:
                              //     //               BorderRadius.circular(4),
                              //     //         ),
                              //     //         child: Text(
                              //     //           'Сонгогдсон',
                              //     //           style: ThemeText.caption.copyWith(
                              //     //             color: colorScheme(context)
                              //     //                 .onSurfaceVariant,
                              //     //           ),
                              //     //         ),
                              //     //       )
                              //     //     :
                              //     null,
                              onTap: () =>
                                  setBottomState(() => selectedId = p.id!),
                            );
                          },
                        ),
                ),

                // ── Confirm button ─────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    spacingUnit(2),
                    spacingUnit(1),
                    spacingUnit(2),
                    spacingUnit(3),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final selected =
                            _passengers.firstWhere((p) => p.id == selectedId);

                        setState(() {
                          if (_bookingPassengers.contains(selected)) {
                            _bookingPassengers[index] = passengerInit;
                          } else {
                            _bookingPassengers[index] = selected;
                            counter++;
                          }
                        });

                        Get.back();
                        if (widget.totalPassengers == counter) {
                          counter = 0;
                          passengerController.passengersSelected.value = true;
                        }
                      },
                      child: Text(localization.choose),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
    // print("counter: ${widget.totalPassengers}");
  }

  @override
  Widget build(BuildContext context) {
    print("page passenger");
    final localization = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VSpace(),

          /// CONTACT DETAIL
          TitleAction(
            title: localization.contactDetail,
            size: 'small',
            textAction: localization.edit,
            onTap: () {
              Get.toNamed(AppLink.editProfile);
            },
          ),

          Container(
            padding: EdgeInsets.all(spacingUnit(2)),
            decoration: BoxDecoration(
              color: colorScheme(context).outline.withValues(alpha: 0.5),
              borderRadius: ThemeRadius.medium,
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(localization.name,
                      style: ThemeText.paragraph
                          .copyWith(color: colorScheme(context).onSurface)),
                  trailing: Text(userController.user.value!.firstName,
                      style: ThemeText.paragraph.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme(context).onSurface)),
                  contentPadding: const EdgeInsets.all(0),
                ),
                ListTile(
                  title: Text(localization.email,
                      style: ThemeText.paragraph
                          .copyWith(color: colorScheme(context).onSurface)),
                  trailing: Text(userController.user.value!.email,
                      style: ThemeText.paragraph.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme(context).onSurface)),
                  contentPadding: const EdgeInsets.all(0),
                ),
                ListTile(
                  title: Text(localization.phoneNumber,
                      style: ThemeText.paragraph
                          .copyWith(color: colorScheme(context).onSurface)),
                  trailing: Text(userController.user.value!.phone,
                      style: ThemeText.paragraph.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme(context).onSurface)),
                  contentPadding: const EdgeInsets.all(0),
                ),
              ],
            ),
          ),

          const VSpaceBig(),

          /// PASSENGERS TITLE
          TitleBasic(
            title: localization.passengerInfo,
            size: 'small',
          ),

          // const VSpaceBig(),

          /// PASSENGER LIST (FIXED)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.totalPassengers,
            itemBuilder: (context, index) {
              final passenger = _bookingPassengers[index];

              return Padding(
                padding: EdgeInsets.only(top: spacingUnit(2)),
                child: AppInputBox(
                  content: ListTile(
                    title: Text('${localization.passenger} ${index + 1}'),
                    subtitle: passenger.id != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                passenger.fullName,
                                style: ThemeText.headline,
                              ),
                              Text(
                                '${localization.idNumber}: ${passenger.idCard}',
                              ),
                            ],
                          )
                        : null,
                    trailing: Icon(
                      passenger.id != null
                          ? Icons.edit
                          : CupertinoIcons.add_circled,
                    ),
                    onTap: () {
                      openUserPicker(
                        context,
                        index,
                        localization.choosePassenger,
                      );
                    },
                  ),
                ),
              );
            },
          ),

          const VSpaceShort(),

          /// ADD PASSENGER BUTTON
          Center(
            child: TextButton(
              onPressed: () {
                Get.toNamed(AppLink.addPassengger);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_circle_outline, size: 16),
                  const SizedBox(width: 4),
                  Text(localization.addNewPassengger),
                ],
              ),
            ),
          ),

          const VSpaceBig(),
        ],
      ),
    );
  }
}
