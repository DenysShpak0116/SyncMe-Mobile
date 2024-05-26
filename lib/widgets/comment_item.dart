import 'package:flutter/material.dart';
import 'package:syncme/models/comment.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({required this.comment, super.key});
  final Comment comment;

  @override
  State<CommentItem> createState() {
    return _CommentItemState();
  }
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.comment.text,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
