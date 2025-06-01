import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'water intake app',

      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyApp_home(),
    );
  }
}

class MyApp_home extends StatefulWidget {
  const MyApp_home({super.key});

  @override
  State<MyApp_home> createState() => _MyApp_homeState();
}

class _MyApp_homeState extends State<MyApp_home> {
  int _waterintake = 0;
  int _dailygoal = 8;
  final List<int> _dailygoaloption = [8, 10, 12];

  @override
  void initState() {
    super.initState();
    _loadperference();
  }

  Future<void> _loadperference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterintake = (pref.getInt("waterintake") ?? 0);
      _dailygoal = (pref.getInt("dailygoal") ?? 8);
    });
  }

  Future<void> _increment_MyApp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterintake++;
      pref.setInt('water intake', _waterintake);
      if (_waterintake >= _dailygoal) {
        //show dialog
        _showgoalreachdialog();
      }
    });
  }

  Future<void> _resetwaterintake() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterintake = 0;
      pref.setInt('water intake', _waterintake);
    });
  }

  Future<void> _setdailygoal(int newGoal) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      _dailygoal = newGoal;
      pref.setInt('daily goal', newGoal);
    });
  }

  Future<void> _showgoalreachdialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('congratulation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'You hve reached your daily goal of $_dailygoal glass of water ',
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ok"),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  Future<void> _showresetconfirmation() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset water intake'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you sure you want to reset your water  intake ? '),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("cancel"),
            ),
            TextButton(
              onPressed: () {
                _resetwaterintake();

                Navigator.of(context).pop();
              },
              child: Text("Reset"),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = _waterintake / _dailygoal;
    bool goalreached = _waterintake >= _dailygoal;
    return Scaffold(
      appBar: AppBar(title: Text("water intake app")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.water_drop, size: 120, color: Colors.blue),
              SizedBox(height: 10),
              Text('You have consumed :', style: TextStyle(fontSize: 18)),
              Text(
                '$_waterintake glass of water ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                minHeight: 20,
              ),
              SizedBox(height: 10),
              Text("Daily Goal ", style: TextStyle(fontSize: 18)),
              DropdownButton(
                value: _dailygoal,
                items:
                    _dailygoaloption.map((int value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text('$value glasses'),
                      );
                    }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    _setdailygoal(newValue);
                  }
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  goalreached ? null : _increment_MyApp();
                },
                child: Text(
                  "Add a glass of water ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showresetconfirmation();
                },
                child: Text('Reset', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
