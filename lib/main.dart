// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'dart:ui' as ui;

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

// Timer Page Display
class TimerPage extends StatefulWidget {
  const TimerPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  double percent = 0;
  static int TimeInMin = 1;
  static int TimeInSec = TimeInMin * 60;
  static int LeftMin = TimeInMin;
  static int LeftSec = 0;
  static String Time = "";
  bool pause = false;
  bool stop = false;
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

  //Incrementing coin after click
  Future<void> _incrementcoin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coin = (prefs.getInt('coin') ?? 0) + 1;
      prefs.setInt('coin', _coin);
    });
    print("add coin: $_coin");
  }

  Future<void> _decrementcoin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coin = (prefs.getInt('coin') ?? 0) - 1;
      prefs.setInt('coin', _coin);
    });
    print("subract coin: $_coin");
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
          _tomatoes?.add(TimeInMin.toString());
          _saveassets();
          resetTimer();
        }
      });
    });
  }

  setTimer(int timeInMin) {
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
      _IsVisibleStart = true;
      _IsVisiblePause = true;
    });
  }

  getTime() {
    Time = LeftMin < 10 ? '0' + LeftMin.toString() : LeftMin.toString();
    Time = Time +
        ' : ' +
        (LeftSec < 10 ? '0' + LeftSec.toString() : LeftSec.toString());
    return Text(Time);
  }

  @override
  Widget build(BuildContext context) {
    initializeList();
    print("timer page built");
    return Scaffold(

        // Top AppBar
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text("Timer Page"),
          iconTheme: IconThemeData(
            color: Colors.black
          )
        ),

        body: Container(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0, bottom: 40.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/Tomato_1.jpeg', fit: BoxFit.contain),
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: 8.0,
                      sigmaY: 8.0,
                    ),
                    child: CircularPercentIndicator(
                      backgroundColor: Colors.transparent,
                      progressColor: Colors.red,
                      percent: percent,
                      animation: true,
                      animateFromLastPercent: true,
                      radius: 80,
                      lineWidth: 10,
                    ),
                  ),
                  getTime()
                ]
              ),
              Row(
                children: <Widget> [
                  Expanded(
                    child: Visibility(
                      visible: _IsVisibleStart,
                      child: TextButton(
                          onPressed: startTimer,
                          child: Text("Start"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              overlayColor: MaterialStateProperty.all(Color(0xFFCDB1B6))
                          )
                      ),
                    )
                  ),
                  // Pause Button, Resume Button
                  Expanded(
                    child: Visibility(
                      visible: _IsVisiblePause,
                      // ignore: sort_child_properties_last
                      child: TextButton(
                          onPressed: pauseTimer,
                          child: const Text("Pause"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    )
                              ),
                              overlayColor: MaterialStateProperty.all(Color(0xFFCDB1B6))                          
                          )
                      ),
                      // Resume Button appears in place of pause
                      replacement: TextButton(
                        onPressed: resumeTimer,
                        child: Text("Resume"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                )
                            ),
                            overlayColor: MaterialStateProperty.all(Color(0xFFCDB1B6))     
                        ),
                              
                      )
                    ),
                  ),
                  // Reset Button
                  Expanded(
                    child: TextButton(
                        onPressed: resetTimer,
                        child: Text("Reset"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                            overlayColor: MaterialStateProperty.all(Color(0xFFCDB1B6))
                        )   
                    )
                  ),

                  Expanded(
                    child: DropdownButton<String>(
                          value: _dropdownValue,
                          onChanged: (String? newValue) {
                            print('update called');
                            setTimer(int.parse(newValue.toString()));
                            setState(() {
                              _dropdownValue = newValue!;
                            });
                          },
                          items: numList.map((int val) {
                            return new DropdownMenuItem<String>(
                              value: val.toString(),
                              child: Text(val.toString()),
                            );
                          }).toList(),
                    )
                  )
                ]
              )
            ]
          )
        ),
    );  
  }
}



class TomatoStandPage extends StatefulWidget {
  const TomatoStandPage({Key? key}) : super(key: key);

  @override
  State<TomatoStandPage> createState() => _TomatoStandPageState();
}

class _TomatoStandPageState extends State<TomatoStandPage> {
  List<String> _tomatoes = [];
  List<List<String>> _tomato_List = List.generate(4, (i) => List.filled(2, "", growable: false), growable: false);
  int _coin = 0;

  Future<void> _loadAssets() async {
    print("Assets Loaded");
    final prefs = await SharedPreferences.getInstance();
    print('pref brought');
    setState(() {
      _tomatoes = (prefs.getStringList('tomatoes') ?? []);
      _coin = (prefs.getInt('coin') ?? 0);
      print('Raw Tomatoes: $_tomatoes');
      print('Coin: $_coin');
    });
    _populateList();
    print("List Populated");
  }

  Future<void> _saveassets() async {
    print('assets saved');
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('tomatoes', _tomatoes);
      prefs.setInt('coin', _coin);
    });
  }

  _populateList() {
    int index = 0;
    for (int i = 0; i < 4; i++)
      for (int r = 0; r < 2; r++) {
        _tomato_List[i][r] = _tomatoes.length > index? _tomatoes[index] : "";
        index++;
        print('index: $index');
        print('tomato item: $_tomatoes');
      }
    print("2D Tomatoes List: $_tomato_List");
  }

  @override
  void initState() {
    print("Tomato Status Page Initialized");

    super.initState();
    _loadAssets();
    print("Tomatoes: $_tomatoes");
    print("2D Tomatoes List at initstate: $_tomato_List");
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
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Container(
              width: 340.0,
              height: 200.0,
              padding: EdgeInsets.all(10),
              child: Card(
                child: Column(
                  children: [
                    Text("Time: "),
                    Text("Price:"),
                  ]
                )
              )
            ),
          ),
          Expanded(
            flex: 1,
            // CRATE AND TOMATO
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: -50,
                  child: Image.asset('assets/images/Crate_Back.png', width: 400, height: 230)
                ),
                // Tomatoes
                Positioned(
                  left: 70,
                  top: 40,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(40/360),
                    child: Container(
                      height: 300,
                      width: 300,
                      child: Stack(
                        children: [
                          for (var r = 0; r < _tomato_List.length; r++)
                            for (var c = 0; c < _tomato_List[0].length; c++)
                              if (_tomato_List[r][c] != "")
                                Positioned(
                                  left: c * 90,
                                  top: r * 60,
                                  child: Image.asset('assets/images/Tomato_1.jpeg', width: 110, height: 110)
                                )
                          
                        ]
                      ),
                      
                    ),
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 205,
                  height: 280,
                  child: Image.asset('assets/images/Crate_Side.png')
                ),
                Positioned(
                  top: 195,
                  left: -62,
                  width: 280,
                  child: Image.asset('assets/images/Crate_Front.png')
                )
              ]
          
            ),
          )
        ]
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
