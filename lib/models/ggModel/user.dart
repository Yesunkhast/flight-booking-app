import 'package:flight_app/app/constants/img_api.dart';

class User {
  final String id;
  final String username;
  final String image;
  final String idCard;
  final String dateOfBirth;
  final String phone;
  final String email;
  // final String country;
  double? baggage;
  String? seat;
  String? type;

  User(
      {required this.id,
      required this.username,
      required this.image,
      required this.idCard,
      required this.dateOfBirth,
      required this.phone,
      required this.email,
      // required this.country,
      this.baggage,
      this.seat,
      this.type});

  User copyWith({double? baggage, String? seat, String? type}) => User(
      id: id,
      username: username,
      image: image,
      idCard: idCard,
      dateOfBirth: dateOfBirth,
      phone: phone,
      email: email,
      // country: country,
      baggage: baggage,
      seat: seat,
      type: type);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['name'] ?? json['username'] ?? '',
      image: json['avatar'] ?? json['image'] ?? '',
      idCard: json['idCard'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? json['birthDate'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      // country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'ip': idCard,
        'birthDate': dateOfBirth,
        // 'country': country,
        'phone': phone,
        'image': image,
        'email': email,
      };
}

final User userInit = User(
  id: '0',
  username: '',
  image: '',
  idCard: '',
  dateOfBirth: '',
  phone: '',
  email: '',
  // country: '',
);

final List<User> userList = [
  User(
    id: '1',
    username: 'John Doe',
    image: ImgApi.avatar[10],
    idCard: '0123456789',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '2',
    username: 'Jean Doe',
    // title: 'Mrs',
    image: ImgApi.avatar[0],
    idCard: '0123098765',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '3',
    username: 'James Doe',
    // title: 'Mr',
    image: ImgApi.avatar[9],
    idCard: '01234560987',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '4',
    username: 'Jena Doe',
    // title: 'Mrs',
    image: ImgApi.avatar[1],
    idCard: '01254387690',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '5',
    username: 'Jeni Doe',
    // title: 'Mrs',
    image: ImgApi.avatar[2],
    idCard: '01254309876',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '6',
    username: 'Jack Doe',
    // title: 'Mr',
    image: ImgApi.avatar[8],
    idCard: '01234509899',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '7',
    username: 'Joe Doe',
    // title: 'Mr',
    image: ImgApi.avatar[7],
    idCard: '01209876543',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '8',
    username: 'Jean Doe',
    // title: 'Mrs',
    image: ImgApi.avatar[3],
    idCard: '01235476980',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '9',
    username: 'Jihan Doe',
    // title: 'Mrs',
    image: ImgApi.avatar[4],
    idCard: '01254376890',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '10',
    username: 'Joy Doe',
    // title: 'Mrs',
    image: ImgApi.avatar[5],
    idCard: '01236549870',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
  User(
    id: '11',
    username: 'Jack Doe',
    // title: 'Mr',
    image: ImgApi.avatar[6],
    idCard: '012000034567',
    dateOfBirth: 'Jan 12, 1994',
    phone: '+628940391122',
    email: 'john_doe@mail.com',
    // country: 'Mexico',
  ),
];
