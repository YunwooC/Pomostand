import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'dart:ui' as ui;

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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 20,
                  color: Colors.orange,
                ),
                Text(" $_coin"),
              ]
            ),
            SizedBox(height:90),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/Tomato_1.png', fit: BoxFit.contain),
                CircularPercentIndicator(
                  backgroundColor: Colors.transparent,
                  progressColor: Colors.red,
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 80,
                  lineWidth: 10,
                ),
                getTime(),
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