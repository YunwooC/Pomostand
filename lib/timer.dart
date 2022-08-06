import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:developer';
import 'dart:ui' as ui;

import 'micons_icons.dart';
import 'tomato_stand.dart';
import 'store.dart';
import 'main.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  double percent = 0;
  int _currentValue = 25;
  static int TimeInMin = 25;
  static int TimeInSec = TimeInMin * 60;
  static int LeftMin = TimeInMin;
  static int LeftSec = 0;
  static String Time = "";
  bool pause = false;
  bool stop = false;
  bool dropDownVisible = true;
  bool _IsVisibleStart = true;
  bool _IsVisiblePause = true;
  List<int> numList = [];

  // set up for coin system
  int _coin = 0;
  List<String>? _tomatoes = [];

  // time select options
  final unmodified_times = <String>[];
  final times = <String>[];
  String _dropdownValue = "10";

  initializeList() {
    numList.clear();
    for (int i = 10; i <= 120; i += 5) {
      numList.add(i);
    }
  }

  @override
  void initState() {
    print("Timer: init state called");
    super.initState();
    _loadAssets();
  }

  //Loading coin value on start
  Future<void> _loadAssets() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coin = (prefs.getInt('coin') ?? 0);
      _tomatoes = (prefs.getStringList('tomatoes') ?? []);
      print('$_coin');
      print('$_tomatoes');
    });
  }

  Future<void> _saveassets() async {
    print('tomatoes saved');
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tomatoes', _tomatoes!);
    prefs.setInt('coin', _coin);
  }

  // Timer Helper Functions
  pauseTimer() {
    pause = true;

    setState(() {
      _IsVisiblePause = false;
    });
  }

  startTimer() {
    stop = false;
    const oneSec = Duration(seconds: 1);

    int currentSec = 0;
    int leftAllSec = TimeInSec;
    LeftMin = TimeInMin;
    LeftSec = 0;

    setState(() {
      _IsVisibleStart = false;
      _IsVisiblePause = true;
      dropDownVisible = false;
    });

    Timer timer = Timer.periodic(oneSec, (Timer timer) {
      if (stop) {
        timer.cancel();
        return;
      }
      if (pause) {
        return;
      }
      setState(() {
        currentSec++;
        leftAllSec--;

        LeftMin = (leftAllSec / 60).floor();
        LeftSec = leftAllSec % 60;

        percent = currentSec / TimeInSec;

        if (leftAllSec == 0) {
          print("Timer done");
          _tomatoes?.add(_currentValue.toString());
          _saveassets();
          resetTimer();
        }
      });
    });
  }

  setTimer(int timeInMin) {
    print("set timer called");
    TimeInMin = timeInMin;
    TimeInSec = TimeInMin * 60;
    LeftMin = TimeInMin;
    LeftSec = 0;
  }

  resumeTimer() {
    // RESUMES TIMER FROM WHERE IT WAS PAUSED
    pause = false;
    setState(() {
      _IsVisiblePause = true;
    });
  }

  resetTimer() {
    LeftMin = TimeInMin;
    LeftSec = 0;
    pause = false;
    stop = true;
    percent = 0;
    // RESETS TIMER BACK TO THE START
    setState(() {
      dropDownVisible = true;
      _IsVisibleStart = true;
      _IsVisiblePause = false;
    });
  }


  getTime() {
    int Hour = (LeftMin / 60).toInt();
    int Min = LeftMin % 60;
    print('');
    print('Current Value: $_currentValue');
    print("left Min: $LeftMin");

    if (_currentValue >= 60) {
      print("value bigger than 1 hr");
      if (LeftMin >= 120) {
        print("remaining min bigger or equal to 2 hr");
        Time = '2';
        Time += ':' + ((LeftMin - 120) < 10? '0' + (LeftMin - 120).toString() : (LeftMin - 60).toString());
        Time += ':' + (LeftSec < 10? '0'+LeftSec.toString() : LeftSec.toString());
      } else if (LeftMin >= 60) {
        print('remaining min bigger than 1 hr');
        Time = '1';
        Time += ':' + ((LeftMin - 60) < 10? '0'+(LeftMin - 60).toString() : (LeftMin - 60).toString());
        Time += ':' + (LeftSec < 10? '0'+LeftSec.toString() : LeftSec.toString());
      } else {
        print('remaining min less than 1 hr');
        Time = '0';
        Time += ':' + (LeftMin < 10? '0'+LeftMin.toString() : LeftMin.toString());
        Time += ':' + (LeftSec < 10? '0'+LeftSec.toString() : LeftSec.toString());
      }
    } 
    else {
      print('value not bigger than 1 hr');
      Time = LeftMin < 10 ? '0'+LeftMin.toString() : LeftMin.toString();
      Time += ':' + (LeftSec < 10? '0'+LeftSec.toString() : LeftSec.toString());
    }
    
    return InkWell(
      child: Text(Time, style: TextStyle(color: Colors.white, fontSize: 27, letterSpacing: 1.3)),
      onTap: () {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(30.0),
              actionsAlignment: MainAxisAlignment.center,
              content: Container(
                height: 50,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: [
                        NumberPicker(
                          axis: Axis.horizontal,
                          value: _currentValue,
                          minValue: 10,
                          maxValue: 120,
                          step: 5,
                          itemWidth:50,
                          selectedTextStyle: TextStyle(fontSize: 25, color: Color(0xffeb5c3c)),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 2.0, color: Color.fromARGB(255, 234, 234, 234)),
                              right: BorderSide(width: 2.0, color: Color.fromARGB(255, 234, 234, 234))
                            )
                          ),
                          onChanged: (value) => setState(() => _currentValue = value),
                        )
                      ]
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Set", style: TextStyle(color: Color(0xffeb5c3c))),
                  onPressed: () {
                    print("Set called");
                    print(_currentValue);
                    setState(() => setTimer(int.parse(_currentValue.toString())));
                  
                    Navigator.pop(context);
                  }
                )
              ]
            );
          },
        );
      },
      borderRadius: BorderRadius.circular(50),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeList();
    print("timer page built");
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Timer Page"),
        iconTheme: IconThemeData(
          color: Color(0xffeb5c3c)
        ),
        actions: [
          IconButton(
            icon: Icon(Micons.StandIcon),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IndexPage(title: 'main')),
              );
            }
          ),
          IconButton(
            padding: EdgeInsets.all(6.0),
            icon: Icon(Micons.StoreIcon),
            onPressed: () {
              print("onpressed");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StorePage()),
              );
            }
          )
        ]
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
        padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0, bottom: 40.0),
        child: Column(
          children: [
            SizedBox(height:90),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/Tomato_1.png', fit: BoxFit.contain, width: 230),
                CircularPercentIndicator(
                  backgroundColor: Colors.white,
                  progressColor: Color(0xffeb5c3c),
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 75,
                  lineWidth: 5,
                ),
                getTime(),
              ]
            ),
            Row(
              children: <Widget> [
                Expanded(
                  child: Visibility(
                    visible: _IsVisibleStart,
                    child: IconButton(
                      onPressed: startTimer,
                      icon: Icon(Icons.play_arrow_rounded),
                      iconSize: 50,
                      color: Color(0xffeb5c3c)
                    )
                  )
                ),
              // Pause Button, Resume Button
              Expanded(
                child: Visibility(
                    visible: _IsVisiblePause,
                    // ignore: sort_child_properties_last
                    child: IconButton(
                      onPressed: pauseTimer,
                      icon: const Icon(Icons.pause_circle_filled_rounded),
                      iconSize: 50,
                      color: Color(0xffeb5c3c),
                    ),
                    // Resume Button appears in place of pause
                    replacement: IconButton(
                      onPressed: resumeTimer,
                      icon: const Icon(Icons.play_arrow_rounded),
                      iconSize: 50,
                      color: Color(0xffeb5c3c),
                    ),
                  ),
                ),
                // Reset Button
                Expanded(
                  child: IconButton(
                    onPressed: resetTimer,
                    icon: const Icon(Icons.stop_circle_rounded),
                    iconSize: 50,
                    color: Color(0xffeb5c3c),
                  )
                ),
              ]
            )
          ]
        )
      ),
    );  
  }
}
