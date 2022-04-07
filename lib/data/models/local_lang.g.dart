// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_lang.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalLangAdapter extends TypeAdapter<LocalLang> {
  @override
  final int typeId = 2;

  @override
  LocalLang read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalLang(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalLang obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.langCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalLangAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
