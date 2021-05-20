import 'package:client/screens/home.dart';
import 'package:client/screens/visits.dart';
import 'package:client/screens/alerts.dart';
import 'package:client/screens/documents.dart';
import 'package:client/screens/reports.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    HomePage(),
    ReportsPage(),
    DocumentsPage(),
    VisitsPage(),
    AlertsPage(),
  ];

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_photo_rounded),
            label: 'Visits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Alerts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
      ),
    );
  }
}
