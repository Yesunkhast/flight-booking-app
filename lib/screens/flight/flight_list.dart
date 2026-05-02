// import 'package:flight_app/screens/flight/package_not_found.dart';
// import 'package:flight_app/screens/not_found.dart';
// import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/screens/flight/flight_not_found.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/widgets/flight/info_header.dart';
import 'package:flight_app/widgets/flight/flight_trip_list.dart';
import 'package:flight_app/widgets/search_filter/filter_bottom_floating.dart';
import 'package:flight_app/widgets/search_filter/filter_date_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class FlightList extends StatefulWidget {
  const FlightList({super.key});

  @override
  State<FlightList> createState() => _FlightListState();
}

class _FlightListState extends State<FlightList> {
  final ScrollController _scrollController = ScrollController();

  RangeValues _priceRange = const RangeValues(100, 10000);
  final List<String> _selectedAirlines = []; // now uses airlineCode string
  final List<int> _stopTransits = [0, 1];
  double _duration = 16;

  final controller = Get.find<FlightSearchController>();

  List<FlightInfo> allData = [];
  List<FlightInfo> resultFlight = [];

  late Future<void> _future;

  // ─── Helpers to extract values from new model ───────────────────────────────

  /// Total price from FlightExtInfo
  double _price(FlightInfo f) => f.flightExtInfo.totalPrice;

  /// Number of stops from FlightExtInfo
  int _stops(FlightInfo f) => f.flightExtInfo.stopsNum;

  /// Airline code from first segment
  String _airlineCode(FlightInfo f) =>
      f.flightSegment.isNotEmpty ? f.flightSegment.first.airlineCode : '';

  /// Airline name from first segment
  String _airlineName(FlightInfo f) =>
      f.flightSegment.isNotEmpty ? f.flightSegment.first.airline : '';

  /// Departure time from first segment (parsed)
  DateTime? _departTime(FlightInfo f) {
    if (f.flightSegment.isEmpty) return null;
    final seg = f.flightSegment.first;
    return _parseDateTime(seg.dptDate, seg.dptTime);
  }

  /// Arrival time from last segment (parsed)
  DateTime? _arrivalTime(FlightInfo f) {
    if (f.flightSegment.isEmpty) return null;
    final seg = f.flightSegment.last;
    return _parseDateTime(seg.arrDate, seg.arrTime);
  }

  /// Total flight duration in hours across all segments
  double _totalDurationHours(FlightInfo f) {
    final depart = _departTime(f);
    final arrival = _arrivalTime(f);
    if (depart == null || arrival == null) return 0;
    return arrival.difference(depart).inMinutes / 60.0;
  }

  DateTime? _parseDateTime(String date, String time) {
    try {
      // Expects date: "2024-10-13", time: "14:30"
      return DateTime.parse('$date $time');
    } catch (_) {
      return null;
    }
  }

  // ─── Filter ─────────────────────────────────────────────────────────────────

  List<FlightInfo> filterFlights(
    List<FlightInfo> flights, {
    double? maxPrice,
    double? minPrice,
    List<String>? airlines,
    List<int>? transits,
    double? duration,
  }) {
    return flights.where((item) {
      final price = _price(item);
      final stops = _stops(item);
      final code = _airlineCode(item);
      final hours = _totalDurationHours(item);

      final matchesAirline =
          airlines == null || airlines.isEmpty || airlines.contains(code);

      final matchesPrice = (minPrice == null || price >= minPrice) &&
          (maxPrice == null || price <= maxPrice);

      final matchesTransit = transits == null || transits.contains(stops);

      final matchesDuration = duration == null || hours <= duration;

      return matchesAirline &&
          matchesPrice &&
          matchesTransit &&
          matchesDuration;
    }).toList();
  }

  // ─── Sort ────────────────────────────────────────────────────────────────────

  void sortFlights(String criteria, {bool descending = false}) {
    setState(() {
      resultFlight.sort((a, b) {
        int result;
        switch (criteria) {
          case 'cheapest':
            result = _price(a).compareTo(_price(b));
            break;
          case 'transit':
            result = _stops(a).compareTo(_stops(b));
            break;
          case 'name':
            result = _airlineName(a).compareTo(_airlineName(b));
            break;
          case 'depart':
            final da = _departTime(a), db = _departTime(b);
            result = (da != null && db != null) ? da.compareTo(db) : 0;
            break;
          case 'arrival':
            final aa = _arrivalTime(a), ab = _arrivalTime(b);
            result = (aa != null && ab != null) ? aa.compareTo(ab) : 0;
            break;
          case 'duration':
            result = _totalDurationHours(a).compareTo(_totalDurationHours(b));
            break;
          default:
            result = 0;
        }
        return descending ? -result : result;
      });
    });
  }

