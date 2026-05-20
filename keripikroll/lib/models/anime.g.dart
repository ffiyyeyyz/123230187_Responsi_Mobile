// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime.dart';

class AnimeAdapter extends TypeAdapter<Anime> {
  @override
  final int typeId = 0;

  @override
  Anime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Anime(
      id: fields[0] as String,
      titleEnJp: fields[1] as String,
      titleEn: fields[2] as String,
      synopsis: fields[3] as String?,
      averageRating: fields[4] as String?,
      ageRating: fields[5] as String?,
      ageRatingGuide: fields[6] as String?,
      episodeCount: fields[7] as int?,
      posterImageSmall: fields[8] as String?,
      posterImageLarge: fields[9] as String?,
      coverImageOriginal: fields[10] as String?,
      status: fields[11] as String?,
      startDate: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Anime obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleEnJp)
      ..writeByte(2)
      ..write(obj.titleEn)
      ..writeByte(3)
      ..write(obj.synopsis)
      ..writeByte(4)
      ..write(obj.averageRating)
      ..writeByte(5)
      ..write(obj.ageRating)
      ..writeByte(6)
      ..write(obj.ageRatingGuide)
      ..writeByte(7)
      ..write(obj.episodeCount)
      ..writeByte(8)
      ..write(obj.posterImageSmall)
      ..writeByte(9)
      ..write(obj.posterImageLarge)
      ..writeByte(10)
      ..write(obj.coverImageOriginal)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
