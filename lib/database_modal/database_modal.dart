import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'database_modal.g.dart';

@HiveType(typeId: 0)

class TaskManager extends HiveObject {

 
  @HiveField(0)
  String? description;

  @HiveField(1)
  String? date;

  @HiveField(2)
  String? time;
}
