import 'package:flutter/material.dart';
import 'package:invitation/screen/dataundangan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 240, 240),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wedding Invitations'),
        leading: IconButton(
          onPressed: () {
            logout();
          },
          icon: const Icon(Icons.home),
        ),
        backgroundColor: const Color.fromARGB(255, 31, 163, 175),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromARGB(255, 31, 163, 175),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, "/");
              break;
            case 1:
              Navigator.pushNamed(context, "/undangan");
              break;
          }
        },
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
              label: 'Tambah Undangan'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            AppBar(
              centerTitle: true,
              title: const Text(
                'Data Undangan',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 31, 175, 163),
              automaticallyImplyLeading: false,
            ),
            const SizedBox(
              height: 550,
              child: IndexUndangan(),
            )
          ],
        ),
      ),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }
}
