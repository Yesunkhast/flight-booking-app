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

    // await deleteDatabase(path);
    print('db created at $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // await db.execute('DROP TABLE IF EXISTS user');
        await db.execute('''
          CREATE TABLE user (
            id TEXT PRIMARY KEY,
            username TEXT,
            image TEXT,
            idCard TEXT,
            dateOfBirth TEXT,
            phone TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  Future<void> deletedb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    await deleteDatabase(path);
  }
}
