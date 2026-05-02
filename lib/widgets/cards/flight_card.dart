import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class FlightCard extends StatelessWidget {
  const FlightCard({
    super.key,
    this.index,
    this.roundTrip,
    required this.flightInfo,
    this.withEdit = false,
    this.onEdit,
  });

  final bool? roundTrip;
  final int? index;
  final FlightInfo flightInfo;
  final bool withEdit;
  final Function()? onEdit;

  // ─── Helpers ────────────────────────────────────────────────────────────────

  FlightSegment get _firstSeg => flightInfo.flightSegment.first;
  List<StopInfo> get _stopInfo1 => flightInfo.flightSegment.first.stopInfoList;
  FlightSegment get _lastSeg => flightInfo.flightSegment.last;
  List<StopInfo> get _stopInfo2 => flightInfo.flightSegment.last.stopInfoList;
  FlightExtInfo get _ext => flightInfo.flightExtInfo;

  String get _deptTime => _firstSeg.dptTime;
  String get _deptTime1 => _lastSeg.dptTime;
  String get _arrTime => _firstSeg.arrTime;
  String get _arrTime1 => _lastSeg.arrTime;
  String get _deptCode => _firstSeg.dpt;
  String get _arrCode => _firstSeg.arr;
  String get _deptCode1 => _lastSeg.dpt;
  String get _arrCode1 => _lastSeg.arr;
  // String get _stopArr => _firstSeg.arr;
  // String get _stopArrAirportEng => _firstSeg.arrAirportEng;
  String get _deptCity => _firstSeg.dptCityNameEng;
  String get _arrCity => _firstSeg.arrCityNameEng;
  String get _deptCity1 => _lastSeg.dptCityNameEng;
  String get _arrCity1 => _lastSeg.arrCityNameEng;
  String get _deptCityAirportEng => _firstSeg.dptAirportEng;
  String get _deptCityAirportEng1 => _lastSeg.dptAirportEng;
  String get _arrCityAirportEng => _firstSeg.arrAirportEng;
  String get _arrCityAirportEng1 => _lastSeg.arrAirportEng;
  String get _deptTerminal => _firstSeg.dptTerminal;
  String get _deptTerminal1 => _lastSeg.dptTerminal;
  String get _arrTerminal => _firstSeg.arrTerminal;
  String get _arrTerminal1 => _lastSeg.arrTerminal;
  String get _deptDate => _firstSeg.dptDate;
  // String get _deptDate1 => _lastSeg.dptDate;
  // String get _arrDate => _firstSeg.arrDate;
  // String get _arrDate1 => _lastSeg.arrDate;
  String get _airline => _firstSeg.airline;
  String get _flightNum => _firstSeg.flightNum;
  // String get _flightNum1 => _lastSeg.flightNum;
  String get _airlineLogo => _firstSeg.airlineLogo;
  String get cabinCount => _firstSeg.cabinCount;
  // List get _stopInfoList => _firstSeg.stopInfoList;
  int? get cabinCountNumber => int.tryParse(cabinCount);

  bool get isAvailable => cabinCount == "A" || cabinCountNumber != null;

  String get displayCabinCount {
    if (cabinCount == "A") return "Олон суудалтай";
    if (cabinCountNumber != null) return "$cabinCount суудалтай";
    return "";
  }

  int get _stops1 => _firstSeg.stopsNum;
  int get _stops2 => _lastSeg.stopsNum;
  double get _price => _ext.totalPrice;

  String _formatDuration1(String hourLabel, String minLabel) {
    final depart = DateTime.tryParse(
      '${_firstSeg.dptDate} ${_firstSeg.dptTime}',
    );

    final arrDate =
        _firstSeg.arrDate.isEmpty ? _firstSeg.dptDate : _firstSeg.arrDate;

    var arrive = DateTime.tryParse(
      '$arrDate ${_firstSeg.arrTime}',
    );

    if (depart == null || arrive == null) {
      return _firstSeg.flightTimes;
    }

    if (arrive.isBefore(depart)) {
      arrive = arrive.add(const Duration(days: 1));
    }

    final diff = arrive.difference(depart);
    return '${diff.inHours} $hourLabel ${diff.inMinutes.remainder(60)} $minLabel';
  }

  String _formatDuration2(String hourLabel, String minLabel) {
    final depart = DateTime.tryParse(
      '${_lastSeg.dptDate} ${_lastSeg.dptTime}',
    );

    final arrDate =
        _lastSeg.arrDate.isEmpty ? _lastSeg.dptDate : _lastSeg.arrDate;

    var arrive = DateTime.tryParse(
      '$arrDate ${_lastSeg.arrTime}',
    );

    if (depart == null || arrive == null) {
      return _lastSeg.flightTimes;
    }

    if (arrive.isBefore(depart)) {
      arrive = arrive.add(const Duration(days: 1));
    }

    final diff = arrive.difference(depart);
    return '${diff.inHours} $hourLabel ${diff.inMinutes.remainder(60)} $minLabel';
  }

  String _dayOfWeek(String dateStr, List name) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return '';
    // const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return name[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final formatter = NumberFormat("#,###");
    print(index);
    // final controller = Get.find<FlightDetailController>();
    // print(" format1:${_formatDuration1(localization.hours, localization.min)}");
    // print(" format2:${_formatDuration2(localization.hours, localization.min)}");
    // controller.time1.value =
    //     _formatDuration1(localization.hours, localization.min);
    // controller.time2.value =
    //     _formatDuration2(localization.hours, localization.min);

    final isDark = Get.isDarkMode;
    final cardBg = isDark
        ? colorScheme(context).surfaceContainerLowest
        : colorScheme(context).primaryContainer;

    List<String> days = [
      localization.monday,
      localization.tuesday,
      localization.wednesday,
      localization.thursday,
      localization.friday,
      localization.saturday,
      localization.sunday
    ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: spacingUnit(1)),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: ThemeRadius.medium,
        border:
            Border.all(color: colorScheme(context).outlineVariant, width: 1),
      ),
      child: Column(
        children: [
          // ── Header: index + flight type + distance ──────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(2), vertical: spacingUnit(1)),
            decoration: BoxDecoration(
              color: colorScheme(context).surface,
              borderRadius: BorderRadius.only(
                topLeft: ThemeRadius.medium.topLeft,
                topRight: ThemeRadius.medium.topRight,
              ),
            ),
            child: Row(
              children: [
                if (index != null)
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: colorScheme(context).primary,
                      borderRadius: ThemeRadius.xsmall,
                    ),
                    child: Text(
                      '$index',
                      style: ThemeText.paragraph.copyWith(
                          color: colorScheme(context).onPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Text(
                  _ext.nctype != "t"
                      ? (_stops1 == 0 && _stops2 == 0
                          ? localization.directFlight
                          : localization.indirectFlight)
                      : localization.proposal,
                  style:
                      ThemeText.paragraph.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Icon(Icons.location_on_outlined,
                    size: 13, color: colorScheme(context).onSurfaceVariant),
                Text(
                  int.parse(_firstSeg.distance) > 0
                      ? '${_firstSeg.distance}km'
                      : '',
                  style: ThemeText.paragraphBold
                      .copyWith(color: colorScheme(context).onSurfaceVariant),
                ),
                const Spacer(),
                // Segments indicator (dots for multi-segment)
                if (flightInfo.flightSegment.length > 1)
                  Icon(Icons.more_horiz,
                      size: 18, color: colorScheme(context).onSurfaceVariant),
              ],
            ),
          ),

          // ── Airline row ─────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(2), vertical: spacingUnit(1)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                ClipRRect(
                  borderRadius: ThemeRadius.xsmall,
                  child: _airlineLogo.isNotEmpty
                      ? Image.network(_airlineLogo,
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              _airlineInitials(context))
                      : _airlineInitials(context),
                ),
                const SizedBox(width: 8),

                // Flight number + airline name + date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_flightNum,
                        style: ThemeText.paragraph.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme(context).primary)),
                    Text(_airline,
                        style: ThemeText.paragraph
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      '$_deptDate  ${_dayOfWeek(_deptDate, days)}',
                      style: ThemeText.paragraph.copyWith(
                          color: colorScheme(context).onSurfaceVariant),
                    ),
                  ],
                ),

                const Spacer(),

                // cabin count + badge + price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme(context).primaryContainer,
                        borderRadius: ThemeRadius.xsmall,
                      ),
                      child: Text(
                        displayCabinCount,
                        style: ThemeText.caption.copyWith(
                            color: colorScheme(context).primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _price < 100000
                          ? '¥${formatter.format(_price)}'
                          : '₮${formatter.format(_price)}',
                      style: ThemeText.subtitle.copyWith(
                          color: colorScheme(context).primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: colorScheme(context).outlineVariant),

          // ── Flight route row ────────────────────────────────────────────────
          roundTrip == false && _lastSeg == _firstSeg
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: spacingUnit(2), vertical: spacingUnit(1) + 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Departure
                      _RouteEndpoint(
                        code: _deptCode,
                        cityName: _deptCity,
                        terminal: _deptTerminal,
                        time: _deptTime,
                        tag: _deptCityAirportEng,
                        align: CrossAxisAlignment.start,
                        context: context,
                      ),

                      // Centre: plane icon + direct label + duration
                      Expanded(
                        child: Column(
                          children: [
                            _stops1 != 0
                                ? Column(
                                    children: [
                                      Text(
                                        _stopInfo1.first.arr,
                                        style: ThemeText.paragraph.copyWith(
                                            color: colorScheme(context)
                                                .onSurfaceVariant),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        _stopInfo1.first.stopAirportNameEng,
                                        style: ThemeText.caption.copyWith(
                                            color: colorScheme(context)
                                                .onSurfaceVariant),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                : Text(
                                    localization.directFlight,
                                    style: ThemeText.paragraph.copyWith(
                                        color: colorScheme(context)
                                            .onSurfaceVariant),
                                    textAlign: TextAlign.center,
                                  ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: colorScheme(context).outlineVariant,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(CupertinoIcons.airplane,
                                      size: 18,
                                      color: colorScheme(context).primary),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: colorScheme(context).outlineVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDuration1(
                                  localization.hours, localization.min),
                              style: ThemeText.paragraph.copyWith(
                                  color: colorScheme(context).onSurfaceVariant),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),

                      // Arrival
                      _RouteEndpoint(
                        code: _arrCode,
                        cityName: _arrCity,
                        terminal: _arrTerminal,
                        time: _arrTime,
                        tag: _arrCityAirportEng,
                        align: CrossAxisAlignment.end,
                        context: context,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(2),
                          vertical: spacingUnit(1) + 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Departure
                          _RouteEndpoint(
                            code: _deptCode,
                            cityName: _deptCity,
                            terminal: _deptTerminal,
                            time: _deptTime,
                            tag: _deptCityAirportEng,
                            align: CrossAxisAlignment.start,
                            context: context,
                          ),

                          // Centre: plane icon + direct label + duration
                          Expanded(
                            child: Column(
                              children: [
                                _stops1 != 0
                                    ? Column(
                                        children: [
                                          Text(
                                            _stopInfo1.first.arr,
                                            style: ThemeText.paragraph.copyWith(
                                                color: colorScheme(context)
                                                    .onSurfaceVariant),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            _stopInfo1.first.stopAirportNameEng,
                                            style: ThemeText.caption.copyWith(
                                                color: colorScheme(context)
                                                    .onSurfaceVariant),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )
                                    : Text(
                                        localization.directFlight,
                                        style: ThemeText.paragraph.copyWith(
                                            color: colorScheme(context)
                                                .onSurfaceVariant),
                                        textAlign: TextAlign.center,
                                      ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color:
                                            colorScheme(context).outlineVariant,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Icon(CupertinoIcons.airplane,
                                          size: 18,
                                          color: colorScheme(context).primary),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color:
                                            colorScheme(context).outlineVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDuration1(
                                      localization.hours, localization.min),
                                  style: ThemeText.paragraph.copyWith(
                                      color: colorScheme(context)
                                          .onSurfaceVariant),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),

                          // Arrival
                          _RouteEndpoint(
                            code: _arrCode,
                            cityName: _arrCity,
                            terminal: _arrTerminal,
                            time: _arrTime,
                            tag: _arrCityAirportEng,
                            align: CrossAxisAlignment.end,
                            context: context,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(2),
                          vertical: spacingUnit(1) + 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Departure
                          _RouteEndpoint(
                            code: _deptCode1,
                            cityName: _deptCity1,
                            terminal: _deptTerminal1,
                            time: _deptTime1,
                            tag: _deptCityAirportEng1,
                            align: CrossAxisAlignment.start,
                            context: context,
                          ),

                          // Centre: plane icon + direct label + duration
                          Expanded(
                            child: Column(
                              children: [
                                _stopInfo2
                                        .isNotEmpty // here is why i place the _lastSeg.stopsNum  it has give me error
                                    ? Column(
                                        children: [
                                          Text(
                                            _stopInfo2.first.arr,
                                            style: ThemeText.paragraph.copyWith(
                                                color: colorScheme(context)
                                                    .onSurfaceVariant),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            _stopInfo2.first.stopAirportNameEng,
                                            style: ThemeText.caption.copyWith(
                                                color: colorScheme(context)
                                                    .onSurfaceVariant),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )
                                    : Text(
                                        localization.directFlight,
                                        style: ThemeText.paragraph.copyWith(
                                            color: colorScheme(context)
                                                .onSurfaceVariant),
                                        textAlign: TextAlign.center,
                                      ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color:
                                            colorScheme(context).outlineVariant,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Icon(CupertinoIcons.airplane,
                                          size: 18,
                                          color: colorScheme(context).primary),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color:
                                            colorScheme(context).outlineVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                roundTrip == true
                                    ? Text(
                                        _formatDuration2(localization.hours,
                                            localization.min),
                                        style: ThemeText.paragraph.copyWith(
                                            color: colorScheme(context)
                                                .onSurfaceVariant),
                                        textAlign: TextAlign.center,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),

                          // Arrival
                          _RouteEndpoint(
                            code: _arrCode1,
                            cityName: _arrCity1,
                            terminal: _arrTerminal1,
                            time: _arrTime1,
                            tag: _arrCityAirportEng1,
                            align: CrossAxisAlignment.end,
                            context: context,
                          ),
                        ],
                      ),
                    )
                  ],
                ),

          // // ── Edit button ─────────────────────────────────────────────────────
          // if (withEdit)
          //   InkWell(
          //     onTap: onEdit,
          //     child: Padding(
          //       padding: const EdgeInsets.all(6),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(Icons.edit,
          //               color: colorScheme(context).onPrimaryContainer,
          //               size: 14),
          //           SizedBox(width: spacingUnit(1)),
          //           Text('EDIT',
          //               style: ThemeText.paragraph.copyWith(
          //                   fontWeight: FontWeight.bold,
          //                   color: colorScheme(context).onPrimaryContainer)),
          //         ],
          //       ),
          //     ),
          //   ),

          _ext.nctype == "t"
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "${localization.flightWarning} ${localization.total} ${_lastSeg.dptCityNameEng} ${localization.inTheCity} ${_ext.waitTime} ${localization.minutes} ${localization.wait}",
                      style: ThemeText.paragraph.copyWith(
                          color: colorScheme(context).onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _airlineInitials(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme(context).primaryContainer,
        borderRadius: ThemeRadius.xsmall,
      ),
      child: Text(
        _airline.length >= 2
            ? _airline.substring(0, 2).toUpperCase()
            : _airline,
        style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ─── Route endpoint widget (departure / arrival) ───────────────────────────────

class _RouteEndpoint extends StatelessWidget {
  const _RouteEndpoint({
    required this.code,
    required this.cityName,
    required this.terminal,
    required this.time,
    required this.tag,
    required this.align,
    required this.context,
  });

  final String code;
  final String cityName;
  final String terminal;
  final String time;
  final String tag;
  final CrossAxisAlignment align;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return SizedBox(
      width: 90,
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            code,
            style: ThemeText.subtitle.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme(context).primary),
          ),
          Text(
            cityName,
            style: ThemeText.paragraph
                .copyWith(color: colorScheme(context).onSurfaceVariant),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            time,
            style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            tag,
            style: ThemeText.paragraph
                .copyWith(color: colorScheme(context).onSurfaceVariant),
            overflow: TextOverflow.ellipsis,
          ),
          if (terminal.isNotEmpty)
            Text(
              terminal,
              style: ThemeText.paragraph
                  .copyWith(color: colorScheme(context).onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
