import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:accout/models/transactions.dart';

class TransactionDB {
  String dbName;

  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(Transactions statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    var keyID = store.add(db, {
      "title": statement.title,
      "amount": statement.amount,
      "date": statement.date.toIso8601String(),
      "user": statement.user,
      "password": statement.password,
      "products": statement.products,
    });
    db.close();
    return keyID;
  }

  Future<List<Transactions>> loadAllData() async {
    // Open the database
    var db = await openDatabase();

    // Define the store (table)
    var store = intMapStoreFactory.store('expense');

    // Fetch the records, ordered by the key in descending order
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    // Initialize the transactions list
    List<Transactions> transactions = [];

    // Iterate over each record in the snapshot
    for (var record in snapshot) {
      try {
        transactions.add(Transactions(
          keyID: record.key,
          title: record.value['title'].toString(),
          amount: double.tryParse(record.value['amount'].toString()) ??
              0.0, // Safe conversion with default value 0.0
          date: DateTime.tryParse(record.value['date'].toString()) ??
              DateTime.now(),
          user: record.value['user'].toString(),
          password: record.value['password'].toString(),
          products:
              record.value['products'].toString(), // Handle date parsing safely
        ));
      } catch (e) {
        print('Error parsing record: $e'); // Print any error
      }
    }

    return transactions;
  }

  deleteDatabase(int index) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    await store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, index)));
    db.close();
  }

  updateDatabase(Transactions statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    var filter = Finder(filter: Filter.equals(Field.key, statement.keyID));
    var result = await store.update(db, finder: filter, {
      "title": statement.title,
      "amount": statement.amount,
      "date": statement.date.toIso8601String(),
      "user": statement.user,
      "password": statement.password,
      "products": statement.products,
    });
    await db.close();
    print("update result: $result");
  }
}
