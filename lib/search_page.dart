import 'package:flutter/material.dart';
import 'ballad_model.dart';
import 'package:hive/hive.dart';
import 'ballad_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Box<Ballad> folkBalladsBox;
  List<Ballad> ballads = List.empty(growable: true);
  List<Ballad> matches = List.empty(growable: true);

  TextEditingController textEditController = TextEditingController();

  void searchForBallad(String query) {
    List<Ballad> searchResult = List.empty(growable: true);

    if (query.isEmpty) {
      matches = ballads;
      setState(() {});
      return;
    }

    query = query.toLowerCase();

    for (var element in ballads) {
      if (element.getTitle()!.toLowerCase().contains(query)) {
        searchResult.add(element);
      }
    }
    matches = searchResult;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    folkBalladsBox = Hive.box('folk_ballads');
    ballads.addAll(folkBalladsBox.values);
    matches = ballads;
  }

  @override
  Widget build(BuildContext context) {
    if (ballads.length != folkBalladsBox.length) {
      ballads.addAll(folkBalladsBox.values);
    }
    if (folkBalladsBox.isEmpty) {
      ballads.clear();
      matches.clear();
    }
    ballads.sort((a, b) =>
        a.toString()[0].toUpperCase().compareTo(b.toString()[0].toUpperCase()));

    return Scaffold(
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _listView(matches),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: textEditController,
                onChanged: searchForBallad,
                decoration: InputDecoration(
                  hintText: "Leita",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      textEditController.text = '';
                      searchForBallad(textEditController.text);
                    },
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _listView(matches) {
    int idx = 0;
    return Expanded(
      child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            Ballad ballad = matches[index];
            return SizedBox(
              width: double.maxFinite,
              child: TextButton(
                onPressed: () {
                  int i = 0;
                  // for loop to find the index in the sorted ballads list
                  // ballad.key does not match the index
                  // probably best to find a better way to implement the material
                  // page routes to use the ballad instead of an index number
                  for (Ballad b in ballads) {
                    if (b.toString() == ballad.toString()) {
                      idx = i;
                    }
                    i++;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondRoute(
                        index: idx,
                      ),
                    ),
                  );
                }, // do something when pressing the ballad
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(ballad.toString()),
                ),
              ),
            );
          }),
    );
  }
}
