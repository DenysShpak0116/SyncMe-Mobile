import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/providers/user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
  });
  @override
  ConsumerState<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<String> avatarUrls = [
    'https://i.imgur.com/w6nyLDf.png',
    'https://static-00.iconduck.com/assets.00/reddit-icon-icon-1024x1024-7oj6whxq.png',
    'https://1000logos.net/wp-content/uploads/2017/02/Facebook-Logosu.png',
    'https://static.vecteezy.com/system/resources/previews/022/811/328/large_2x/cute-cat-kitty-animal-character-epitome-avatar-mascot-portrait-free-photo.jpeg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Anonymous_emblem.svg/1200px-Anonymous_emblem.svg.png',
    'https://t4.ftcdn.net/jpg/05/66/63/19/360_F_566631993_wTzG2ryyNj6gbvdwfYEVxQNCDcwz0ba7.jpg',
    'https://ysc.nure.ua/wp-content/uploads/2023/05/Logo_nure.png',
    'https://st4.depositphotos.com/10839834/22313/v/450/depositphotos_223139856-stock-illustration-emblem-kharkiv-city-ukraine-vector.jpg',
    'https://w7.pngwing.com/pngs/107/901/png-transparent-coat-of-arms-of-ukraine-brand-trident-line-text-logo-alex.png',
  ];

  void _openAvatarSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 94, 59, 118),
          title: const Center(
            child: Text(
              'Select an Avatar',
              style: TextStyle(
                color: Color(0xFFB28ECC),
              ),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: avatarUrls.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      ref
                          .read(userProvider.notifier)
                          .setLogo(avatarUrls[index]);
                    });
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrls[index]),
                    radius: 30,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF794D98),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF794D98),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => _openAvatarSelection(context),
          child: CircleAvatar(
            backgroundImage: NetworkImage(ref.watch(userProvider)!.logo),
            radius: 80,
          ),
        ),
      ),
    );
  }
}
