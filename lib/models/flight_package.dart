import 'package:flight_app/models/city.dart';
import 'package:flight_app/constants/img_api.dart';
import 'package:flight_app/models/plane.dart';

class FlightPackage {
  final String id;
  final String img;
  final City from;
  final City to;
  final Plane plane;
  final double price;
  final double discount;
  final String? label;
  final bool hasRefund;
  final bool roundTrip;
  final List<String>? tags;
  final String date;

  FlightPackage({
    required this.id,
    required this.img,
    required this.from,
    required this.to,
    required this.date,
    required this.plane,
    required this.price,
    this.discount = 0,
    this.label,
    this.hasRefund = true,
    this.roundTrip = true,
    this.tags,
  });
}

final List<FlightPackage> flightPackageList = [
  FlightPackage(
    id: '1',
    img: ImgApi.photo[51],
    from: cityList[1],
    to: cityList[2],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '2',
    img: ImgApi.photo[52],
    from: cityList[2],
    to: cityList[5],
    plane: planeList[2],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '3',
    img: ImgApi.photo[53],
    from: cityList[3],
    to: cityList[4],
    plane: planeList[3],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '4',
    img: ImgApi.photo[54],
    from: cityList[4],
    to: cityList[6],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '5',
    img: ImgApi.photo[55],
    from: cityList[1],
    to: cityList[2],
    plane: planeList[4],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '6',
    img: ImgApi.photo[56],
    from: cityList[6],
    to: cityList[7],
    plane: planeList[5],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '7',
    img: ImgApi.photo[57],
    from: cityList[7],
    to: cityList[8],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '8',
    img: ImgApi.photo[58],
    from: cityList[8],
    to: cityList[10],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '9',
    img: ImgApi.photo[59],
    from: cityList[9],
    to: cityList[12],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '10',
    img: ImgApi.photo[60],
    from: cityList[10],
    to: cityList[11],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '11',
    img: ImgApi.photo[61],
    from: cityList[11],
    to: cityList[12],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '12',
    img: ImgApi.photo[62],
    from: cityList[12],
    to: cityList[15],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '13',
    img: ImgApi.photo[63],
    from: cityList[13],
    to: cityList[14],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '14',
    img: ImgApi.photo[64],
    from: cityList[14],
    to: cityList[15],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '15',
    img: ImgApi.photo[65],
    from: cityList[15],
    to: cityList[16],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '16',
    img: ImgApi.photo[66],
    from: cityList[16],
    to: cityList[18],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '17',
    img: ImgApi.photo[67],
    from: cityList[17],
    to: cityList[18],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '18',
    img: ImgApi.photo[68],
    from: cityList[18],
    to: cityList[19],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '19',
    img: ImgApi.photo[69],
    from: cityList[20],
    to: cityList[22],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  ),
  FlightPackage(
    id: '20',
    img: ImgApi.photo[70],
    from: cityList[20],
    to: cityList[24],
    plane: planeList[1],
    price: 800,
    discount: 10,
    label: '10% OFF',
    date: '17 - 19 Aug 2025',
    tags: ['limited promo', '10% OFF']
  )
];