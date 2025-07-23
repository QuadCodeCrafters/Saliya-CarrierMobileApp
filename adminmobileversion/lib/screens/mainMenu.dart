import 'package:adminmobileversion/screens/accounts.dart';
import 'package:adminmobileversion/screens/data.dart';
import 'package:adminmobileversion/screens/home.dart';
import 'package:adminmobileversion/screens/system.dart';
import 'package:adminmobileversion/screens/web.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    //CompletedEvents(),
    StatsPage(),
    HistoryPage(),
    //ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
     backgroundColor: Color.fromARGB(255, 0, 21, 41),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,  // Enable labels for selected items
        showUnselectedLabels: true, // Enable labels for unselected items
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _selectedIndex == 0 ? 50 : 24,
              height: _selectedIndex == 0 ? 50 : 24,
              decoration: BoxDecoration(
                color: _selectedIndex == 0
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.home),
            ),
            label: 'Home',  // Text label
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _selectedIndex == 1 ? 50 : 24,
              height: _selectedIndex == 1 ? 50 : 24,
              decoration: BoxDecoration(
                color: _selectedIndex == 1
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.web),
            ),
            label: 'Web',  // Text label
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _selectedIndex == 2 ? 50 : 24,
              height: _selectedIndex == 2 ? 50 : 24,
              decoration: BoxDecoration(
                color: _selectedIndex == 2
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.data_usage_rounded),
            ),
            label: 'Data',  // Text label
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _selectedIndex == 3 ? 50 : 24,
              height: _selectedIndex == 3 ? 50 : 24,
              decoration: BoxDecoration(
                color: _selectedIndex == 3
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.desktop_windows_rounded),
            ),
            label: 'System',  // Text label
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _selectedIndex == 4 ? 50 : 24,
              height: _selectedIndex == 4 ? 50 : 24,
              decoration: BoxDecoration(
                color: _selectedIndex == 4
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person),
            ),
            label: 'Accounts',  // Text label
          ),
        ],
      ),
    );
  }
}










