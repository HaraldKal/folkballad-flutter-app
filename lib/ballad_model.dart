import 'package:hive/hive.dart';

part 'ballad_model.g.dart';

@HiveType(typeId: 0)
class Ballad extends HiveObject {
  Ballad(
      {required this.title,
      required this.text,
      required this.source,
      required this.assetlocation,
      this.isFavorite = false});

  @HiveField(0)
  String title;

  @HiveField(1)
  String text;

  @HiveField(2)
  String source;

  @HiveField(3)
  String assetlocation;

  @HiveField(4)
  bool isFavorite;

  @HiveField(5)
  late List<Song> songs = List.empty(growable: true);

  void setIsFavorite(bool isFav) {
    isFavorite = isFav;
  }

  String? getTitle() {
    return title;
  }

  String getText() {
    return text;
  }

  String getSource() {
    return source;
  }

  String getAssetLocation() {
    if (assetlocation.isNotEmpty) {
      return assetlocation;
    }
    return 'N/A';
  }

  bool getIsFavorite() {
    return isFavorite;
  }

  void addSong(String subfilePath, String audfilePath, String s) {
    songs.add(Song(
        subtitlefilePath: subfilePath, audiofilePath: audfilePath, source: s));
  }

  bool hasSongs() {
    return songs.isNotEmpty;
  }

  Song? getSong(int index) {
    return songs[index];
  }

  @override
  String toString() {
    return title;
  }
}

@HiveType(typeId: 1)
class Song extends HiveObject {
  Song(
      {required this.subtitlefilePath,
      required this.audiofilePath,
      required this.source});

  @HiveField(0)
  String subtitlefilePath;

  @HiveField(1)
  String audiofilePath;

  @HiveField(2)
  String source;

  String getSource() {
    return source;
  }
}
