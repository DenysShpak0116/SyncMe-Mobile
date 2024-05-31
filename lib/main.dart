import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/screens/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyncMe',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF432B55),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 67, 43, 85),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF281A33),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
