import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(WebtoonApp());
}

class WebtoonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webtoon System',
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginScreen(),
    );
  }
}
