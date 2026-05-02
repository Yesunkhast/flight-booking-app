import 'package:flight_app/models/realModel/passenger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _db;

  DatabaseService._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id TEXT PRIMARY KEY,
            token TEXT,
            lastName TEXT,
            firstName TEXT,
            image TEXT,
            idCard TEXT,
            birthday TEXT,
            phone TEXT,
            email TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE passenger (
            id INTEGER  PRIMARY KEY AUTOINCREMENT,
            idCard TEXT,
            lastName TEXT,
            firstName TEXT,
            birthday TEXT,
            passportValidDate TEXT,
            gender TEXT,
            type TEXT
          )
        ''');
      },
    );
  }

  Future<void> deletedb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    await deleteDatabase(path);
    print('db deleted at $path');
  }

// ########################## Passenger  ##########################

  Future<void> insertPassenger(Passenger passenger) async {
    final db = await database;

    // If no ID provided, generate one
    final passengerToInsert = passenger;

    print("Inserting passenger: ${passengerToInsert.toMap()}");

    await db.insert(
      'passenger',
      passengerToInsert.toMap(),
    );

    print(' passenger lastName: ${passengerToInsert.lastName}');
  }

  // ─── Get all passengers ─────────────────────────────────────
  Future<List<Passenger>> getAllPassengers() async {
    final db = await database;
    final result = await db.query('passenger');
    return result.map((e) => Passenger.fromMap(e)).toList();
  }

  // ─── Get single passenger ───────────────────────────────────
  Future<Passenger?> getPassenger(int id) async {
    final db = await database;
    final result = await db.query(
      'passenger',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Passenger.fromMap(result.first) : null;
  }

  // ─── Edit passenger ─────────────────────────────────────────
  Future<void> editPassenger({
    required int id,
    String? idCard,
    String? lastName,
    String? fistName,
    String? birthday,
    String? passportValidDate,
    String? gender,
  }) async {
    final db = await database;

    final Map<String, dynamic> updates = {};
    if (idCard != null) updates['idCard'] = idCard;
    if (lastName != null) updates['lastName'] = lastName;
    if (fistName != null) updates['fistName'] = fistName;
    if (birthday != null) updates['birthday'] = birthday;
    if (passportValidDate != null) {
      updates['passportValidDate'] = passportValidDate;
    }
    if (gender != null) updates['gender'] = gender;

    if (updates.isEmpty) return;

    await db.update(
      'passenger',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Passenger $id updated: $updates');
  }

  // ─── Delete passenger ───────────────────────────────────────
  Future<void> deletePassenger(int id) async {
    final db = await database;
    await db.delete(
      'passenger',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Passenger $id deleted');
  }

  // #################################### User ###########################

  // id TEXT PRIMARY KEY,
  // token TEXT,
  // surname TEXT,
  // name TEXT,
  // image TEXT,
  // idCard TEXT,
  // birthday TEXT,
  // phone TEXT,
  // email TEXT
  Future<void> editUser({
    required String id,
    String? token,
    String? lastName,
    String? firstName,
    String? image,
    String? idCard,
    String? birthday,
    String? phone,
    String? email,
  }) async {
    final db = await database;
    final Map<String, dynamic> updates = {};
    if (token != null) updates['token'] = token;
    if (lastName != null) updates['lastName'] = lastName;
    if (firstName != null) updates['firstName'] = firstName;
    if (image != null) updates['image'] = image;
    if (idCard != null) updates['idCard'] = idCard;
    if (birthday != null) updates['birthday'] = birthday;
    if (phone != null) updates['phone'] = phone;
    if (email != null) updates['email'] = email;
    if (updates.isEmpty) return;
    await db.update('user', updates);
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('user');
  }
}
