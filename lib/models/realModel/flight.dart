class Flight {
  final List<FlightInfo> flightInfos;
  final int cheapPrice;

  Flight({
    required this.flightInfos,
    required this.cheapPrice,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightInfos: (json['flightInfos'] as List? ?? [])
          .map((e) => FlightInfo.fromJson(e))
          .toList(),
      cheapPrice: JsonHelper.toInt(json['cheapPrice']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'flightInfos': flightInfos.map((e) => e.toJson()).toList(),
      'cheapPrice': cheapPrice,
    };
  }
}

class FlightInfo {
  final List<FlightSegment> flightSegment;
  final FlightExtInfo flightExtInfo;

  FlightInfo({
    required this.flightSegment,
    required this.flightExtInfo,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      flightSegment: (json['flightSegment'] as List)
          .map((e) => FlightSegment.fromJson(e))
          .toList(),
      flightExtInfo: FlightExtInfo.fromJson(json['flightExtInfo']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'flightSegment': flightSegment.map((e) => e.toJson()).toList(),
      'flightExtInfo': flightExtInfo.toJson(),
    };
  }
}

class FlightSegment {
  final String dpt;
  final String dptDate;
  final String dptTime;
  final String dptCityName;
  final String dptCityNameEng;
  final String dptAirport;
  final String dptAirportEng;
  final String dptTerminal;

  final String arr;
  final String arrDate;
  final String arrTime;
  final String arrCityName;
  final String arrCityNameEng;
  final String arrAirport;
  final String arrAirportEng;
  final String arrTerminal;

  final String flightNum;
  final String actFlightNum;
  final String airline;
  final String airlineCode;
  final String airlineLogo;

  final String distance;
  final String flightTimes;

  final String cabinType;
  final String cabinCount;

  final int stopsNum;
  final List<StopInfo> stopInfoList;

  final String tripNote;

  FlightSegment({
    required this.dpt,
    required this.dptDate,
    required this.dptTime,
    required this.dptCityName,
    required this.dptCityNameEng,
    required this.dptAirport,
    required this.dptAirportEng,
    required this.dptTerminal,
    required this.arr,
    required this.arrDate,
    required this.arrTime,
    required this.arrCityName,
    required this.arrCityNameEng,
    required this.arrAirport,
    required this.arrAirportEng,
    required this.arrTerminal,
    required this.flightNum,
    required this.actFlightNum,
    required this.airline,
    required this.airlineCode,
    required this.airlineLogo,
    required this.distance,
    required this.flightTimes,
    required this.cabinType,
    required this.cabinCount,
    required this.stopsNum,
    required this.stopInfoList,
    required this.tripNote,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      dpt: JsonHelper.toStr(json['dpt']),
      dptDate: JsonHelper.toStr(json['dptDate']),
      dptTime: JsonHelper.toStr(json['dptTime']),
      dptCityName: JsonHelper.toStr(json['dptCityName']),
      dptCityNameEng: JsonHelper.toStr(json['dptCityNameEng']),
      dptAirport: JsonHelper.toStr(json['dptAirport']),
      dptAirportEng: JsonHelper.toStr(json['dptAirportEng']),
      dptTerminal: JsonHelper.toStr(json['dptTerminal']),

      arr: JsonHelper.toStr(json['arr']),
      arrDate: JsonHelper.toStr(json['arrDate']),
      arrTime: JsonHelper.toStr(json['arrTime']),
      arrCityName: JsonHelper.toStr(json['arrCityName']),
      arrCityNameEng: JsonHelper.toStr(json['arrCityNameEng']),
      arrAirport: JsonHelper.toStr(json['arrAirport']),
      arrAirportEng: JsonHelper.toStr(json['arrAirportEng']),
      arrTerminal: JsonHelper.toStr(json['arrTerminal']),

      flightNum: JsonHelper.toStr(json['flightNum']),
      actFlightNum: JsonHelper.toStr(json['actFlightNum']),
      airline: JsonHelper.toStr(json['airline']),
      airlineCode: JsonHelper.toStr(json['airlineCode']),
      airlineLogo: JsonHelper.toStr(json['airlineLogo']),

      distance: JsonHelper.toStr(json['distance']),

      flightTimes: JsonHelper.toStr(json['flightTimes']),

      cabinType: JsonHelper.toStr(json['cabinType']),

      // handles "A" or "2"
      cabinCount: JsonHelper.toStr(json['cabinCount']),

      stopsNum: JsonHelper.toInt(json['stopsNum']),

      stopInfoList: (json['stopInfoList'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => StopInfo.fromJson(e))
          .toList(),
      //  handles bool / string / null
      tripNote: JsonHelper.toStr(json['tripNote']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dpt': dpt,
      'dptDate': dptDate,
      'dptTime': dptTime,
      'dptCityName': dptCityName,
      'dptCityNameEng': dptCityNameEng,
      'dptAirport': dptAirport,
      'dptAirportEng': dptAirportEng,
      'dptTerminal': dptTerminal,
      'arr': arr,
      'arrDate': arrDate,
      'arrTime': arrTime,
      'arrCityName': arrCityName,
      'arrCityNameEng': arrCityNameEng,
      'arrAirport': arrAirport,
      'arrAirportEng': arrAirportEng,
      'arrTerminal': arrTerminal,
      'flightNum': flightNum,
      'actFlightNum': actFlightNum,
      'airline': airline,
      'airlineCode': airlineCode,
      'airlineLogo': airlineLogo,
      'distance': distance,
      'flightTimes': flightTimes,
      'cabinType': cabinType,
      'cabinCount': cabinCount,
      'stopsNum': stopsNum,
      'stopInfoList': stopInfoList.map((e) => e.toJson()).toList(),
      'tripNote': tripNote,
    };
  }
}

class StopInfo {
  final String stopAirportCode;
  final String stopCityCode;
  final String stopCityName;
  final String stopCityNameEng;
  final String stopAirportName;
  final String stopAirportNameEng;
  final String arr;
  final String dpt;
  final String arrDate;
  final String arrTime;
  final String dptDate;
  final String dptTime;
  final String planeType;
  final String arrTerminal;
  final String dptTerminal;
  final String flightNum;

  StopInfo({
    required this.stopAirportCode,
    required this.stopCityCode,
    required this.stopCityName,
    required this.stopCityNameEng,
    required this.stopAirportName,
    required this.stopAirportNameEng,
    required this.arr,
    required this.dpt,
    required this.arrDate,
    required this.arrTime,
    required this.dptDate,
    required this.dptTime,
    required this.planeType,
    required this.arrTerminal,
    required this.dptTerminal,
    required this.flightNum,
  });

  factory StopInfo.fromJson(Map<String, dynamic> json) {
    return StopInfo(
      stopAirportCode: JsonHelper.toStr(json['stopAirportCode']),
      stopCityCode: JsonHelper.toStr(json['stopCityCode']),
      stopCityName: JsonHelper.toStr(json['stopCityName']),
      stopCityNameEng: JsonHelper.toStr(json['stopCityNameEng']),
      stopAirportName: JsonHelper.toStr(json['stopAirportName']),
      stopAirportNameEng: JsonHelper.toStr(json['stopAirportNameEng']),
      arr: JsonHelper.toStr(json['arr']),
      dpt: JsonHelper.toStr(json['dpt']),
      arrDate: JsonHelper.toStr(json['arrDate']),
      arrTime: JsonHelper.toStr(json['arrTime']),
      dptDate: JsonHelper.toStr(json['dptDate']),
      dptTime: JsonHelper.toStr(json['dptTime']),
      planeType: JsonHelper.toStr(json['planeType']),
      arrTerminal: JsonHelper.toStr(json['arrTerminal']),
      dptTerminal: JsonHelper.toStr(json['dptTerminal']),
      flightNum: JsonHelper.toStr(json['flightNum']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'stopAirportCode': stopAirportCode,
      'stopCityCode': stopCityCode,
      'stopCityName': stopCityName,
      'stopCityNameEng': stopCityNameEng,
      'stopAirportName': stopAirportName,
      'stopAirportNameEng': stopAirportNameEng,
      'arr': arr,
      'dpt': dpt,
      'arrDate': arrDate,
      'arrTime': arrTime,
      'dptDate': dptDate,
      'dptTime': dptTime,
      'planeType': planeType,
      'arrTerminal': arrTerminal,
      'dptTerminal': dptTerminal,
      'flightNum': flightNum,
    };
  }
}

class FlightExtInfo {
  final String code;
  final int stopsNum;
  final String nctype;
  final String? flightType;
  final String? tripType;
  final String? waitTime;
  final double price;
  final int tax;
  final double totalPrice;

  FlightExtInfo({
    required this.code,
    required this.stopsNum,
    required this.nctype,
    this.flightType,
    this.waitTime,
    required this.price,
    required this.tax,
    required this.totalPrice,
    this.tripType,
  });

  factory FlightExtInfo.fromJson(Map<String, dynamic> json) {
    return FlightExtInfo(
      code: JsonHelper.toStr(json['code']),
      stopsNum: JsonHelper.toInt(json['stopsNum']),
      nctype: JsonHelper.toStr(json['nctype']),
      flightType: JsonHelper.toStr(json['flightType']),
      tripType: JsonHelper.toStr(json['tripType']),
      waitTime: JsonHelper.toStr(json['waitTime']),
      price: JsonHelper.toDouble(json['price']),
      tax: JsonHelper.toInt(json['tax']),
      totalPrice: JsonHelper.toDouble(json['totalPrice']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'stopsNum': stopsNum,
      'nctype': nctype,
      'flightType': flightType,
      'tripType': tripType,
      'waitTime': waitTime,
      'price': price,
      'tax': tax,
      'totalPrice': totalPrice,
    };
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
