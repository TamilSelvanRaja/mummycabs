import 'dart:async';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class DbHelper {
  Database? myDb;

  Future<Database?> get db async {
    if (myDb != null) return myDb;
    myDb = await initDb();
    return myDb;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "mummycabs.db");
    var theDb = await openDatabase(path, version: 1, onCreate: onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      dropAllTable(db);
      onCreate(db, newVersion);
    }
  }

  void onCreate(Database db, int version) async {
    dropAllTable(db);
    await db.execute('''CREATE TABLE pendingList (uni_id INTEGER PRIMARY KEY AUTOINCREMENT,trip_date TEXT,vehicle_no TEXT,driver_id TEXT,ola_cash TEXT,
                        ola_operator TEXT,uber_cash TEXT,uber_operator TEXT,rapido_cash TEXT,rapido_operator TEXT,other_cash TEXT,
                        other_operator TEXT,total_cash_amt TEXT,total_operator_amt TEXT,salary_percentage TEXT,driver_salary TEXT,
                        fuel_amt TEXT,other_expences TEXT,other_desc TEXT,kilometer TEXT,balance_amount TEXT,per_km TEXT
                    )''');
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }

  Future<void> deleteAll() async {
    myDb?.execute("DELETE FROM pendingList");
  }

  void dropAllTable(Database db) {
    db.execute('DROP TABLE IF EXISTS pendingList');
  }
}
