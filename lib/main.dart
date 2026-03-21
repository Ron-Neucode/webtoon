import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/webtoon_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => WebtoonProvider()..fetchWebtoons(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MangaVerse',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: Builder(
              builder: (context) {
                if (loggedInUsername != null && loggedInUsername!.isNotEmpty) {
                  return const DashboardScreen();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'ComicNeue',
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ).copyWith(
          primaryContainer: const Color(0xFF9C27B0),
          secondaryContainer: const Color(0xFFE1BEE7),
        ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF9C27B0),
      unselectedItemColor: Colors.grey,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'ComicNeue',
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ).copyWith(
          primaryContainer: const Color(0xFFBA68C8),
          secondaryContainer: const Color(0xFF4A148C),
        ),
    cardTheme: CardThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFFBA68C8),
      unselectedItemColor: Colors.grey,
    ),
  );
}
