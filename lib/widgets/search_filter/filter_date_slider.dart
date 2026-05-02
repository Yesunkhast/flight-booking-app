import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/widgets/app_button/tag_button.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDateSlider extends StatefulWidget {
  const FilterDateSlider({
    super.key,
    this.dayCount = 30, // configurable, defaults to 30
    this.startFromToday = true,
    required this.fetchDateByFlight, // start from today or day 0
  });

  final int dayCount;
  final bool startFromToday;
  final Future Function() fetchDateByFlight;

  @override
  State<FilterDateSlider> createState() => _FilterDateSliderState();
}

class _FilterDateSliderState extends State<FilterDateSlider> {
  final controller = Get.find<FlightSearchController>();
  final _scrollController = ScrollController();
  final double stepWidth = 35;
  final DateTime currentDate = DateTime.now();

  int _currentDate = 0;

  // Generate date list dynamically from today
  late final List<DateTime> _dates = List.generate(
    widget.dayCount,
    (i) => currentDate.add(Duration(days: i)),
  );

  String _formatDate(DateTime date, List month) {
    return '${month[date.month - 1]} ${date.day} ';
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _scrollController.animateTo(
              _currentDate * stepWidth - 16,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDateSelected(int index) async {
    setState(() => _currentDate = index);

    controller.departureDate.value =
        "${_dates[index].year}-${_dates[index].month.toString().padLeft(2, '0')}-${_dates[index].day.toString().padLeft(2, '0')}";

    controller.dateFrom.value = controller.departureDate.value;

    _scrollController.animateTo(
      index * stepWidth - 16,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );

    await widget.fetchDateByFlight();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    List<String> month = [
      localization.monthJan,
      localization.monthFeb,
      localization.monthMar,
      localization.monthApr,
      localization.monthMay,
      localization.monthJun,
      localization.monthJul,
      localization.monthAug,
      localization.monthSep,
      localization.monthOct,
      localization.monthNov,
      localization.monthDec
    ];
    // print(
    //     "Selected date: ${_dates[_currentDate].year}-${_dates[_currentDate].month.toString().padLeft(2, '0')}-${_dates[_currentDate].day.toString().padLeft(2, '0')}");
    return SizedBox(
      height: 24,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: TagButton(
              size: BtnSize.medium,
              text: _formatDate(_dates[index], month),
              selected: index == _currentDate,
              onPressed: () => _onDateSelected(index),
            ),
          );
        },
      ),
    );
  }
}
