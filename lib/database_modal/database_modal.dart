import 'package:hive/hive.dart';
part 'database_modal.g.dart';

@HiveType(typeId: 0)
class TaskManager extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? description;

  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  bool? completed;
  TaskManager({
    this.title,
    this.description,
    this.date,
    this.completed = false,
  });
}
