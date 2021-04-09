// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MoneyBox.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoneyBoxAdapter extends TypeAdapter<MoneyBox> {
  @override
  final int typeId = 5;

  @override
  MoneyBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoneyBox(
      id: fields[0] as String,
      amount: fields[1] as double,
      history: fields[2] as History,
    );
  }

  @override
  void write(BinaryWriter writer, MoneyBox obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
