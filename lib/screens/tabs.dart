import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/user.dart';
import 'package:syncme/providers/user_provider.dart';
import 'package:syncme/screens/settings.dart';
import 'package:syncme/widgets/feed.dart';
import 'package:syncme/widgets/tabs_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'settings') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const SettingsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 80,
          child: Image.asset(
            'assets/images/SyncMe.png',
            color: const Color(0xFF794D98),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF794D98),
        ),
      ),
      body: const Feed(),
      drawer: TabsDrawer(
        onSelectScreen: _setScreen,
        user: user,
      ),
    );
  }
}
