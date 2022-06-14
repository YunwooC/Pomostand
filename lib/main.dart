import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
              "Pomostand!",
            ),
        ),
        
        // container encapsulates the column
        body: Container(
          
          margin: EdgeInsets.all(25),
          color: Colors.lightGreen,        // green to see the container clearly
          
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "POMOSTAND",
                style: const TextStyle(fontSize: 40)
              ),
              Image.asset('assets/images/tomato.png'),
              TextButton(
                onPressed: null,
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