import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pomodoro', home: const IndexPage(title: 'IndexPage'));
  }
}

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key, required this.title}) : super(key: key);
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
                ])));
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  double percent = 0;
  static int TimeInMin = 2;
  static int TimeInSec = TimeInMin * 60;

  static int LeftMin = TimeInMin;
  static int LeftSec = 0;
  static String Time = "";
  bool stop = false;
  bool _IsVisibleStart = true;
  bool _IsVisiblePause = true;


  pauseTimer() {
    stop = true;

    setState(() {
      _IsVisiblePause = false;
    });
  }

// NEED MODIFICATION
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
      setState(() {
        currentSec++;
        leftAllSec--;

        LeftMin = (leftAllSec / 60).floor();
        LeftSec = leftAllSec % 60;

        percent = currentSec / TimeInSec;

        if (leftAllSec == 0) {
          timer.cancel();
        }
      });
    });
  }

// NEED TO BE IMPLEMENTED
  resumeTimer() {
    // RESUMES TIMER FROM WHERE IT WAS PAUSED 

    setState(() {
      _IsVisiblePause = true;
    });
  }

// NEED TO BE IMPLEMENTED
  resetTimer() {
    // RESETS TIMER BACK TO THE START
    setState(() {
      _IsVisibleStart = true;
      _IsVisiblePause = true;
    });
  }

  getTime() {
    Time = LeftMin<10 ? '0'+LeftMin.toString():LeftMin.toString();
    Time = Time + ' : ' + (LeftSec<10 ? '0'+LeftSec.toString() : LeftSec.toString());
    return Text(Time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        // Top AppBar
        appBar: AppBar(backgroundColor: Colors.red),

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
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)
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
                                MaterialStateProperty.all(Colors.white)
                            ),
                          )
                        ),
                        // Reset Button
                        TextButton(
                          onPressed: resetTimer,
                          child: Text("Reset"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            foregroundColor: MaterialStateProperty.all(Colors.white)
                          )
                        )
                      ]
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