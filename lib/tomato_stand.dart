import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'dart:ui' as ui;

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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tomatoes = (prefs.getStringList('tomatoes') ?? []);
      _coin = (prefs.getInt('coin') ?? 0);
    });
    _populateList();
    print("Assets Loaded");
  }
  Future<void> _saveassets() async {
    print('assets saved');
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('tomatoes', _tomatoes);
      prefs.setInt('coin', _coin);
    });
    print('assets saved');
  }

  _populateList() {
    int index = 0;
    for (int i = 0; i < 4; i++)
      for (int r = 0; r < 2; r++) {
        _tomato_List[i][r] = _tomatoes.length > index? _tomatoes[index] : "";
        index++;
        print('tomato item: $_tomatoes');
      }
    print("2D Tomatoes List: $_tomato_List");
  }

  _sellTomato(int index) {
    _coin += int.parse(_tomatoes[index]) * 5;
    _tomatoes.removeAt(index);
    _saveassets();
    _loadAssets();
  }
  //DEVELOPER FUNCTIONS : REMOVE LATER
  _sellAllTomatoes() {
    for (String tomato in _tomatoes){
      _coin += int.parse(tomato) * 5;
    }
    _tomatoes.clear();
    _saveassets();
    _loadAssets();
  }
  _addTomato(String time) {
    _tomatoes.add(time);
    _saveassets();
    _loadAssets();
  }
  _removeTomato() {
    _tomatoes.removeLast();
    _saveassets();
    _loadAssets();
  }
  
  @override
  void initState() {
    print("Tomato Status Page Initialized");

    super.initState();
    _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    int price;
    String time;
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
          // Coin
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
          SizedBox(height: 180),
          // Tomato and Crate
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                // Back of the Crate
                Positioned(
                  top: 0,
                  left: -50,
                  child: Image.asset('assets/images/Crate_Back.png', width: 400, height: 230)
                ),
                // Tomatoes
                Positioned(
                  left: 75,
                  top: 10,
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
                                if (c == 0)
                                  Positioned(
                                    left: c * 90,
                                    top: (r+1) * 60,
                                    child: RotationTransition(
                                      turns: AlwaysStoppedAnimation(-40/360),
                                      child: GestureDetector(
                                        onTap: () => {
                                          print("on called"),
                                          // Variable to print
                                          price = int.parse(_tomato_List[r][c]) * 5,
                                          time = _tomato_List[r][c],

                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text('Tomato'),
                                              content: Text('''Time: $time:00 \n Price: $price'''),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {
                                                    _sellTomato(r * 2),
                                                    Navigator.pop(context, 'Sell')
                                                  },
                                                  child: const Text('Sell'),
                                                ),
                                              ],
                                            ),
                                          )
                                        },
                                        child: Image.asset('assets/images/Tomato_1.png', width: 120, height: 120)
                                      )
                                    )
                                  )
                                else 
                                  Positioned(
                                    left: c * 80,
                                    top: r * 60,
                                    child: RotationTransition(
                                      turns: AlwaysStoppedAnimation(-40/360),
                                      child: GestureDetector(
                                        onTap: () => {
                                          print("On called "),
                                          // Variable to print
                                          price = int.parse(_tomato_List[r][c]) * 5,
                                          time = _tomato_List[r][c],

                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text('Tomato'),
                                              content: Text('''Time: $time:00 \n Price: $price'''),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {
                                                     _sellTomato(r * 2 + 1),
                                                     Navigator.pop(context, 'Sell')
                                                  },
                                                  child: const Text('Sell'),
                                                ),
                                              ],
                                            ),
                                          )
                                        },
                                        child: Image.asset('assets/images/Tomato_1.png', width: 120, height: 120)
                                      )
                                    )
                                  )
                        ]
                      ),
                      
                    ),
                  ),
                ),
                // Right side of the Crate
                Positioned(
                  top: 25,
                  left: 205,
                  height: 280,
                  child: Image.asset('assets/images/Crate_Side.png')
                ),
                // Front side of the Crate
                Positioned(
                  top: 195,
                  left: -62,
                  width: 280,
                  child: Image.asset('assets/images/Crate_Front.png')
                ),
                
                // DEVELOPER FUNCTIONS: REMOVE LATER
                Positioned(
                  left: 20,
                  top: 250,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _sellAllTomatoes();
                        },
                        child: const Text("Sell All"),
                        style: ButtonStyle(
                          backgroundColor:
                            MaterialStateProperty.all(Colors.white)
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _addTomato("3");
                        },
                        child: const Text("Add Tomato")
                      ),
                      TextButton(
                        onPressed: () {
                          _removeTomato();
                        },
                        child: const Text("remove Tomato")
                      ),
                    ],
                  )
                )
              ]
          
            ),
          )
        ]
      )
    );
  }
  
  
}

