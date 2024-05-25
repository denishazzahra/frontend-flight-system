import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/colors.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SharedPreferences storage = await SharedPreferences.getInstance();
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final SharedPreferences storage;
  const MyApp({super.key, required this.storage});
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = storage.containsKey('token') ? true : false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: whiteColor,
        ),
      ),
      home: isLoggedIn ? const HomePage(index: 0) : const LoginPage(),
    );
  }
}
