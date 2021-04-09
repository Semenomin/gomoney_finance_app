// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Debtor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtorAdapter extends TypeAdapter<Debtor> {
  @override
  final int typeId = 7;

  @override
  Debtor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Debtor(
      id: fields[0] as String,
      lendAmount: fields[1] as double,
      borrowAmount: fields[2] as double,
      history: fields[3] as History,
    );
  }

  @override
  void write(BinaryWriter writer, Debtor obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lendAmount)
      ..writeByte(2)
      ..write(obj.borrowAmount)
      ..writeByte(3)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
