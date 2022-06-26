import 'package:flutter/material.dart';
import 'dart:async';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      home: const IndexPage(title: 'IndexPage')
    );
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
        
        margin: EdgeInsets.all(40),    // green to see the container clearly
          
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TimerPage(title: 'Timer');
                }));
              },
              child: const Text(
                "CLICK ME",
                style: const TextStyle(fontSize: 20)
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20)
                )
              )
            ),
          ]
        )
      )
    );
  }
}

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // Top AppBar
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(title)
      ),

      // Body
      body: Container(
        margin: EdgeInsets.all(40),    

        // Formatting widgets in a container   
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Expanded(
              child: Container()
            ),

            // Tomato Progress Ring. Expanded setting must be kept
            Expanded(
              child: Placeholder(
                 color: Colors.red,
              ),
              flex: 3,
            ),

            // Timer goes here. Expanded setting to be kept.
            Expanded(
              child: Placeholder( color: Colors.blue )
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: null,
                  child: const Text("Start")

                ),
                TextButton(
                  onPressed: null,
                  child: const Text("Stop")
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