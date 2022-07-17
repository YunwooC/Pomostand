import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Pomodoro', home: IndexPage(title: 'IndexPage'));
  }
}

// Index Page Display

class IndexPage extends StatelessWidget {
  IndexPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(title),
        ),

        // container encapsulates the column
        body: Container(
            margin: EdgeInsets.all(40),
            decoration: const BoxDecoration(
                color: Colors.lightGreen), // green to see the container clearly

            // Main Body columnized
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Title
                  const Text(
                    "POMOSTAND",
                    style: const TextStyle(fontSize: 40),
                  ),

                  // mage btw I got scammed they said it was transparent png but it's ugly checkerboard :/ placeholder for now
                  Image.asset(
                    'assets/images/tomato.png',
                    fit: BoxFit.cover,
                  ),

                  // Button to navigate to next page
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const TimerPage(title: 'Timer');
                        }));
                      },
                      child: const Text("CLICK ME",
                          style: const TextStyle(fontSize: 20)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20)))),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const TomatoPage(title: 'Tomato Stand');
                        }));
                      },
                      child: const Text("TO STAND"))
                ])));
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
  static int TimeInMin = 0;
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
        appBar: AppBar(backgroundColor: Colors.red, title: Text("Timer Page")),

        // Body
        body: Container(
            margin: EdgeInsets.all(40),

            // Formatting widgets in a container
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Pomodoro Timer"),
                  CircularPercentIndicator(
                    percent: percent,
                    animation: true,
                    animateFromLastPercent: true,
                    radius: 100,
                    lineWidth: 20,
                  ),
                  getTime(),
                  // Buttons
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Start Button
                        Visibility(
                          visible: _IsVisibleStart,
                          child: TextButton(
                              onPressed: startTimer,
                              child: Text("Start"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white))),
                        ),
                        // Pause Button, Resume Button
                        Visibility(
                            visible: _IsVisiblePause,
                            child: TextButton(
                                onPressed: pauseTimer,
                                child: Text("Pause"),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.white))),
                            // Resume Button appears in place of pause
                            replacement: TextButton(
                              onPressed: resumeTimer,
                              child: Text("Resume"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                            )),
                        // Reset Button
                        TextButton(
                            onPressed: resetTimer,
                            child: Text("Reset"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white))),

                        DropdownButton<String>(
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
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _incrementcoin,
                        child: Text("coin+"),
                      ),
                      TextButton(
                          onPressed: _decrementcoin, child: Text("coin-")),
                      Text("$_coin"),
                    ],
                  )
                ])));
  }
}

// Fruit Stand Display
class TomatoPage extends StatefulWidget {
  const TomatoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TomatoPage> createState() => TomatoPageState();
}

class TomatoPageState extends State<TomatoPage> {
  // assets
  List<String> _tomatoes = [];
  int _coin = 0;

  @override
  void initState() {
    print("Tomato Status Page Initialized");
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tomatoes = (prefs.getStringList('tomatoes') ?? []);
      _coin = (prefs.getInt('coin') ?? 0);
    });
  }

  Future<void> _saveassets() async {
    print('assets saved');
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tomatoes', _tomatoes);
    prefs.setInt('coin', _coin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Tomato Stand Page"),
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: [
                  for (var i in _tomatoes)
                    InkWell(
                      onTap: () {
                        showAlertDialog(
                            context: context, time: i, tomatoes: _tomatoes);
                      },
                      child: Image.asset(
                        'assets/images/tomato.png',
                        fit: BoxFit.cover,
                      ),
                    )
                ],
              ),
            ),
            TextButton(
                child: Text("Sell All"),
                onPressed: () {
                  for (var i in _tomatoes) {
                    _coin = _coin + int.parse(i) * 10;
                  }
                  _tomatoes.clear();
                  _saveassets();
                })
          ],
        ),
      ),
    );
  }
}

showAlertDialog(
    {required BuildContext context,
    required String time,
    required List<String> tomatoes}) {
  int price = int.parse(time) * 10;

  // set up the button
  Widget okButton = TextButton(
    child: Text("Sell"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Tomato"),
    content:
        Column(children: [Text("Time Focused: $time"), Text("Price: $price")]),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: MyApp(),
    ),
  );
}
