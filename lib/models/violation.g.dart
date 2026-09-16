// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'violation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ViolationAdapter extends TypeAdapter<Violation> {
  @override
  final int typeId = 1;

  @override
  Violation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Violation(
      ruleId: fields[0] as String,
      ruleName: fields[1] as String,
      ruleCitation: fields[2] as String,
      description: fields[3] as String,
      suggestion: fields[4] as String,
      status: fields[5] as String,
      severity: fields[6] as String,
      confidence: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Violation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.ruleId)
      ..writeByte(1)
      ..write(obj.ruleName)
      ..writeByte(2)
      ..write(obj.ruleCitation)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.suggestion)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.severity)
      ..writeByte(7)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViolationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
