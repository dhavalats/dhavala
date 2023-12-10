import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Flow'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Focus Flow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Your Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YourProfileScreen(userName: "Sneha Bhat"), // Replace with the user's name
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Set Goals'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => GoalScreen()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Focus on your Goals',
              style: TextStyle(
                color: const Color.fromARGB(245, 33, 149, 243),
                fontSize: 35,
              ),
            ),
            SizedBox(height: 20),
            AlarmTimer(),
          ],
        ),
      ),
    );
  }
}

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final List<Goal> goals = [];

  TextEditingController _goalController = TextEditingController();

  void _addGoal() {
    if (_goalController.text.isNotEmpty) {
      setState(() {
        goals.add(Goal(_goalController.text));
        _goalController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: 'Enter your goal'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addGoal,
              child: Text('Add Goal'),
            ),
            SizedBox(height: 20),
            Text(
              'Your Goals:',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return GoalItem(goals[index], () {
                    setState(() {
                      goals[index].isDone = !goals[index].isDone;
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }
}

class Goal {
  String text;
  bool isDone;

  Goal(this.text, {this.isDone = false});
}

class GoalItem extends StatelessWidget {
  final Goal goal;
  final VoidCallback onCheckboxChanged;

  GoalItem(this.goal, this.onCheckboxChanged);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        goal.text,
        style: TextStyle(
          decoration: goal.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: goal.isDone,
        onChanged: (value) {
          onCheckboxChanged();
        },
      ),
    );
  }
}

class AlarmTimer extends StatefulWidget {
  @override
  _AlarmTimerState createState() => _AlarmTimerState();
}

class _AlarmTimerState extends State<AlarmTimer> {
  int _durationInSeconds = 0;
  int _remainingTime = 0;
  bool _isRunning = false;
  TextEditingController _controller = TextEditingController();

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
        _durationInSeconds = int.parse(_controller.text) * 60;
        _remainingTime = _durationInSeconds;
      });

      Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime <= 0) {
          timer.cancel();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Time\'s up!'),
                content: Text('It\'s time to focus on your goals.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
          setState(() {
            _isRunning = false;
          });
        } else {
          setState(() {
            _remainingTime--;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Set Timer Duration (minutes):',
          style: TextStyle(fontSize: 18),
        ),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Enter minutes'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _startTimer,
          child: Text(_isRunning ? 'Running...' : 'Start Timer'),
        ),
        SizedBox(height: 10),
        Text(
          'Time Remaining: ${_remainingTime ~/ 60} min ${_remainingTime % 60} sec',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class YourProfileScreen extends StatelessWidget {
  final String userName;

  YourProfileScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              // You can use an avatar to display the user's profile picture if available
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User Name: $userName',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}