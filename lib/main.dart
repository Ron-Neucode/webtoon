import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final prefs = await SharedPreferences.getInstance();
  final String? lastUser = prefs.getString('loggedInUser');

  runApp(MyApp(loggedInUsername: lastUser));
}

class MyApp extends StatelessWidget {
  final String? loggedInUsername;

  const MyApp({super.key, this.loggedInUsername});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Webtoon App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Builder(
        builder: (context) {
          // Check if a user is logged in
          if (loggedInUsername != null && loggedInUsername!.isNotEmpty) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
