// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'timer.dart';
import 'tomato_stand.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      home: IndexPage(title: 'IndexPage'),
      theme: ThemeData(
        fontFamily: 'RobotoMono'
      )
    );
  }
}

// Index Page Display
class IndexPage extends StatelessWidget {
  IndexPage({Key? key, required this.title}) : super(key: key);
  final String title;

  int _coin = 0;
  List<String>? _tomatoes = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
        ),

        // container encapsulates the column
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
                        }));
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

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: MyApp(),
    ),
  );
}
