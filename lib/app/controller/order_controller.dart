import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flight_app/models/realModel/order.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://flight-app-db.vercel.app'));

  final RxList<String> orderNumbers = <String>[].obs;

  final RxList<CreateOrderResponse> orderResponse = <CreateOrderResponse>[].obs;

  final RxBool isLoading = false.obs;

  Future<void> registerOrderToDB(
    String uid,
    String orderNumber,
  ) async {
    try {
      await _dio.post(
        '/api/orders/',
        data: {
          'userID': uid,
          'orderNo': orderNumber,
        },
      );

      print(
        "✅ Order registered in DB for user: $uid, orderNo: $orderNumber",
      );
    } catch (e) {
      print("❌ DB registration error: $e");
    }
  }

  Future<void> getOrderNumber(String uid) async {
    try {
      final response = await _dio.get(
        '/api/orders/',
        queryParameters: {
          'id': uid,
        },
      );

      final data = response.data;

      orderNumbers.clear();

      for (var order in data['data']) {
        orderNumbers.add(order['orderNo'].toString());
      }

      print("Order Numbers: $orderNumbers");
    } catch (e) {
      print("❌ Error fetching orders: $e");
    }
  }

  Future<CreateOrderResponse> getOrderInfo(
    String orderNo,
  ) async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: "https://api.echina.mn/api",
      ),
    );

    final response = await dio.get(
      '/getOrderInfo/$orderNo/mn',
    );

    return CreateOrderResponse.fromJson(response.data);
  }

  bool _hasFetched = false; // Нэг удаа fetch хийсэн эсэх

  // ─── Cache-тай fetch ───────────────────────────────
  Future<void> getOrders({bool forceRefresh = false}) async {
    // Аль хэдийн fetch хийсэн бөгөөд force биш бол skip
    if (_hasFetched && !forceRefresh && orderResponse.isNotEmpty) {
      print("Using cached orders");
      return;
    }

    // Cache-аас уншиж үзнэ
    if (!forceRefresh) {
      final cached = await _loadFromCache();
      if (cached) {
        _hasFetched = true;
        print("Loaded from cache");
        return;
      }
    }

    // API-аас авна
    try {
      isLoading.value = true;

      for (String orderNo in orderNumbers) {
        final orderInfo = await getOrderInfo(orderNo);

        orderResponse.add(orderInfo);
      }

      // Амжилттай бол cache хадгална
      await _saveToCache();
      _hasFetched = true;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Cache хадгалах ───────────────────────────────
  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orderResponse.map((o) => o.toJson()).toList();
    await prefs.setString('cached_orders', jsonEncode(jsonList));
    await prefs.setString(
        'cached_orders_time', DateTime.now().toIso8601String());
    print("Orders saved to cache");
  }

  // ─── Cache унших ──────────────────────────────────
  Future<bool> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cached_orders');
    final timeStr = prefs.getString('cached_orders_time');

    if (data == null || timeStr == null) return false;

    // 30 минутаас хуучин бол cache хүчингүй
    final cachedTime = DateTime.parse(timeStr);
    if (DateTime.now().difference(cachedTime).inMinutes > 30) {
      return false;
    }

    final list = jsonDecode(data) as List;
    orderResponse.value =
        list.map((e) => CreateOrderResponse.fromJson(e)).toList();
    return true;
  }

  // ─── Cache цэвэрлэх ──────────────────────────────
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_orders');
    await prefs.remove('cached_orders_time');
    _hasFetched = false;
  }

  // Future<void> getOrders() async {
  //   try {
  //     isLoading.value = true;

  //     orderResponse.clear();

  //     for (String orderNo in orderNumbers) {
  //       final orderInfo = await getOrderInfo(orderNo);

  //       orderResponse.add(orderInfo);
  //     }

  //     print("Orders fetched: ${orderResponse.length}");
  //   } catch (e) {
  //     print("❌ Error fetching orders: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchAllOrders(String uid) async {
    await getOrderNumber(uid);

    await getOrders();
  }
}

class Order {
  final String orderNo;
  final String userID;

  Order({required this.orderNo, required this.userID});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNo: json['orderNo'] ?? '',
      userID: json['userID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNo': orderNo,
      'userID': userID,
    };
  }
}
