import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/database_modal/database_modal.dart';

class Boxes {
  static Box<TaskManager> getdetails() =>
      Hive.box<TaskManager>('task');
}