import 'package:app/ballad_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ballad and Song should be created', () {
    // Arrange
    Ballad ballad = Ballad(
        title: 'balladTitle',
        text: 'text',
        source: 'source',
        assetlocation: 'assetlocation');

    Song song = Song(
        subtitlefilePath: 'subfilepath',
        audiofilePath: 'audfilepath',
        source: 'source');

    // Act
    ballad.setIsFavorite(true);
    ballad.addSong('subfilepath', 'audfilepath', 'source');

    // Assert
    expect(ballad.title, 'balladTitle');
    expect(ballad.text, 'text');
    expect(ballad.source, 'source');
    expect(ballad.assetlocation, 'assetlocation');
    expect(ballad.isFavorite, true);
    expect(ballad.hasSongs(), true);
    expect(ballad.getSong(0), isA<Song>());
    expect(song.subtitlefilePath, 'subfilepath');
    expect(song.audiofilePath, 'audfilepath');
    expect(song.getSource(), 'source');
  });
}
