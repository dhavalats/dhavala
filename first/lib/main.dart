import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MaterialApp(
    home: ProductivityHarbor(),
  ));
}

class ProductivityHarbor extends StatefulWidget {
  @override
  _ProductivityHarborState createState() => _ProductivityHarborState();
}

class _ProductivityHarborState extends State<ProductivityHarbor> {
  bool isRunning = false;
  bool isWorking = true;
  int minutes = 25;
  int seconds = 0;
  int cycles = 4; // Default number of cycles
  int cycleCounter = 0;
  int breakDuration = 15; // Default duration for the long break
  late Timer timer;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isDarkMode = false;

  Future<void> initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        // Handle notification selection
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void showNotification(String title, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id', // Change this to your preferred channel ID
      'Your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (change as needed)
      title,
      message,
      platformChannelSpecifics,
    );
  }

  void startTimer() {
    if (!isRunning) {
      isRunning = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (minutes == 0 && seconds == 0) {
          isWorking = !isWorking;
          if (isWorking) {
            minutes = 25;
            cycleCounter++;
            showNotification('Work Session Complete', 'Time for a break!');
            if (cycleCounter >= cycles) {
              showNotification('Long Break Reminder', 'Take a $breakDuration-minute break.');
              cycleCounter = 0;
            }
          } else {
            minutes = isWorking ? 25 : 5;
            showNotification('Break Time Over', 'Time to work again!');
          }
        } else {
          if (seconds == 0) {
            minutes--;
            seconds = 59;
          } else {
            seconds--;
          }
        }
        setState(() {});
      });
    }
  }

  void stopTimer() {
    if (isRunning) {
      isRunning = false;
      timer?.cancel();
    }
  }

  // Function to display a time picker modal
  void showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 8, // 8 options: 25, 30, 35, 40, 45, 50, 55, and 60 minutes
          itemBuilder: (BuildContext context, int index) {
            final time = 25 + index * 5;
            return ListTile(
              title: Text('$time minutes'),
              onTap: () {
                // Set the selected time and close the modal
                setState(() {
                  minutes = time;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  // Function to display a cycle and long break settings modal
  void showCycleAndBreakSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text('Number of Cycles: $cycles'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    cycles++;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Long Break After: $breakDuration minutes'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    breakDuration += 5;
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    String timerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Productivity Harbor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              timerText,
              style: TextStyle(fontSize: 48),
            ),
            ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  stopTimer();
                } else {
                  startTimer();
                }
              },
              child: Text(isRunning ? 'Stop' : 'Start'),
            ),
            ElevatedButton(
              onPressed: () {
                showTimePicker(context);
              },
              child: Text('Change Time'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Your Name'),
              accountEmail: Text('your@email.com'),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                showCycleAndBreakSettings(context);
              },
            ),
            ListTile(
              leading: Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
              title: Text('Theme'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
