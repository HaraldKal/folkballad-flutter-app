import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'ballad_model.dart';
import 'package:app/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Box<Ballad> folkBalladsBox;
  late Box<Song> songBox;

  @override
  void initState() {
    super.initState();
    folkBalladsBox = Hive.box(folkballads);
    songBox = Hive.box(songs);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          TextButton(
              onPressed: () {
                _populateBallads();
              },
              child: const Text('Populate database')),
          TextButton(
              onPressed: () {
                folkBalladsBox.clear();
              },
              child: const Text('Clear database')),
        ],
      ),
    );
  }

  void _populateBallads() async {
    String jallgrimskvaedi;
    String olavurHinHeilagi;
    String brestisKvaedi;

    jallgrimskvaedi = await rootBundle
        .loadString('assets/ballads/jallgrimskvaedi/jallgrimskvaedi.txt');

    olavurHinHeilagi = await rootBundle.loadString(
        'assets/ballads/olavur_hin_heilagi/olavur_hin_heilagi_FK_74B.txt');

    brestisKvaedi = await rootBundle
        .loadString('assets/ballads/braestis_kvaedi/brestis_kvaedi.txt');

    Ballad balladBrestisKvaedi = Ballad(
        title: 'Brestis Kvæði',
        text: brestisKvaedi,
        source: "N/A",
        assetlocation: 'ballads/braestis_kvaedi/brestir.ogg');

    balladBrestisKvaedi.addSong('ballads/braestis_kvaedi/brestir.ogg',
        'ballads/braestis_kvaedi/brestir.ogg', 'Havnar Dansifelag');

    folkBalladsBox.add(Ballad(
        title: 'Jallgrímskvæði',
        text: jallgrimskvaedi,
        source: "N/A",
        assetlocation: 'N/A'));
    folkBalladsBox.add(Ballad(
        title: 'Ólavur Hin Heilagi',
        text: olavurHinHeilagi,
        source: "N/A",
        assetlocation: 'N/A'));
    folkBalladsBox.add(balladBrestisKvaedi);
  }
}
