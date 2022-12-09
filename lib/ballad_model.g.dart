// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ballad_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalladAdapter extends TypeAdapter<Ballad> {
  @override
  final int typeId = 0;

  @override
  Ballad read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ballad(
      title: fields[0] as String,
      text: fields[1] as String,
      source: fields[2] as String,
      assetlocation: fields[3] as String,
      isFavorite: fields[4] as bool,
    )..songs = (fields[5] as List).cast<Song>();
  }

  @override
  void write(BinaryWriter writer, Ballad obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.assetlocation)
      ..writeByte(4)
      ..write(obj.isFavorite)
      ..writeByte(5)
      ..write(obj.songs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalladAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 1;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      subtitlefilePath: fields[0] as String,
      audiofilePath: fields[1] as String,
      source: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.subtitlefilePath)
      ..writeByte(1)
      ..write(obj.audiofilePath)
      ..writeByte(2)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
