class Passenger {
  final int? id;
  final String idcard;
  final String lastname;
  final String firstname;
  final String birthday;
  final String passportvaliddate;
  final String gender;
  final String type; // "ADU" or "CHD" (child)

  Passenger({
    this.id,
    required this.idcard,
    required this.lastname,
    required this.firstname,
    required this.birthday,
    required this.passportvaliddate,
    required this.gender,
    this.type = 'ADU', // default adult
  });

  static Future<Passenger> create({
    required String idcard,
    required String lastname,
    required String firstname,
    required String birthday,
    required String passportvaliddate,
    required String gender,
    String type = 'ADU',
  }) async {
    return Passenger(
      idcard: idcard,
      lastname: lastname,
      firstname: firstname,
      birthday: birthday,
      passportvaliddate: passportvaliddate,
      gender: gender,
      type: type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idcard': idcard,
      'lastname': lastname,
      'firstname': firstname,
      'birthday': birthday,
      'passportvaliddate': passportvaliddate,
      'gender': gender,
      'type': type,
    };
  }

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      id: map['id'],
      idcard: map['idcard'] ?? '',
      lastname: map['lastname'] ?? '',
      firstname: map['firstname'] ?? '',
      birthday: map['birthday'] ?? '',
      passportvaliddate: map['passportvaliddate'] ?? '',
      gender: map['gender'] ?? '',
      type: map['type'] ?? 'ADU',
    );
  }

  String get fullName => '$firstname $lastname';

  @override
  String toString() =>
      'Passenger(id: $id, name: $fullName, passport: $idcard, type: $type)';
}

final Passenger passengerInit = Passenger(
    idcard: '',
    lastname: '',
    firstname: '',
    birthday: '',
    passportvaliddate: '',
    gender: '');
