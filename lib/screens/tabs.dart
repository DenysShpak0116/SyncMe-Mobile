import 'package:flutter/material.dart';
import 'package:syncme/screens/feed.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF281A33),
        title: SizedBox(
          width: 80,
          child: Image.asset(
            'assets/images/SyncMe.png',
            color: const Color(0xFF794D98),
          ),
        ),
      ),
      body: const FeedScreen(),
    );
  }
}
