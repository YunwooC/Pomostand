import 'package:flutter/material.dart';


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
          
        margin: EdgeInsets.all(25),       
        decoration: const BoxDecoration(color: Colors.lightGreen),   // green to see the container clearly
          
          
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "POMOSTAND",
              style: const TextStyle(fontSize: 40),
                
            ),

            Image.asset(
              'assets/images/tomato.png',
              fit: BoxFit.cover,
            ),

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
      appBar: AppBar(
        title: Text(title)
      ),
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