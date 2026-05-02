import 'package:dio/dio.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:get/get.dart';

class FlightSearchController extends GetxController {
  RxList<FlightInfo> flightList = <FlightInfo>[].obs;
  RxDouble cheapPrice = 0.0.obs;
  RxBool isLoading = false.obs;
  final fromCode = ''.obs;
  final toCode = ''.obs;
  final fromName = ''.obs;
  final toName = ''.obs;
  final adults = 1.obs;
  final children = 0.obs;
  final infants = 0.obs;
  final classType = 'Economy'.obs;
  final fromLocation = ''.obs;
  final toLocation = ''.obs;
  final departureDate = ''.obs;
  final returnDate = ''.obs;
  final dateFrom = ''.obs;
  final dateTo = ''.obs;
  final roundTrip = false.obs;
  final domestic = true.obs;
  final passenger = 1.obs;
  final code = "".obs;
  int totalPassenger() {
    return adults.value + children.value + infants.value;
  }

  void reset() {
    fromCode.value = '';
    toCode.value = '';
    fromName.value = '';
    toName.value = '';
    fromLocation.value = '';
    toLocation.value = '';
    departureDate.value = '';
    returnDate.value = '';
    dateFrom.value = '';
    dateTo.value = '';
    roundTrip.value = false;
    adults.value = 0;
    children.value = 0;
    infants.value = 0;
    passenger.value = 0;
    classType.value = 'Economy';
    domestic.value = true;
    flightList.clear();
  }

// https://api.echina.mn/api/d/search/mn/?dpt=ERL&arr=PKX&date=2026-04-16 (domestic)
// dpt="dpt"
// arr="arr"
// date="yyyy-mm-dd"
// t=(sanal bolgoh) esvel d=(shuud, damjin)
// https://api.echina.mn/api/int/search/mn/?dpt=UBN&arr=PKX&date=2026-04-15&backDate=2026-04-22&type=rt&adult=1&child=0&flight_type=int (round trip)
// backDate="yyyy-mm-dd"
// type="rt"
// flight_type="int"
// https://api.echina.mn/api/int/search/mn/?dpt=UBN&arr=PKX&date=2026-04-15&type=ow&adult=1&child=0&flight_type=int (one way)
// type="ow"
// flight_type=int
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

  Future<void> getDomesticFlight({
    required String dpt,
    required String arr,
    required String date,
  }) async {
    try {
      isLoading.value = true;
      flightList.clear();

      final result = await dio.get('d/search/mn/', queryParameters: {
        'dpt': dpt,
        'arr': arr,
        'date': date,
      });

      final data = result.data;

      if (data['status'] == 'SUCCESS') {
        final resultObj = data['result'];

        cheapPrice.value = (resultObj['cheapPrice'] ?? 0).toDouble();

        final List flightInfos = resultObj['flightInfos'] ?? [];
        flightList.value =
            flightInfos.map((e) => FlightInfo.fromJson(e)).toList();

        print("Domestic flight count: ${flightList.length}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized
      }
      print('DioError: ${e.message}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getInternationalFlight({
    required String dpt,
    required String arr,
    required String date,
    required String type,
    required int adult,
    required int child,
    required String flight_type,
    String? backDate,
  }) async {
    try {
      isLoading.value = true;
      flightList.clear();

      final params = <String, dynamic>{
        'dpt': dpt,
        'arr': arr,
        'date': date,
        'type': type,
        'adult': adult,
        'child': child,
        'flight_type': flight_type,
      };

      if (backDate != null) params['backDate'] = backDate;

      final result = await dio.get('int/search/mn/', queryParameters: params);
      final data = result.data;

      if (data['status'] == 'SUCCESS') {
        final resultObj = data['result'];

        cheapPrice.value = (resultObj['cheapPrice'] ?? 0).toDouble();

        final List flightInfos = resultObj['flightInfos'] ?? [];
        flightList.value =
            flightInfos.map((e) => FlightInfo.fromJson(e)).toList();
      }
      // ignore: avoid_print
      print(
          "International flight count: ${flightList[1].flightSegment.first.arrAirportEng}");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized
      }
      print('DioError: ${e.message}');
    } finally {
      isLoading.value = false;
    }
  }
}
