import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'ballad_model.dart';

import 'ballad_page.dart';
import 'favorite_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

const folkballads = 'folk_ballads';
const songs = 'songs';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BalladAdapter());
  Hive.registerAdapter(SongAdapter());
  await Hive.openBox<Ballad>(folkballads);
  await Hive.openBox<Song>(songs);

  runApp(const PrototypeApp());
}

class PrototypeApp extends StatelessWidget {
  const PrototypeApp({Key? key}) : super(key: key);

  // This widget is the root the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prototype Demo',
      theme: ThemeData(
        // This is the theme of the application.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.book),
                  text: 'Kvæðir',
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: 'Favorite',
                ),
                Tab(
                  icon: Icon(Icons.search),
                  text: 'Search',
                ),
                Tab(
                  icon: Icon(Icons.settings),
                  text: 'Settings',
                ),
              ],
            ),
            title: const Text('Kvæði App Prototype'),
          ),
          body: const TabBarView(
            children: [
              BalladPage(),
              FavoritePage(),
              SearchPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
