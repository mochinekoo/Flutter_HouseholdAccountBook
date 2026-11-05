import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseManager {

  static final DatabaseManager _manager = DatabaseManager();
  late Database _database;
  late List<Book> _list = [];

  static DatabaseManager GetInstance() {
    return _manager;
  }

   Future<void> InitDatabase() async {
    debugPrint("InitDatabase..");
    databaseFactory = databaseFactoryFfi;
    _database = await openDatabase(
        'book.db',
        version: 1,
        onCreate: (Database db, int ver) {
          return db.execute('CREATE TABLE book('
              'id INTEGER PRIMARY KEY , '
              'buyDate DATE, '
              'shopName varchar(255), '
              'itemName varchar(255),'
              'price INTEGER,'
              'someID INTEGER'');');
        },
        onOpen: (Database db) {
          debugPrint("openDatabase");
        }
    );

    var records = await _database.query('book');
    if (records.isNotEmpty) {
      for (int i = 0; i < records.length; i++) {
        var record = records[i];

        int id = record["id"] as int;
        String buyDateRaw = record["buyDate"] as String;
        DateTime buyDate = DateTime.parse(buyDateRaw);
        String shopName = record["shopName"] as String;
        String itemName = record["itemName"] as String;
        int price = record["price"] as int;
        int someID = record["someID"] as int;

        Book book = Book(
          dateTime: buyDate,
          shopName: shopName,
          itemName: itemName,
          someID: someID,
          price: price
        );

        _list.add(book);
      }

    }
  }

  Book Get(int index) {
    return _list[index];
  }

  List<Book> GetRawData() {
    return _list;
  }

  Future<void> Add(DateTime dateTime, String shopName, String item, int price, int someID) async {
    _list.add(Book(
        dateTime: dateTime,
        shopName: shopName,
        itemName:  item,
        price: price,
        someID:  someID));
    Save(dateTime, shopName, item, price, someID);
  }

  Future<void> Save(DateTime dateTime, String shopName, String item, int price, int someID) async {
    var value = await _database.query("book");
    debugPrint("dbに増やす前: " "${value.length}");

    _database.insert('book', {
      'buyDate': dateTime.toIso8601String(),
      'shopName': shopName,
      'itemName': item,
      'price': price,
      'someID': someID
    });

    value = await _database.query("book");
    debugPrint("dbに増やす前: " "${value.length}");
  }


}

class Book {
  late DateTime dateTime;
  late String shopName;
  late String itemName;
  late int price;
  late int someID;

  Book({
    required this.dateTime,
    required this.shopName,
    required this.itemName,
    required this.price,
    required this.someID});
}

