// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'timer.dart';
import 'tomato_stand.dart';
import 'store.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      home: IndexPage(title: 'IndexPage'),
      theme: ThemeData(
        fontFamily: 'metrisch'
      )
    );
  }
}

// Index Page Display
class IndexPage extends StatelessWidget {
  IndexPage({Key? key, required this.title}) : super(key: key);
  final String title;
  int _low_price = 1000;
  int _high_price = 3000;

  int _coin = 0;
  List<String>? _tomatoes = [];
  List<storeItem> _store_items = [];

  Future<void> _loadAssets() async {
    final prefs = await SharedPreferences.getInstance();
      _coin = (prefs.getInt('coin') ?? 0);
      _tomatoes = (prefs.getStringList('tomatoes') ?? []);
      print('$_coin');
      print('$_tomatoes');
  }
  Future<void> _saveassets() async {
    print('tomatoes saved');
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tomatoes', _tomatoes!);
    prefs.setInt('coin', _coin);
  }

  _initStoreItems() {
    storeItem blue = new storeItem("Blue", "Rebel color", _low_price, "assets/images/Tomato_1.png");
    storeItem board = new storeItem("Board", "", _low_price, "assets/images/Tomato_1.png");
    storeItem jeff = new storeItem("Jeff", "A kind and smart dog, your best friend!", _high_price, "assets/images/Dog.png");
    _store_items.add(blue);
    _store_items.add(board);
    _store_items.add(jeff);
  }


  @override
  void initState() {
    _initStoreItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xffeb5c3c)
          ),
      ),

      drawer: Drawer(
        width: 150.0,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 223, 116, 109),
              ),
              child: Text('POMOSTAND'),
            ),
            ListTile(
              title: const Text('Main'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return IndexPage(title: "Timer");
                  })
                );
              }
            ),
            ListTile(
              title: const Text('Timer'),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const TimerPage(title: "Timer");
                  })
                );
              },
            ),
            ListTile(
              title: const Text('Stand'),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const TomatoStandPage();
                  })
                );
              },
            ),
            ListTile(
              title: const Text("Store"),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const StorePage();
                  })
                );
              }
            ),
          ],
        ),
      ),

      body: Container(
        margin: EdgeInsets.all(40), // green to see the container clearly

        // Main Body columnized
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Title
              const Text(
                "POMOSTAND",
                style: const TextStyle(fontSize: 40),
              ),
              GestureDetector(
                onTap: () {
                  _loadAssets();
                  _saveassets();
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return const TomatoStandPage();
                    })
                  );
                },
                child: Image.asset('assets/images/Tomato_Stand_Draft.jpeg', width: 300, height: 300)
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const TimerPage(title: 'Timer');
                  }));
                },
                child: const Text("Timer Page"),
                style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20)))
              )

            ]
        )
      )
    );
  }
}


class storeItem {
  String name = '???';
  String description = '???';
  int price = 0;
  String image = '';

  storeItem(String n, String d, int p, String i) {
    this.name = n;
    this.description = d;
    this.price = p;
    this.image = i;
  }

  _returnName () {
    return this.name;
  }
  _returnDesc () {
    return this.description;
  }
  _returnPrice () {
    return this.price;
  }
  _returnImage () {
    return this.image;
  }
}

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: MyApp(),
    ),
  );
}
