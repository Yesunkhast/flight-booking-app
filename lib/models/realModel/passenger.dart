class Passenger {
  final int? id;
  final String idCard;
  final String lastName;
  final String firstName;
  final String birthday;
  final String passportValidDate;
  final String gender;
  final String type; // "ADU" or "CHD" (child)

  Passenger({
    this.id,
    required this.idCard,
    required this.lastName,
    required this.firstName,
    required this.birthday,
    required this.passportValidDate,
    required this.gender,
    this.type = 'ADU', // default adult
  });

  static Future<Passenger> create({
    required String idCard,
    required String lastName,
    required String firstName,
    required String birthday,
    required String passportValidDate,
    required String gender,
    String type = 'ADU',
  }) async {
    return Passenger(
      idCard: idCard,
      lastName: lastName,
      firstName: firstName,
      birthday: birthday,
      passportValidDate: passportValidDate,
      gender: gender,
      type: type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCard': idCard,
      'lastName': lastName,
      'firstName': firstName,
      'birthday': birthday,
      'passportValidDate': passportValidDate,
      'gender': gender,
      'type': type,
    };
  }

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      id: map['id'],
      idCard: map['idCard'] ?? '',
      lastName: map['lastName'] ?? '',
      firstName: map['firstName'] ?? '',
      birthday: map['birthday'] ?? '',
      passportValidDate: map['passportValidDate'] ?? '',
      gender: map['gender'] ?? '',
      type: map['type'] ?? 'ADU',
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() =>
      'Passenger(id: $id, name: $fullName, passport: $idCard, type: $type)';
}

final Passenger passengerInit = Passenger(
    idCard: '',
    lastName: '',
    firstName: '',
    birthday: '',
    passportValidDate: '',
    gender: '');
