// ignore_for_file: avoid_print
import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:task_manager/constants/constants.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(COLLECTION_NAME);
    await collection.insertMany([
      {
        "name": "kiruba",
        "age": "23",
        "gender": "male",
      },
      {
        "name": "karan",
        "age": "22",
        "gender": "male",
      }
    ]);
    print(await collection.find().toList());
  }
}
