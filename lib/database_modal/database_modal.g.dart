// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskManagerAdapter extends TypeAdapter<TaskManager> {
  @override
  final int typeId = 0;

  @override
  TaskManager read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskManager()
      ..description = fields[0] as String?
      ..date = fields[1] as String?
      ..time = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, TaskManager obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskManagerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
