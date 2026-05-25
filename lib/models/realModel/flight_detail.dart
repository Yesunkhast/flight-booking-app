class FlightDetail {
  final String btime;
  final String etime;
  final String correct;
  final int distance;
  final String code;
  final String date;
  final String arrCode;
  final String dptCode;
  final String carrier;
  final List<Vendor> vendors;

  FlightDetail({
    required this.btime,
    required this.etime,
    required this.correct,
    required this.distance,
    required this.code,
    required this.date,
    required this.arrCode,
    required this.dptCode,
    required this.carrier,
    required this.vendors,
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) {
    return FlightDetail(
      btime: json['btime'] ?? '',
      etime: json['etime'] ?? '',
      correct: json['correct'] ?? '',
      distance: json['distance'] ?? 0,
      code: json['code'] ?? '',
      date: json['date'] ?? '',
      arrCode: json['arrCode'] ?? '',
      dptCode: json['dptCode'] ?? '',
      carrier: json['carrier'] ?? '',
      vendors:
          (json['vendors'] as List).map((e) => Vendor.fromJson(e)).toList(),
    );
  }
}

class Vendor {
  final String bookingUrl;
  final double price;
  final double tax;
  final double totalPrice;
  final double? childPrice;

  final String cabin;
  final String cabinCount;

  final String limitRule;
  final String limitType;

  final String luggage;
  final String luggageMore;

  final String carryLuggage;
  final String carryLuggageMore;

  final String refund;
  final String change;

  final String pType;
  final String tag;

  final String bookingParamKey;
  final String flightType;

  final BusinessExtMap businessExtMap;

  Vendor({
    required this.bookingUrl,
    required this.price,
    required this.tax,
    required this.totalPrice,
    this.childPrice,
    required this.cabin,
    required this.cabinCount,
    required this.limitRule,
    required this.limitType,
    required this.luggage,
    required this.luggageMore,
    required this.carryLuggage,
    required this.carryLuggageMore,
    required this.refund,
    required this.change,
    required this.pType,
    required this.tag,
    required this.bookingParamKey,
    required this.flightType,
    required this.businessExtMap,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    // print('bookingUrl type: ${json['bookingUrl'].runtimeType}');
    // print('price type: ${json['price'].runtimeType}');
    // print(
    //     'cabinCount: ${json['cabinCount']} type: ${json['cabinCount'].runtimeType}');
    // print('pType: ${json['pType']} type: ${json['pType'].runtimeType}');
    // print(
    //     'cardType: ${json['businessExtMap']?['cardType']} type: ${json['businessExtMap']?['cardType'].runtimeType}');
    // print(
    //     'bookingParamKey: ${json['bookingParamKey']} type: ${json['bookingParamKey'].runtimeType}');

    final extMap = json['businessExtMap'] is Map
        ? Map<String, dynamic>.from(json['businessExtMap'])
        : <String, dynamic>{};
    final bookingParamKey = json['bookingParamKey'] != null
        ? JsonHelper.toStr(json['bookingParamKey'])
        : JsonHelper.toStr(extMap['bookingParamKey']);
    final tag = json['tag'] != null
        ? JsonHelper.toStr(json['tag'])
        : JsonHelper.toStr(json['bookingParamKey']);

    return Vendor(
      bookingUrl: JsonHelper.toStr(json['bookingUrl']),
      price: JsonHelper.toDouble(json['price']),
      tax: JsonHelper.toDouble(json['tax']),
      totalPrice: JsonHelper.toDouble(json['totalPrice']),
      childPrice: json['childPrice'] != null
          ? JsonHelper.toDouble(json['childPrice'])
          : null,
      cabin: JsonHelper.toStr(json['cabin']),
      cabinCount: JsonHelper.toStr(json['cabinCount']),
      limitRule: JsonHelper.toStr(json['limitRule']),
      limitType: JsonHelper.toStr(json['limitType']),
      luggage: JsonHelper.toStr(json['luggage']),
      luggageMore: JsonHelper.toStr(json['luggageMore']),
      carryLuggage: JsonHelper.toStr(json['carryLuggage']),
      carryLuggageMore: JsonHelper.toStr(json['carryLuggageMore']),
      refund: JsonHelper.toStr(json['refund']),
      change: JsonHelper.toStr(json['change']),
      pType: JsonHelper.toStr(json['pType']),
      tag: tag,
      bookingParamKey: bookingParamKey,
      flightType: JsonHelper.toStr(json['flightType']),
      businessExtMap: BusinessExtMap.fromJson(extMap),
    );
  }
}

class BusinessExtMap {
  final int isSupportChild;
  final int childBuyAdult;
  final double? childPrice; // nullable
  final String childCabin;
  final String cardType;

  BusinessExtMap({
    required this.isSupportChild,
    required this.childBuyAdult,
    this.childPrice,
    required this.childCabin,
    required this.cardType,
  });

  factory BusinessExtMap.fromJson(Map<String, dynamic> json) {
    return BusinessExtMap(
      isSupportChild: JsonHelper.toInt(json['isSupportChild']),
      childBuyAdult: JsonHelper.toInt(json['childBuyAdult']),
      childPrice: json['childPrice'] != null
          ? JsonHelper.toDouble(json['childPrice'])
          : null,
      childCabin: JsonHelper.toStr(json['childCabin']),
      cardType: JsonHelper.toStr(json['cardType']),
    );
  }
}

class JsonHelper {
  static int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String toStr(dynamic value) {
    return value?.toString() ?? '';
  }
}
