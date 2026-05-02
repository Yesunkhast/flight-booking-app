import 'package:flight_app/models/realModel/flight.dart';

class BookingResult {
  final int bookingStrId;
  final String nctype;
  final int cardType;
  final String cabinCount;

  final List<FlightSegment> flightInfo;
  final List<TgqData> tgqShowData;
  final List<BaggageRule> baggageRuleInfos;
  final PriceInfo priceInfo;
  final PolicyInfo policyInfo;
  final List<TgqData> childTgqData;
  final Map<String, dynamic> specialProductRule;

  BookingResult({
    required this.bookingStrId,
    required this.nctype,
    required this.cardType,
    required this.cabinCount,
    required this.flightInfo,
    required this.tgqShowData,
    required this.baggageRuleInfos,
    required this.priceInfo,
    required this.policyInfo,
    required this.childTgqData,
    required this.specialProductRule,
  });

  factory BookingResult.fromJson(Map<String, dynamic> json) {
    // ✅ tgqShowData can be List or Map
    List<TgqData> parseTgq(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map((e) => TgqData.fromJson(e))
            .toList();
      }
      if (raw is Map && raw.isNotEmpty) {
        return [TgqData.fromJson(Map<String, dynamic>.from(raw))];
      }
      return [];
    }

    return BookingResult(
      bookingStrId: JsonHelper.toInt(json['bookingStrId']),
      nctype: JsonHelper.toStr(json['nctype']),
      cardType: JsonHelper.toInt(json['cardType']),
      cabinCount: JsonHelper.toStr(json['cabinCount']),
      flightInfo: JsonHelper.toList(
        json['flightInfo'],
        (e) => FlightSegment.fromJson(e),
      ),
      tgqShowData: parseTgq(json['tgqShowData']), // ✅ handles both
      baggageRuleInfos: JsonHelper.toList(
        json['baggageRuleInfos'],
        (e) => BaggageRule.fromJson(e),
      ),
      priceInfo: PriceInfo.fromJson(json['priceInfo'] ?? {}),
      policyInfo: PolicyInfo.fromJson(json['policyInfo'] ?? {}),
      childTgqData: parseTgq(json['childTgqData']), // ✅ handles {} too
      specialProductRule: json['specialProductRule'] ?? {},
    );
  }
}

class TgqData {
  final List<TgqPointCharge> tgqPointCharges;

  TgqData({required this.tgqPointCharges});

  factory TgqData.fromJson(Map<String, dynamic> json) {
    return TgqData(
      tgqPointCharges: JsonHelper.toList(
        json['tgqPointCharges'],
        (e) => TgqPointCharge.fromJson(e),
      ),
    );
  }
  // Add inside TgqData class
  Map<String, dynamic> toJson() {
    return {
      'tgqPointCharges': tgqPointCharges.map((e) => e.toJson()).toList(),
    };
  }
}

// ─── Fix TgqPointCharge — returnFee/changeFee can be String or int ──────────
class TgqPointCharge {
  final String returnFee; // ✅ String — handles both "692.00-0-692.00" and 226
  final String changeFee; // ✅ String
  final String timeText; // domestic only
  final int time; // domestic only

  TgqPointCharge({
    required this.returnFee,
    required this.changeFee,
    required this.timeText,
    required this.time,
  });

  factory TgqPointCharge.fromJson(Map<String, dynamic> json) {
    return TgqPointCharge(
      returnFee: JsonHelper.toStr(json['returnFee']), // ✅ toStr handles both
      changeFee: JsonHelper.toStr(json['changeFee']),
      timeText: JsonHelper.toStr(json['timeText']),
      time: JsonHelper.toInt(json['time']),
    );
  }
  // Add inside TgqPointCharge class
  Map<String, dynamic> toJson() {
    return {
      'returnFee': returnFee,
      'changeFee': changeFee,
      'timeText': timeText,
      'time': time,
    };
  }
}

class BaggageRule {
  final String cabinBaggageRule;
  final String infantBaggageRule;
  final String checkedBaggageRule;
  final List<String> specialRules;

