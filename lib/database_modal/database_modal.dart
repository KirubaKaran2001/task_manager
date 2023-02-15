import 'package:hive/hive.dart';
part 'database_modal.g.dart';

@HiveType(typeId: 0)
class TaskManager extends HiveObject {
  @HiveField(0)
  String? description;

  @HiveField(1)
  DateTime? date;
}
