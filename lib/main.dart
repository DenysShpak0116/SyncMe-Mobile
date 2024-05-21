import 'package:flutter/material.dart';
import 'package:syncme/screens/auth.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyncMe',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 67, 43, 85),
        ),
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          bodySmall:const  TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          bodyMedium:const  TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          bodyLarge:const  TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          labelMedium: const  TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          labelSmall: const  TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          displaySmall: const  TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          displayMedium: const  TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
