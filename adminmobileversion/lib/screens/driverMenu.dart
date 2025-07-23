import 'package:adminmobileversion/screens/accounts.dart';
import 'package:adminmobileversion/screens/callForm.dart';
import 'package:adminmobileversion/screens/currentWork.dart';
import 'package:adminmobileversion/screens/data.dart';
import 'package:adminmobileversion/screens/home.dart';
import 'package:adminmobileversion/screens/system.dart';
import 'package:adminmobileversion/screens/web.dart';
import 'package:flutter/material.dart';

int? exclusiveVar;
int? _selectedIndex = 0;
void main() {
  runApp(MyApp());
}

var global1;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DriverScreen(global1),
    );
  }
}

class DriverScreen extends StatefulWidget {

  void refreshWeb(int exclusiveVar2){
    exclusiveVar = exclusiveVar2;
    if(exclusiveVar != null && exclusiveVar == 1){
      _selectedIndex = exclusiveVar;
    }
  }
  DriverScreen(final passValue) {
    global1 = passValue;
    print(global1);
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DriverScreen> {
  


  final List<Widget> _screens = [
    DriverCurrentWork(global1),
    CompletedEvents(global1),
    AttractiveForm(global1),
    ProfilePage(global1),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex!],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 5, 30, 54),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex!,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedIndex == 0
                    ? Colors.blueAccent.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.home, size: 28),
            ),
            label: 'Current Work',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedIndex == 1
                    ? Colors.blueAccent.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history, size: 28),
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedIndex == 2
                    ? Colors.blueAccent.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone, size: 28),
            ),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedIndex == 3
                    ? Colors.blueAccent.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.settings, size: 28),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
