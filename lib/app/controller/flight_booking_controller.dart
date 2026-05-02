import 'package:dio/dio.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/models/realModel/flight_detail.dart';
import 'package:get/get.dart';
import 'package:flight_app/models/realModel/booking.dart';

class BookingController extends GetxController {
  /// ───────────────────────── STATE ─────────────────────────

  final Rx<BookingResult?> bookingResult = Rx<BookingResult?>(null);
  final RxBool isLoading = false.obs;
  RxDouble rate = 1.0.obs;
  List<FlightSegment> get flightInfo => bookingResult.value?.flightInfo ?? [];

  List<TgqData> get tgqShowData => bookingResult.value?.tgqShowData ?? [];

  List<BaggageRule> get baggageRuleInfos =>
      bookingResult.value?.baggageRuleInfos ?? [];

  PriceInfo? get priceInfo => bookingResult.value?.priceInfo;

  PolicyInfo? get policyInfo => bookingResult.value?.policyInfo;

  List<TgqData> get childTgqData => bookingResult.value?.childTgqData ?? [];
  final RxBool isAccepted = false.obs;
  Rxn<Vendor> flight = Rxn<Vendor>();

  /// ───────────────────────── API ─────────────────────────

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

  /// ───────────────────────── MAIN BOOKING CALL ─────────────────────────

  Future<void> getBooking({
    required String dpt,
    required String arr,
    required String date,
    required String tag,
    required String flightNum,
    required String btime,
    required String carrier,
    required String nctype,
    String? flightType,
  }) async {
    try {
      isLoading.value = true;

      bookingResult.value = null;

      final params = {
        'dpt': dpt,
        'arr': arr,
        'date': date,
        'tag': tag,
        'flightNum': flightNum,
        'btime': btime,
        'carrier': carrier,
        'nctype': nctype,
      };

      if (flightType != null) {
        params['flightType'] = flightType;
      }

      final response = await dio.get(
        'booking/mn/',
        queryParameters: params,
      );

      final data = response.data;

      // ignore: avoid_print
      print("🟡 booking status: ${data['status']}");

      if (data['status'] == 'SUCCESS') {
        final resultObj = data['result'];

        bookingResult.value = BookingResult.fromJson(resultObj);

        // ignore: avoid_print
        print("✅ booking loaded");
      } else {
        // ignore: avoid_print
        print("❌ booking failed: ${data['message']}");
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('❌ DioError: ${e.message}');
    } catch (e) {
      // ignore: avoid_print
      print('❌ Unknown error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ───────────────────────── HELPERS ─────────────────────────

  Future<void> bookFromVendor({
    required String nctype,
    required Vendor vendor,
  }) async {
    // ✅ Extract all params from bookingUrl
    final uri = Uri.parse("https://dummy.com${vendor.bookingUrl}");
    final params = uri.queryParameters;

    await getBooking(
      dpt: params['depCode'] ?? "",
      arr: params['arrCode'] ?? "arr",
      date: params['date'] ?? "date",
      tag: params['tag'] ?? vendor.tag,
      flightNum: params['code'] ?? '',
      btime: params['btime'] ?? "date",
      carrier: params['carrier'] ?? '',
      nctype: nctype,
      flightType: params['flightType'], // null for domestic
    );
  }

  /// ───────────────────────── URL PARSERS ─────────────────────────

  /// Extract flightNum from bookingUrl
  String extractFlightNum(String url) {
    try {
      final uri = Uri.parse("https://dummy.com$url");
      return uri.queryParameters['code'] ?? '';
    } catch (_) {
      return '';
    }
  }

  /// Extract btime
  String extractBtime(String url) {
    try {
      final uri = Uri.parse("https://dummy.com$url");
      return uri.queryParameters['btime'] ?? '';
    } catch (_) {
      return '';
    }
  }

  /// Extract carrier
  String extractCarrier(String url) {
    try {
      final uri = Uri.parse("https://dummy.com$url");
      return uri.queryParameters['carrier'] ?? '';
    } catch (_) {
      return '';
    }
  }

  /// ───────────────────────── CLEANUP ─────────────────────────

  void clearBooking() {
    bookingResult.value = null;
  }

  Future<double> getExchangeRate() async {
    try {
      final response = await dio.get(
        'https://api.exchangerate-api.com/v4/latest/CNY',
      );

      final data = response.data;
      final value = (data['rates']['MNT'] as num).toDouble();

      rate.value = value;

      print("💱 Rate: $value");
      return value;
    } catch (e) {
      print('❌ Exchange error: $e');
      return 1.0; // fallback
    }
  }
}
