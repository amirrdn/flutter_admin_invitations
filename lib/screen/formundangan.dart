import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class Undangan extends StatefulWidget {
  const Undangan({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UndanganState();
  }
}

class _UndanganState extends State<Undangan> {
  final int _currentIndex = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 240, 240),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wedding Invitations'),
        leading: IconButton(
          onPressed: () {},
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
            onPressed: () {},
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                      hintText: "name",
                      labelText: "Nama Lengkap",
                      icon: Icon(Icons.people)),
                  validator: (emailValue) {
                    if (emailValue!.isEmpty) {
                      return 'Please enter your email';
                    }
                    name = emailValue;
                    return null;
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _insertData();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _insertData() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'name': name};
    final prefs = await SharedPreferences.getInstance();
    var istoken = prefs.getString('access_token');
    var map = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $istoken',
    };
    final Uri restApiUrl = Uri.parse(
        "http://back-end.e-procurement.abdi.co.id/api/insert-invitations");

    // ignore: unused_local_variable

    http.Response response = await http.post(
      restApiUrl,
      headers: map,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load ');
    }
  }
}
