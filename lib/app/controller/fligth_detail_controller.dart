import 'package:dio/dio.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/models/realModel/flight_detail.dart';
import 'package:get/get.dart';

class FlightDetailController extends GetxController {
  final Rx<FlightInfo?> flightInfo = Rx<FlightInfo?>(null);
  final RxString time1 = "".obs;
  final RxString time2 = "".obs;
  final RxBool isLoading = false.obs;

  // Easy getters — no need to repeat logic
  FlightSegment? get firstSeg => flightInfo.value?.flightSegment.first;
  FlightSegment? get lastSeg => flightInfo.value?.flightSegment.last;
  FlightExtInfo? get ext => flightInfo.value?.flightExtInfo;

  final Rx<FlightDetail?> flightDetail = Rx<FlightDetail?>(null);

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.echina.mn/api/",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  void setFlight(FlightInfo flight) {
    flightInfo.value = flight;
  }

  @override
  void onClose() {
    flightInfo.value = null;
    super.onClose();
  }

  Future<void> getFlightPrice({
    required String dpt,
    required String arr,
    required String date,
    required int adult,
    required int child,
    required String flightNum,
    String? type, // ow / rt
    String? backDate,
    String? flightType, // int
    required String nctype, // d / int
  }) async {
    try {
      isLoading.value = true;
      flightDetail.value = null;

      final params = {
        'dpt': dpt,
        'arr': arr,
        'date': date,
        'adult': adult,
        'child': child,
        'flightNum': flightNum,
        'flightType': '3',
        'nctype': nctype,
      };

      if (type != null) params['type'] = type;
      if (backDate != null) params['backDate'] = backDate;
      if (flightType != null) params['flight_type'] = flightType;

      final result = await dio.get(
        'searchPrice/mn/',
        queryParameters: params,
      );

      final data = result.data;

      print("fligth detail fetch status: ${data['status']}");

      if (data['status'] == 'SUCCESS') {
        final resultObj = data['result'];
        // print(resultObj);

        // print("Flight detail count: ${resultObj}");
        // result is LIST
        // final list = resultObj ?? [];

        flightDetail.value = FlightDetail.fromJson(resultObj);
        // print("in fetch vendors: " + flightDetail.value!.arrCode);
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
    } finally {
      isLoading.value = false;
    }
  }
}