  // ─── Filter callbacks ────────────────────────────────────────────────────────

  void changePrice(RangeValues values) {
    setState(() {
      _priceRange = values;
      resultFlight = filterFlights(
        allData,
        airlines: _selectedAirlines,
        minPrice: values.start,
        maxPrice: values.end,
        duration: _duration,
        transits: _stopTransits,
      );
    });
  }

  void selectAirlines(String type, String airlineCode) {
    setState(() {
      if (type == 'add') {
        _selectedAirlines.add(airlineCode);
      } else {
        _selectedAirlines.remove(airlineCode);
      }
      resultFlight = filterFlights(
        allData,
        airlines: _selectedAirlines,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        duration: _duration,
        transits: _stopTransits,
      );
    });
  }

  void selectTransits(String type, int val) {
    setState(() {
      if (type == 'add') {
        _stopTransits.add(val);
      } else {
        _stopTransits.remove(val);
      }
      resultFlight = filterFlights(
        allData,
        airlines: _selectedAirlines,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        duration: _duration,
        transits: _stopTransits,
      );
    });
  }

  void changeDuration(double val) {
    setState(() {
      _duration = val;
      resultFlight = filterFlights(
        allData,
        airlines: _selectedAirlines,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        duration: val,
        transits: _stopTransits,
      );
    });
  }

  // ─── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Replace flightList with your real data source / API call
    controller.flightList.clear();
    allData.addAll(controller.flightList);
    resultFlight.addAll(controller.flightList);
    sortFlights('cheapest');
    _future = fetchFlights();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future fetchFlights() async {
    if (controller.domestic.value) {
      await controller.getDomesticFlight(
        dpt: controller.fromCode.value,
        arr: controller.toCode.value,
        date: controller.departureDate.value,
      );
    } else if (controller.roundTrip.value) {
      await controller.getInternationalFlight(
        dpt: controller.fromCode.value,
        arr: controller.toCode.value,
        date: controller.departureDate.value,
        backDate: controller.returnDate.value,
        type: 'rt',
        adult: controller.adults.value,
        child: controller.children.value,
        flight_type: 'int',
      );
    } else {
      await controller.getInternationalFlight(
        dpt: controller.fromCode.value,
        arr: controller.toCode.value,
        date: controller.departureDate.value,
        type: 'ow',
        adult: controller.adults.value,
        child: controller.children.value,
        flight_type: 'int',
      );
    }

    if (mounted) {
      setState(() {
        allData = List.from(controller.flightList);
        resultFlight = filterFlights(allData);
        sortFlights('cheapest');
      });
    }
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: InfoHeader(
          date: controller.dateTo.value.isNotEmpty
              ? '${controller.dateFrom.value} - ${controller.dateTo.value}'
              : controller.dateFrom.value,
          from: controller.fromCode.value,
          to: controller.toCode.value,
          passengers: controller.totalPassenger(),
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Column(
                children: [
                  FilterDateSlider(
                    fetchDateByFlight: () async {
                      setState(() {
                        _future = fetchFlights();
                      });
                    },
                  ),
                  Divider(color: colorScheme(context).outline),
                  Expanded(
                    child: resultFlight.isEmpty &&
                            snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : resultFlight.isEmpty
                            ? const FlightNotFound()
                            : FlightTripList(
                                roundTrip: controller.roundTrip.value,
                                scrollRef: _scrollController,
                                flightData: resultFlight,
                              ),
                  ),
                ],
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme(context).primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme(context).onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: ScrollToHide(
        scrollController: _scrollController,
        height: 100,
        hideDirection: Axis.vertical,
        child: FilterBottomFloating(
          onSortBest: () => sortFlights('cheapest'),
          onSortCheapest: () => sortFlights('cheapest'),
          onSortDiscount: () => sortFlights('cheapest', descending: true),
          onSortPlaneName: () => sortFlights('name'),
          onSortTransits: () => sortFlights('transit'),
          onSortDepart: () => sortFlights('depart'),
          onSortArrival: () => sortFlights('arrival'),
          priceRange: _priceRange,
          duration: _duration,
          selectedAirlines: _selectedAirlines,
          transits: _stopTransits,
          onChangePrice: (RangeValues val) => changePrice(val),
          onChangeDuration: (double val) => changeDuration(val),
          onUpdateTransit: (String type, int val) => selectTransits(type, val),
          onUpdateAirlines: (String type, String code) =>
              selectAirlines(type, code), // changed Plane → String
        ),
      ),
    );
  }
}
