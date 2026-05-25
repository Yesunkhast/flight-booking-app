import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/realModel/order.dart';
import 'package:flight_app/models/realModel/passenger.dart';

class PaymentController extends GetxController {
  // ───────────────── STATE ─────────────────

  final orderNo = ''.obs;
  final oid = ''.obs;
  final Rxn<AccountInfo> accountInfo = Rxn<AccountInfo>();
  final isLoading = false.obs;
  final Rxn<CreateOrderResponse> orderResponse = Rxn<CreateOrderResponse>();

  final RxInt remainingSeconds = (5 * 60).obs; // 2 minutes
  final RxBool isChecking = false.obs;
  // final RxBool isRequesting = false.obs;

  final RxString paymentStatus = ''.obs;
  final message = ''.obs;

  Timer? _timer;

  static const String baseUrl = 'https://api.echina.mn/api';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // ───────────────── CREATE ORDER ─────────────────

  Future<void> createOrder({
    required int bid,
    required String contactMob,
    required String email,
    required List<Passenger> passengers,
    required String nctype,
    required String flightType,
    required String tag,
  }) async {
    isLoading.value = true;

    try {
      final data = {
        'bid': bid,
        'contactMob': contactMob,
        'email': email,
        'passCount': passengers.length,
        'flightType': flightType,
        'nctype': nctype,
        'tag': tag,
        'passengers': passengers
            .map((p) => {
                  'cardNo': p.idcard,
                  'surname': p.lastname,
                  'name': p.firstname,
                  'type': p.type,
                  'sex': p.gender == 'M' ? '1' : '0',
                  'birthday': p.birthday,
                  'expire': p.passportvaliddate,
                })
            .toList(),
      };

      final response = await _dio.post('/createOrder/mn/', data: data);

      final resData = response.data;

      if (resData['status'] == 'SUCCESS') {
        orderNo.value = resData['result']['orderNo'] ?? '';
        oid.value = (resData['result']['oid'] ?? 0).toString();
        print("order created oid is: ${oid.value}");
      } else {
        throw Exception(resData['message']);
      }
    } catch (e) {
      print("❌ createOrder error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────── ACCOUNT INFO ─────────────────

  Future<void> getAccountInfo() async {
    isLoading.value = true;

    try {
      final response = await _dio.get('/res/getAccountInfo/mn/');
      final data = response.data;

      if (data['status'] == 'SUCCESS') {
        final result = data['result'];

        if (result.isNotEmpty) {
          accountInfo.value = AccountInfo.fromJson(result.first);
        }
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("❌ account error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────── ORDER INFO ─────────────────

  Future<void> getOrderInfo(String orderNo) async {
    try {
      isLoading.value = true;

      final response = await _dio.get('/getOrderInfo/$orderNo/mn/');
      final data = response.data;

      if (data['status'] == 'SUCCESS') {
        orderResponse.value = CreateOrderResponse.fromJson(data);
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("Order fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────── TIMER ─────────────────

  void restartPaymentCheck(String oid) {
    stopChecking();

    remainingSeconds.value = 2 * 60;

    paymentStatus.value = '';
    message.value = '';

    startPaymentCheck(oid);
  }

  void startPaymentCheck(String orderNo) {
    if (isChecking.value) return;

    isChecking.value = true;

    int tick = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds.value <= 0) {
        remainingSeconds.value = 0;
        stopChecking();
        paymentStatus.value = "TIMEOUT";
        return;
      }

      remainingSeconds.value--;

      tick++;

      // check API every 5 sec only
      if (tick % 5 == 0) {
        await checkPayment(orderNo);
      }
    });
  }

  // ───────────────── PAYMENT CHECK ─────────────────

  Future<void> checkPayment(String orderNo) async {
    // if (isRequesting.value) return;

    try {
      print("Checking payment for order: $orderNo");
      final res = await _dio.get('/checkPayment/$orderNo/mn/');
      final data = res.data;

      print("payment check: $data");

      if (data['status'] == 'SUCCESS') {
        paymentStatus.value = "SUCCESS";
        stopChecking();

        Get.offNamed(AppLink.paymentStatus);
      } else if (data['status'] == 'WARNING') {
        message.value = data['message'];
      } else {
        stopChecking();
        paymentStatus.value = "FAILED";
      }
    } catch (e) {
      print("check error: $e");
    } finally {
      // isRequesting.value = false;
    }
  }

  // ───────────────── TIME FORMAT ─────────────────

  String get formattedTime {
    final total = remainingSeconds.value;

    final minutes = total ~/ 60;
    final seconds = total % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // ───────────────── STOP ─────────────────

  void stopChecking() {
    _timer?.cancel();
    _timer = null;
    isChecking.value = false;
  }

  // ───────────────── CLEANUP ─────────────────

  @override
  void onClose() {
    stopChecking();
    super.onClose();
  }

  void clearOrderData() {
    orderNo.value = '';
    oid.value = '';
  }

  void clearAccountInfo() {
    accountInfo.value = null;
  }
}

// ───────────────── MODEL ─────────────────

class AccountInfo {
  final String accNumber;
  final String accHolderName;
  final String bank;
  final String bic;

  AccountInfo({
    required this.accNumber,
    required this.accHolderName,
    required this.bank,
    required this.bic,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      accNumber: json['acc_number'] ?? '',
      accHolderName: json['acc_holder_name'] ?? '',
      bank: json['bank'] ?? '',
      bic: json['bic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acc_number': accNumber,
      'acc_holder_name': accHolderName,
      'bank': bank,
      'bic': bic,
    };
  }

  @override
  String toString() => 'AccountInfo(bank: $bank, number: $accNumber)';
}
