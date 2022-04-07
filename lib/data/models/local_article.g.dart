// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalArticleAdapter extends TypeAdapter<LocalArticle> {
  @override
  final int typeId = 1;

  @override
  LocalArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalArticle(
      title: fields[0] as String,
      urlToImage: fields[1] as String?,
      content: fields[3] as String?,
      publishedAt: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalArticle obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.urlToImage)
      ..writeByte(2)
      ..write(obj.publishedAt)
      ..writeByte(3)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
