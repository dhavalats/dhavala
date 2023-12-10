
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _currentTheme = lightTheme; // Default theme is light mode

  void toggleTheme() {
    setState(() {
      _currentTheme = _currentTheme == lightTheme ? darkTheme : lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _currentTheme,
      home: HomeScreen(toggleTheme: toggleTheme, isDarkTheme: _currentTheme == darkTheme),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  // Define other theme properties for light mode
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.grey[900],
  // Define other theme properties for dark mode
);

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkTheme;

  HomeScreen({required this.toggleTheme, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Flow', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YourProfileScreen(
                      userName: "Sneha Bhat",
                      phoneNumber: "123-456-7890",
                      email: "sneha@example.com",
                      address: "123, Main St",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(toggleTheme: toggleTheme, isDarkTheme: isDarkTheme),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Set Goals', style: TextStyle(fontWeight: FontWeight.bold)),
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
            Image.network(
              'https://as1.ftcdn.net/v2/jpg/01/52/91/84/1000_F_152918465_SwoXcxG64OHi7ECEkkce1oswDtL4jcD1.jpg',
              width: 300, // Use full width of the screen
              height: 200, // Allow the height to adjust to maintain the aspect ratio
              fit: BoxFit.cover, // Adjust the fit as needed (e.g., cover, contain, etc.)
            ),
            SizedBox(height: 20),
            Text(
              'Focus on your Goals',
              style: TextStyle(
                color: const Color.fromARGB(245, 33, 149, 243),
                fontSize: 35,
                fontWeight: FontWeight.bold,
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

class SettingsScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkTheme;

  SettingsScreen({required this.toggleTheme, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Theme Settings',
              style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Switch(
              value: isDarkTheme, // Use the current theme to set the initial value
              onChanged: (value) {
                toggleTheme(); // Call the toggleTheme method to switch themes
              },
              activeTrackColor: Colors.white,
              activeColor: Colors.blue,
            ),
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
  final List<Goal> completedGoals = []; // List to store completed goals

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
        title: Text('Set Goals', style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: Text('Add Goal', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            Text(
              'Your Goals:',
              style: TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return GoalItem(goals[index], () {
                    setState(() {
                      goals[index].isDone = !goals[index].isDone;
                      if (goals[index].isDone) {
                        // Move the completed goal to the completedGoals list
                        completedGoals.add(goals[index]);
                        goals.removeAt(index);
                      }
                    });
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Completed Goals:',
              style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: completedGoals.length,
                itemBuilder: (context, index) {
                  return GoalItem(completedGoals[index], () {
                    setState(() {
                      completedGoals[index].isDone = !completedGoals[index].isDone;
                      if (!completedGoals[index].isDone) {
                        // Move the completed goal back to the goals list
                        goals.add(completedGoals[index]);
                        completedGoals.removeAt(index);
                      }
                    });
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Image.network(
              'https://tse1.mm.bing.net/th?id=OIP.mLbLIbEgrJGp1YV-FfojDgHaHa&pid=Api&P=0&h=220',
              width: 150, // Adjust the width as needed
              height:150, // Adjust the height as needed
             
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
          fontWeight: FontWeight.bold,
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
  Timer? _timer;

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
        _durationInSeconds = int.parse(_controller.text) * 60;
        _remainingTime = _durationInSeconds;
      });

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime <= 0) {
          timer.cancel();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Time\'s up!',
                  style: TextStyle(color: Color.fromARGB(194, 0, 208, 255), fontWeight: FontWeight.bold),
                ),
                content: Text('It is time to take a break!!'),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
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
    } else {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resumeTimer() {
    if (!_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime <= 0) {
          timer.cancel();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Time\'s up!',
                  style: TextStyle(color: Color.fromARGB(194, 0, 208, 255), fontWeight: FontWeight.bold),
                ),
                content: Text('It is time to take a break!!'),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
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
      setState(() {
        _isRunning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Set Timer Duration (minutes):',
          style: TextStyle(fontSize: 21, color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Enter minutes'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isRunning ? _pauseTimer : _startTimer,
          child: Text(_isRunning ? 'Pause Timer' : 'Start Timer', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 15),
        if (_isRunning)
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: _pauseTimer,
          )
        else
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: _resumeTimer,
          ),
        SizedBox(height: 15),
        Text(
          'Time Remaining: ${_remainingTime ~/ 60} min ${_remainingTime % 60} sec',
          style: TextStyle(fontSize: 21, color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}



class YourProfileScreen extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String email;
  final String address;

  YourProfileScreen({
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  @override
  _YourProfileScreenState createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends State<YourProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _phoneNumberController.text = widget.phoneNumber;
    _emailController.text = widget.email;
    _addressController.text = widget.address;
  }

  void _saveProfile() {
    // Save the updated profile information here
    String newName = _nameController.text;
    String newPhoneNumber = _phoneNumberController.text;
    String newEmail = _emailController.text;
    String newAddress = _addressController.text;

    // You can save the new name, phone number, email, and address to your database or storage here
    // Add your logic for saving the changes

    // Show a snackbar message to indicate that the profile has been updated
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://tse3.mm.bing.net/th?id=OIP.evVt32Vz1srnuF_cQ73kfAHaHa&pid=Api&P=0&h=220', // Replace with the actual image URL
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
              fit: BoxFit.cover, // Adjust the fit as needed (e.g., cover, contain, etc.)
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}