import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PostItemState();
  }
}

class _PostItemState extends State<PostItem> {
  Widget content = const Column();

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
