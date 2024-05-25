import 'package:flutter/material.dart';
import 'package:syncme/models/post.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({required this.post,super.key});
  final Post post;

  @override
  State<PostScreen> createState() {
    return _PostScreenState();
  }
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 80,
          child: Image.asset(
            'assets/images/SyncMe.png',
            color: const Color(0xFF794D98),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 94, 59, 118),
    );
  }
}
