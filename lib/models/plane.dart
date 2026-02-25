import 'package:flight_app/constants/img_api.dart';

class Plane {
  final String id;
  final String code;
  final String name;
  final String description;
  final String logo;
  final String classType;
  final String? photo;

  Plane({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.logo,
    required this.classType,
    this.photo
  });
}

final List<Plane> planeList = [
  Plane(
    id: '1',
    code: 'JET123',
    name: 'Boeing 747',
    classType: 'Economy',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[91],
  ),
  Plane(
    id: '2',
    code: 'JETA380',
    name: 'Airbus A380',
    classType: 'Economy',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[92],
  ),
  Plane(
    id: '3',
    code: 'JET737',
    name: 'Boeing 737',
    classType: 'Economy',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[93],
  ),
  Plane(
    id: '4',
    code: 'JETA380',
    name: 'Airbus A380',
    classType: 'Economy',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[94],
  ),
  Plane(
    id: '5',
    code: 'JET320',
    name: 'Airbus A320',
    classType: 'Economy',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[95],
  ),
  Plane(
    id: '6',
    code: 'JET777',
    name: 'Boeing 777',
    classType: 'Business',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[96],
  ),
  Plane(
    id: '7',
    code: 'JET787',
    name: 'Boeing 787 Dreamliner',
    classType: 'Business',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[97],
  ),
  Plane(
    id: '8',
    code: 'JET350',
    name: 'Airbus A350',
    classType: 'Business',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[98],
  ),
  Plane(
    id: '9',
    code: 'JET707',
    name: 'Embraer E-Jets',
    classType: 'First',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[99],
  ),
  Plane(
    id: '10',
    code: 'JETCRJ',
    name: 'Bombardier CRJ',
    classType: 'First',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue eros, tincidunt sed posuere id, viverra sed orci. ',
    logo: ImgApi.photo[100],
  )
];

