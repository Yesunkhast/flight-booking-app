import 'package:flight_app/models/realModel/booking.dart';
import 'package:flight_app/models/realModel/flight.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Root response wrapper
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class CreateOrderResponse {
  final String status;
  final int code;
  final String message;
  final OrderResult result;

  CreateOrderResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.result,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      status: JsonHelper.toStr(json['status']),
      code: JsonHelper.toInt(json['code']),
      message: JsonHelper.toStr(json['message']),
      result: OrderResult.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'result': result.toJson(),
      };
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Order result (matches the "result" object in the JSON)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class OrderResult {
  final String status; // "nonconfirm"
  final String orderNo;
  final String pnr;
  final String email;
  final String phone;
  final String transactionValue;
  final String nctype;
  final String createDate;
  final String payDeadline;
  final int amount;
  final List<OrderPassenger> passengers; // JSON uses "passangers" (typo)
  final List<FlightSegment> flightInfo;
  final List<TgqData> tgqShowData;
  final List<BaggageRule> baggageRuleInfos;
  final OrderPriceInfo priceInfo;
  final PolicyInfo policyInfo;
  final List<TgqData> childTgqData;
  final Map<String, dynamic> specialProductRule;
  final bool ebarimt;

  OrderResult({
    required this.status,
    required this.orderNo,
    required this.pnr,
    required this.email,
    required this.phone,
    required this.transactionValue,
    required this.nctype,
    required this.createDate,
    required this.payDeadline,
    required this.amount,
    required this.passengers,
    required this.flightInfo,
    required this.tgqShowData,
    required this.baggageRuleInfos,
    required this.priceInfo,
    required this.policyInfo,
    required this.childTgqData,
    required this.specialProductRule,
    required this.ebarimt,
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) {
    // Helper for tgqShowData / childTgqData (though they are arrays here)
    List<TgqData> parseTgqList(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map((e) => TgqData.fromJson(e))
            .toList();
      }
      return [];
    }

    return OrderResult(
      status: JsonHelper.toStr(json['status']),
      orderNo: JsonHelper.toStr(json['orderNo']),
      pnr: JsonHelper.toStr(json['pnr']),
      email: JsonHelper.toStr(json['email']),
      phone: JsonHelper.toStr(json['phone']),
      transactionValue: JsonHelper.toStr(json['transactionValue']),
      nctype: JsonHelper.toStr(json['nctype']),
      createDate: JsonHelper.toStr(json['createDate']),
      payDeadline: JsonHelper.toStr(json['payDeadline']),
      amount: JsonHelper.toInt(json['amount']),
      // Note the JSON uses "passangers" – we map to passengers
      passengers: (json['passangers'] as List?)
              ?.map((e) => OrderPassenger.fromJson(e))
              .toList() ??
          [],
      flightInfo: JsonHelper.toList(
        json['flightInfo'],
        (e) => FlightSegment.fromJson(e),
      ),
      tgqShowData: parseTgqList(json['tgqShowData']),
      baggageRuleInfos: JsonHelper.toList(
        json['baggageRuleInfos'],
        (e) => BaggageRule.fromJson(e),
      ),
      priceInfo: OrderPriceInfo.fromJson(json['priceInfo'] ?? {}),
      policyInfo: PolicyInfo.fromJson(json['policyInfo'] ?? {}),
      childTgqData: parseTgqList(json['childTgqData']),
      specialProductRule: json['specialProductRule'] ?? {},
      ebarimt: JsonHelper.toBool(json['ebarimt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'orderNo': orderNo,
        'pnr': pnr,
        'email': email,
        'phone': phone,
        'transactionValue': transactionValue,
        'nctype': nctype,
        'createDate': createDate,
        'payDeadline': payDeadline,
        'amount': amount,
        'passangers': passengers.map((e) => e.toJson()).toList(),
        'flightInfo': flightInfo.map((e) => e.toJson()).toList(),
        'tgqShowData': tgqShowData.map((e) => e.toJson()).toList(),
        'baggageRuleInfos': baggageRuleInfos.map((e) => e.toJson()).toList(),
        'priceInfo': priceInfo.toJson(),
        'policyInfo': policyInfo.toJson(),
        'childTgqData': childTgqData.map((e) => e.toJson()).toList(),
        'specialProductRule': specialProductRule,
        'ebarimt': ebarimt,
      };
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Passenger inside the order (matches "passangers" array)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class OrderPassenger {
  final String passport;
  final String name; // e.g. "DORJPUREV/YESUNKHAST"
  final int sex; // 1 = male
  final String birthday;
  final String expire;
  final String ticket;

  OrderPassenger({
    required this.passport,
    required this.name,
    required this.sex,
    required this.birthday,
    required this.expire,
    required this.ticket,
  });

  factory OrderPassenger.fromJson(Map<String, dynamic> json) {
    return OrderPassenger(
      passport: JsonHelper.toStr(json['passport']),
      name: JsonHelper.toStr(json['name']),
      sex: JsonHelper.toInt(json['sex']),
      birthday: JsonHelper.toStr(json['birthday']),
      expire: JsonHelper.toStr(json['expire']),
      ticket: JsonHelper.toStr(json['ticket']),
    );
  }

  Map<String, dynamic> toJson() => {
        'passport': passport,
        'name': name,
        'sex': sex,
        'birthday': birthday,
        'expire': expire,
        'ticket': ticket,
      };
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PriceInfo specific to this order response (fits the JSON exactly)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class OrderPriceInfo {
  final double price;
  final double tax;
  final double totalPrice;
  final int cTax;
  final double cPrice;
  final double cTotalPrice;
  final int childPriceType;

  OrderPriceInfo({
    required this.price,
    required this.tax,
    required this.totalPrice,
    required this.cTax,
    required this.cPrice,
    required this.cTotalPrice,
    required this.childPriceType,
  });

  factory OrderPriceInfo.fromJson(Map<String, dynamic> json) {
    return OrderPriceInfo(
      price: JsonHelper.toDouble(json['price']),
      tax: JsonHelper.toDouble(json['tax']),
      totalPrice: JsonHelper.toDouble(json['totalPrice']),
      cTax: JsonHelper.toInt(json['cTax']),
      cPrice: JsonHelper.toDouble(json['cPrice']),
      cTotalPrice: JsonHelper.toDouble(json['cTotalPrice']),
      childPriceType: JsonHelper.toInt(json['childPriceType']),
    );
  }

  Map<String, dynamic> toJson() => {
        'price': price,
        'tax': tax,
        'totalPrice': totalPrice,
        'cTax': cTax,
        'cPrice': cPrice,
        'cTotalPrice': cTotalPrice,
        'childPriceType': childPriceType,
      };
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// JsonHelper – copy from your existing code (kept here for completeness)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class JsonHelper {
  static String toStr(dynamic value) => value?.toString() ?? '';

  static int toInt(dynamic value) {
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double toDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static bool toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString() == '1' || value.toString().toLowerCase() == 'true';
  }

  static List<T> toList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is List) {
      return value.map((e) => fromJson(e)).toList();
    }
    return [];
  }
}
