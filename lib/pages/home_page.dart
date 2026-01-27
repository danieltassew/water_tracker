import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box("MY_BOX");
  final _cupSizeTextController = TextEditingController();
  final _targetSizeTextController = TextEditingController();

  var formatter = NumberFormat('#,##,000');

  int _counter = 0;
  int _cupSize = 600;
  int _tragetSize = 3000;

  @override
  void initState() {
    _counter = _myBox.get("Counter") ?? 0;
    _cupSize = _myBox.get("CupSize") ?? 600;
    _tragetSize = _myBox.get("TargetSize") ?? 3000;
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter += _cupSize;
    });
    _myBox.put("Counter", _counter);
  }

  void _decrementCounter() {
    setState(() {
      _counter -= _cupSize;
    });
    _myBox.put("Counter", _counter);
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _myBox.put("Counter", _counter);
  }

  void _setCupSize() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Set cup size"),
        content: TextField(
          controller: _cupSizeTextController,
          decoration: InputDecoration(hintText: "$_cupSize"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cupSizeTextController.clear();
            },
            child: Text("Cancel", style: TextStyle(fontSize: 18)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cupSize = int.tryParse(_cupSizeTextController.text) ?? _cupSize;
              _cupSizeTextController.clear();
              _myBox.put("CupSize", _cupSize);
            },
            child: Text("Save", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _setTraget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Set target"),
        content: TextField(
          controller: _targetSizeTextController,
          decoration: InputDecoration(hintText: "$_tragetSize"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _targetSizeTextController.clear();
            },
            child: Text("Cancel", style: TextStyle(fontSize: 18)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _tragetSize =
                    int.tryParse(_targetSizeTextController.text) ?? _tragetSize;
              });
              _targetSizeTextController.clear();
              _myBox.put("TargetSize", _tragetSize);
            },
            child: Text("Save", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Water Tracker"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: _setCupSize,
                child: Text(
                  "Set cup size",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              PopupMenuItem(
                onTap: _setTraget,
                child: Text(
                  "Set target",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              PopupMenuItem(
                onTap: _resetCounter,
                child: Text(
                  "Reset counter",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedFlipCounter(
              value: _counter,
              thousandSeparator: ',',
              negativeSignDuration: Duration(milliseconds: 150),
              duration: Duration(milliseconds: 600),
              curve: Curves.linear,
              textStyle: TextStyle(fontSize: 50),
            ),
            Text(
              "/${formatter.format(_tragetSize)}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: _decrementCounter,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
