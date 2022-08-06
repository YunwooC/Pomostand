import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'micons_icons.dart';
import 'tomato_stand.dart';
import 'timer.dart';
import 'main.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<String> _tomatoes = [];
  int _coin = 0;
  int _high_price = 3000;
  int _low_price = 1000;

  List<String> _items = [];
  List<storeItem> _store_items = [];

  Future<void> _loadAssets() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tomatoes = (prefs.getStringList('tomatoes') ?? []);
      _coin = (prefs.getInt('coin') ?? 0);
      _items = (prefs.getStringList('items') ?? []);
    });
    print("Assets Loaded");
  }
  Future<void> _saveassets() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('tomatoes', _tomatoes);
      prefs.setInt('coin', _coin);
      prefs.setStringList('items', _items);
    });
    print('assets saved');
  }

  //DELOPER FUNCTION. REMOVE LATER
  _clearBoughtList() {
    _items.clear();
    _saveassets();
  }

  @override
  void initState() {
    super.initState();
    _initStoreItems();

    _loadAssets();
  }

  _initStoreItems() {
    storeItem blue = new storeItem("Blue", "Rebel color", _low_price, "assets/images/Tomato_1.png");
    storeItem board = new storeItem("Board", "", _low_price, "assets/images/Tomato_1.png");
    storeItem jeff = new storeItem("Jeff", "A kind and smart dog, your best friend!", _high_price, "assets/images/Dog.png");
    _store_items.add(blue);
    _store_items.add(board);
    _store_items.add(jeff);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
              onPressed: null
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
            Expanded(
              child: SizedBox(
                height: 200,
                child: ListView(
                  children: [
                    for (int i = 0; i < _store_items.length; i++) GestureDetector(
                      child: Card(color: Color.fromARGB(255, 236, 236, 236), 
                        child: Row(
                          children: [
                            Image.asset(_store_items[i]._returnImage(), width: 70, height: 70),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(_store_items[i]._returnName()),
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      size: 20,
                                      color: Colors.orange,
                                    ),
                                    Text(_store_items[i]._returnPrice().toString())
                                  ]
                                  
                                ),
                                Text(_store_items[i]._returnDesc()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (context) {
                            String titleText = "Use Pomocoin?";
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text(titleText),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        if (_coin < _store_items[i]._returnPrice()){
                                          setState(() {
                                            print("not enough coin");
                                            print(_coin >= _high_price);
                                            titleText = "insufficient coin";
                                          });
                                        } else {
                                          _coin -= _high_price;
                                          _items.add(_store_items[i]._returnName());

                                          setState(() {
                                            print("enough coin");
                                            print(_coin >= _high_price);
                                            // Make the Parent Widget Disappear
                                            titleText = "Bought!";
                                          });
                                        }
                                      },
                                      child: Text("Yes"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Yesn't"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        );
                        print('items bought: $_items');
                        print(i);
                      }
                    ),
                  ]
                ),
              ),
            ),
            Row(
              children: [
                Text(_items.toString()),
                ElevatedButton(
                  onPressed: () => _clearBoughtList(),
                  child: Text("clear list"),
                )
              ]
            )
          ],
        )

      )
    );
  }
}

class storeItem {
  String name = '???';
  String description = '???';
  int price = 0;
  String image = '';

  storeItem(String n, String d, int p, String i) {
    this.name = n;
    this.description = d;
    this.price = p;
    this.image = i;
  }

  _returnName () {
    return this.name;
  }
  _returnDesc () {
    return this.description;
  }
  _returnPrice () {
    return this.price;
  }
  _returnImage () {
    return this.image;
  }
}