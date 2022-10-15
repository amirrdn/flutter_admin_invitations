import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/login.dart';
import 'screen/home.dart';
import 'screen/formundangan.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final isLoggedIn = (prefs.getBool('isLoggedIn') == null)
      ? false
      : prefs.getBool('isLoggedIn');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: isLoggedIn ? const SampleApp() : const Login(),
    home: isLoggedIn == true ? const SampleApp() : const Login(),
  ));
}

class SampleApp extends StatelessWidget {
  const SampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar Demo',
      home: const Home(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const Home(),
        '/login': (BuildContext context) => const Login(),
        '/undangan': (BuildContext context) => const Undangan(),
      },
    );
  }
}
