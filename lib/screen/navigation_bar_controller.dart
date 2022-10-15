// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'home.dart';

class BottomNavigationBarController extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  final List<Widget> pages = [
    const Home(
      key: PageStorageKey('/'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        /*
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, "");
              break;
            case 1:
              Navigator.pushNamed(context, "/calendar");
              break;
          }
        },
        */
        currentIndex: selectedIndex,
        backgroundColor: const Color(0xffaf1f24),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded, color: Colors.white),
              label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag_circle_outlined), label: 'Report')
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        // ignore: sort_child_properties_last
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