  BaggageRule({
    required this.cabinBaggageRule,
    required this.infantBaggageRule,
    required this.checkedBaggageRule,
    required this.specialRules,
  });

  factory BaggageRule.fromJson(Map<String, dynamic> json) {
    return BaggageRule(
      cabinBaggageRule: JsonHelper.toStr(json['cabinBaggageRule']),
      infantBaggageRule: JsonHelper.toStr(json['infantBaggageRule']),
      checkedBaggageRule: JsonHelper.toStr(json['checkedBaggageRule']),
      specialRules:
          (json['specialRules'] as List?)?.map((e) => e.toString()).toList() ??
              [],
    );
  }
  // Add inside BaggageRule class
  Map<String, dynamic> toJson() {
    return {
      'cabinBaggageRule': cabinBaggageRule,
      'infantBaggageRule': infantBaggageRule,
      'checkedBaggageRule': checkedBaggageRule,
      'specialRules': specialRules,
    };
  }
}

class PriceInfo {
  final double price;
  final double tax;
  final double totalPrice;
  final double cPrice;
  final double cTotalPrice;
  final double childPriceType;
  final double fee;
  final double moneyTransfer;
  final double nightFee;
  final String? date;
  final double operatorFee;
  final double operatorFeePercent;

  PriceInfo({
    required this.price,
    required this.tax,
    required this.totalPrice,
    required this.cPrice,
    required this.cTotalPrice,
    required this.childPriceType,
    required this.fee,
    required this.moneyTransfer,
    this.date,
    required this.operatorFee,
    required this.operatorFeePercent,
    required this.nightFee,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      price: JsonHelper.toDouble(json['price']),
      tax: JsonHelper.toDouble(json['tax']),
      totalPrice: JsonHelper.toDouble(json['totalPrice']),
      cPrice: JsonHelper.toDouble(json['cPrice']),
      cTotalPrice: JsonHelper.toDouble(json['cTotalPrice']),
      childPriceType: JsonHelper.toDouble(json['childPriceType']),
      fee: JsonHelper.toDouble(json['fee']),
      moneyTransfer: JsonHelper.toDouble(json['moneyTransfer']),
      nightFee: JsonHelper.toDouble(json['nightFee']),
      date: JsonHelper.toStr(json['date']),
      operatorFee: JsonHelper.toDouble(json['operatorFee']),
      operatorFeePercent: JsonHelper.toDouble(json['operatorFeePercent']),
    );
  }
  // Add inside PriceInfo class
  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'tax': tax,
      'totalPrice': totalPrice,
      'cPrice': cPrice,
      'cTotalPrice': cTotalPrice,
      'childPriceType': childPriceType,
      'fee': fee,
      'moneyTransfer': moneyTransfer,
      'nightFee': nightFee,
      'date': date,
      'operatorFee': operatorFee,
      'operatorFeePercent': operatorFeePercent,
    };
  }
}

class PolicyInfo {
  final int maxAge;
  final int minAge;
  final int cardType;
  final String specialRule;
  final bool childBuyAdult;

  PolicyInfo({
    required this.maxAge,
    required this.minAge,
    required this.cardType,
    required this.specialRule,
    required this.childBuyAdult,
  });

  factory PolicyInfo.fromJson(Map<String, dynamic> json) {
    return PolicyInfo(
      maxAge: JsonHelper.toInt(json['maxAge']),
      minAge: JsonHelper.toInt(json['minAge']),
      cardType: JsonHelper.toInt(json['cardType']),
      specialRule: JsonHelper.toStr(json['specialRule']),
      childBuyAdult: JsonHelper.toBool(json['childBuyAdult']),
    );
  }
  // Add inside PolicyInfo class
  Map<String, dynamic> toJson() {
    return {
      'maxAge': maxAge,
      'minAge': minAge,
      'cardType': cardType,
      'specialRule': specialRule,
      'childBuyAdult': childBuyAdult,
    };
  }
}

class JsonHelper {
  static String toStr(dynamic value) {
    return value?.toString() ?? '';
  }

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
