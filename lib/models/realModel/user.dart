class User {
  final String id;
  final String phone;
  final String email;
  final String lastName;
  final String firstName;
  final String gender;
  final String birthday;
  final String point;
  final bool isOperator;
  final String image;
  final String? idCard;
  double? baggage;
  String? seat;
  String? type;

  User(
      {required this.id,
      required this.phone,
      required this.email,
      required this.lastName,
      required this.firstName,
      required this.gender,
      required this.birthday,
      required this.point,
      required this.isOperator,
      required this.image,
      this.idCard,
      this.baggage,
      this.seat,
      this.type});

  User copyWith({double? baggage, String? seat, String? type}) => User(
      id: id,
      phone: phone,
      email: email,
      lastName: lastName,
      firstName: firstName,
      image: image,
      gender: gender,
      birthday: birthday,
      point: point,
      isOperator: isOperator,
      idCard: idCard,
      baggage: baggage,
      seat: seat,
      type: type);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      lastName: json['surname'] ?? json['lastName'] ?? '',
      firstName: json['name'] ?? json['firstName'] ?? '',
      image: json['avatar'] ?? json['image'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? json['birthDate'] ?? '',
      point: json['point'] ?? '',
      isOperator: json['is_operator'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'phone': phone,
        'email': email,
        'lastName': lastName,
        'firstName': firstName,
        'image': image,
        'gender': gender,
        'birthday': birthday,
        'point': point,
        'is_operator': isOperator,
      };
}
