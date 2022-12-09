import 'dart:developer';
import 'package:subtitle/subtitle.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:app/main.dart';
import 'ballad_model.dart';

class BalladPage extends StatefulWidget {
  const BalladPage({super.key});

  @override
  State<BalladPage> createState() => _BalladPageState();
}

class _BalladPageState extends State<BalladPage> {
  late Box<Ballad> folkBalladsBox;

  late String jallgrimskvaedi;
  late String olavurHinHeilagi;
  late String brestisKvaedi;

  List<Ballad> ballads = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    folkBalladsBox = Hive.box(folkballads);
  }

  Widget _buildBalladListView() {
    ballads.addAll(folkBalladsBox.values);

    ballads.sort((a, b) =>
        a.toString()[0].toUpperCase().compareTo(b.toString()[0].toUpperCase()));

    return SizedBox(
      width: double.maxFinite,
      height: 1.0,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: folkBalladsBox.length,
        itemBuilder: (context, index) {
          String? title = ballads[index].getTitle();
          return SizedBox(
            width: double.maxFinite,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondRoute(
                      index: index,
                    ),
                  ),
                );
              }, // do something when pressing the ballad
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title!),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBalladListView();
  }
}

class SecondRoute extends StatelessWidget {
  SecondRoute({Key? key, required this.index}) : super(key: key);

  final int index;

  late Box<Ballad> folkBalladsBox;
  List<Ballad> ballads = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    folkBalladsBox = Hive.box(folkballads);
    ballads.addAll(folkBalladsBox.values);

    ballads.sort((a, b) =>
        a.toString()[0].toUpperCase().compareTo(b.toString()[0].toUpperCase()));

    return Scaffold(
      appBar: AppBar(
        title: Text(ballads[index].toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            tooltip:
                'Display information regarding the source of the folk ballad',
            onPressed: () {
              log('ballad info button pressed');
              Fluttertoast.showToast(
                  msg: ballads[index].getSource(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
          ballads[index].hasSongs()
              ? IconButton(
                  icon: const Icon(Icons.headphones),
                  tooltip: 'Play folk ballad',
                  onPressed: () {
                    log('Lurta button pressed!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThirdRoute(
                          index: index,
                        ),
                      ),
                    );
                  },
                )
              : IconButton(
                  onPressed: () {
                    log('Lurta (no song) button pressed');
                    Fluttertoast.showToast(
                        msg: "Eingin ljóðupptøka finnst enn fyri hetta kvæði\n"
                            "\nhaldið okkum til góðar",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  icon: const Icon(Icons.headphones),
                ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: FittedBox(
            child: Text(
              ballads[index].getText(),
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}

class ThirdRoute extends StatefulWidget {
  final int index;

  const ThirdRoute({Key? key, required this.index}) : super(key: key);

  @override
  State<ThirdRoute> createState() => _ThirdRouteState();
}

class _ThirdRouteState extends State<ThirdRoute> {
  Box<Ballad> folkBalladsBox = Hive.box(folkballads);
  List<Ballad> ballads = List.empty(growable: true);

  // audio player
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String text = '';
  Subtitle? sub;
  late SubtitleController controller;

  @override
  void initState() {
    super.initState();
    ballads.addAll(folkBalladsBox.values);
    log("ballad List size: ${ballads.length}");
    ballads.sort((a, b) =>
        a.toString()[0].toUpperCase().compareTo(b.toString()[0].toUpperCase()));
    // setting up the subtitle controller
    var path = 'assets/ballads/braestis_kvaedi/brestir.srt';
    controller = SubtitleController(
      provider: AssetSubtitle(path),
    );

    initializeSubController(controller);

    // audio player
    audioPlayer
        .setSource(AssetSource(ballads[widget.index].getAssetLocation()));

    // listen to state change of audioplayer
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    // listen to duration change of audioplayer
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.initialized) {
      sub = controller
          .durationSearch(Duration(milliseconds: position.inMilliseconds));
      log(sub?.data ?? 'niðurlag');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(ballads[widget.index].toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            tooltip:
                'Display information regarding the source of the audio and subtitle',
            onPressed: () {
              log("audio and subtitle info button pressed");
              Fluttertoast.showToast(
                  msg: ballads[widget.index].getSource(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      sub?.data.replaceAll('#', '\n') ?? 'niðurlag',
                      style: const TextStyle(fontSize: 30.0),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatPosition(position)),
                  Text(formatPosition(duration)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      tooltip: 'Play folk ballad',
                      onPressed: () async {
                        log('play button pressed');
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.resume();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        Text(position.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatPosition(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return '$minutes:$seconds';
}

class AssetSubtitle extends SubtitleProvider {
  final String path;
  final SubtitleType? type;

  const AssetSubtitle(
    this.path, {
    this.type,
  });

  @override
  Future<SubtitleObject> getSubtitle() async {
    final data = await rootBundle.loadString(path);
    const type = SubtitleType.srt;

    return SubtitleObject(data: data, type: type);
  }
}

void initializeSubController(SubtitleController controller) async {
  // initialize the subtitle controller
  await controller.initial();
}
