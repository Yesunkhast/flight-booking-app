import 'package:flight_app/constants/img_api.dart';

class Airport {
  final String id;
  final String code;
  final String name;
  final String? photo;
  final String location;

  Airport({
    required this.id,
    required this.code,
    required this.name,
    this.photo,
    required this.location,
  });
}

final List<Airport> airportList = [
  Airport(
    id: '1',
    photo: ImgApi.photo[121],
    code: 'LCY',
    name: 'City Airport',
    location: 'London'
  ),
  Airport(
    id: '2',
    photo: ImgApi.photo[122],
    code: 'LIS',
    name: 'Lisbon Portela Airport',
    location: 'Lisbon'
  ),
  Airport(
    id: '3',
    photo: ImgApi.photo[123],
    code: 'LTN',
    name: 'Luton Airport ',
    location: 'London'
  ),
  Airport(
    id: '4',
    photo: ImgApi.photo[124],
    code: 'KLIA',
    name: 'Kuala Lumpur International Airport ',
    location: 'Kuala Lumpur'
  ),
  Airport(
    id: '5',
    photo: ImgApi.photo[125],
    code: 'IST',
    name: 'Istanbul Airport',
    location: 'Istanbul',
  ),
  Airport(
    id: '6',
    photo: ImgApi.photo[126],
    code: 'DXB',
    name: 'Dubai International Airport',
    location: 'Dubai'
  ),
  Airport(
    id: '7',
    photo: ImgApi.photo[127],
    code: 'NRT',
    name: 'Narita International Airport',
    location: 'Tokyo'
  ),
  Airport(
    id: '8',
    photo: ImgApi.photo[128],
    code: 'CMN',
    name: 'Casablanca Mohammed V International Airport',
    location: 'Casablanca'
  ),
  Airport(
    id: '9',
    photo: ImgApi.photo[129],
    code: 'PEK',
    name: 'Beijing Capital International Airport ',
    location: 'Beijing'
  ),
  Airport(
    id: '10',
    photo: ImgApi.photo[130],
    code: 'DPS',
    name: 'Ngurah Rai International Airport',
    location: 'Bali'
  ),
  Airport(
    id: '11',
    photo: ImgApi.photo[121],
    code: 'BKK',
    name: 'Suvarnabhumi Airport',
    location: 'Bangkok'
  ),
  Airport(
    id: '12',
    photo: ImgApi.photo[122],
    code: 'HND',
    name: 'Haneda Airport',
    location: 'Tokyo'
  ),
  Airport(
    id: '13',
    photo: ImgApi.photo[123],
    code: 'DCA',
    name: 'Ronald Reagan Washington National Airport ',
    location: 'Washington'
  ),
  Airport(
    id: '14',
    photo: ImgApi.photo[124],
    code: 'NRT',
    name: 'Narita International Airport',
    location: 'Tokyo'
  ),
  Airport(
    id: '15',
    photo: ImgApi.photo[125],
    code: 'SIN',
    name: 'Changi Airport',
    location: 'Singapore',
  ),
  Airport(
    id: '16',
    photo: ImgApi.photo[126],
    code: 'CDG',
    name: 'Charles de Gaulle Airport',
    location: 'Paris'
  ),
  Airport(
    id: '17',
    photo: ImgApi.photo[127],
    code: 'JFK',
    name: 'John F. Kennedy International Airport',
    location: 'New York'
  ),
  Airport(
    id: '18',
    photo: ImgApi.photo[128],
    code: 'DCO',
    name: 'Rome-Fiumicino Airport',
    location: 'Rome'
  ),
  Airport(
    id: '19',
    photo: ImgApi.photo[129],
    code: 'SIN',
    name: 'Changi Airport',
    location: 'Singapore'
  ),
  Airport(
    id: '20',
    photo: ImgApi.photo[130],
    code: 'BOM',
    name: 'Chhatrapati Shivaji Maharaj International Airport ',
    location: 'Mumbai'
  ),
  Airport(
    id: '21',
    photo: ImgApi.photo[121],
    code: 'DEL',
    name: 'Indira Gandhi International Airport',
    location: 'New Delhi'
  ),
  Airport(
    id: '22',
    photo: ImgApi.photo[122],
    code: 'ICN',
    name: 'Incheon International Airport',
    location: 'Seoul'
  ),
  Airport(
    id: '23',
    photo: ImgApi.photo[123],
    code: 'SFO',
    name: 'San Francisco International Airport (SFO)',
    location: 'San Francisco'
  ),
  Airport(
    id: '24',
    photo: ImgApi.photo[124],
    code: 'NWE',
    name: 'NeW York Liberty International Airport',
    location: 'New York'
  ),
  Airport(
    id: '25',
    photo: ImgApi.photo[125],
    code: 'MLE',
    name: 'Velana International Airport',
    location: 'Maldives'
  ),
  Airport(
    id: '26',
    photo: ImgApi.photo[126],
    code: 'VCE',
    name: 'Venice Marco Polo Airport',
    location: 'Venice'
  ),
  Airport(
    id: '27',
    photo: ImgApi.photo[127],
    code: 'JDE',
    name: 'King Abdulaziz International Airport',
    location: 'Jeddah'
  ),
  Airport(
    id: '28',
    photo: ImgApi.photo[128],
    code: 'BER',
    name: 'Berlin Brandenburg Airport',
    location: 'Berlin'
  ),
  Airport(
    id: '29',
    photo: ImgApi.photo[129],
    code: 'AEP',
    name: 'Jorge Newbery Airport',
    location: 'Buenos Aires'
  ),
  Airport(
    id: '30',
    photo: ImgApi.photo[130],
    code: 'BDO',
    name: 'Husein Sastranegara International Airport',
    location: 'Bandung'
  )
];