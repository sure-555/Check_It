// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanResultAdapter extends TypeAdapter<ScanResult> {
  @override
  final int typeId = 0;

  @override
  ScanResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanResult(
      id: fields[0] as String,
      scanDate: fields[1] as DateTime,
      imagePaths: (fields[2] as List).cast<String>(),
      violations: (fields[3] as List).cast<Violation>(),
      productName: fields[4] as String,
      brand: fields[5] as String,
      batchNumber: fields[6] as String,
      inspectorId: fields[7] as String?,
      location: fields[8] as String,
      isCompliant: fields[9] as bool,
      imageBytes: (fields[10] as List?)?.cast<Uint8List>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScanResult obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.scanDate)
      ..writeByte(2)
      ..write(obj.imagePaths)
      ..writeByte(3)
      ..write(obj.violations)
      ..writeByte(4)
      ..write(obj.productName)
      ..writeByte(5)
      ..write(obj.brand)
      ..writeByte(6)
      ..write(obj.batchNumber)
      ..writeByte(7)
      ..write(obj.inspectorId)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.isCompliant)
      ..writeByte(10)
      ..write(obj.imageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
