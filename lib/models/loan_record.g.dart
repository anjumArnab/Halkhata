// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanRecordAdapter extends TypeAdapter<LoanRecord> {
  @override
  final int typeId = 1;

  @override
  LoanRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoanRecord(
      name: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as DateTime,
      remainingAmount: fields[3] as double,
      transactions: (fields[4] as HiveList?)?.castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, LoanRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.remainingAmount)
      ..writeByte(4)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
