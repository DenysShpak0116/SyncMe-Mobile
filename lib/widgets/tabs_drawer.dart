import 'package:flutter/material.dart';
import 'package:syncme/models/user.dart';

class TabsDrawer extends StatelessWidget {
  const TabsDrawer({
    super.key,
    required this.user,
    required this.onSelectScreen,
  });
  final User user;
  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF432B55),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF281A33),
                  Color(0xFF794D98),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.logo),
                radius: 40,
              ),
              const SizedBox(width: 18),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@${user.username}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: const Color(0xFFB28ECC),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    user.role,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color(0xFFB28ECC),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ]),
          ),
          ListTile(
            leading: const Icon(
              Icons.list_alt_outlined,
              size: 26,
              color: Color(0xFFB28ECC),
            ),
            title: Text(
              'Feed',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color(0xFFB28ECC),
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('feed');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              size: 26,
              color: Color(0xFFB28ECC),
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color(0xFFB28ECC),
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('settings');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 26,
              color: Color(0xFFB28ECC),
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color(0xFFB28ECC),
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('auth');
            },
          ),
        ],
      ),
    );
  }
}
