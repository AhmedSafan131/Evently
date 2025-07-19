// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_event_screen.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventDataAdapter extends TypeAdapter<EventData> {
  @override
  final int typeId = 0;

  @override
  EventData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventData(
      day: fields[0] as String,
      month: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      image: fields[4] as String?,
      isFavorite: fields[5] as bool,
      time: fields[6] as String,
      date: fields[7] as DateTime?,
      category: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EventData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
