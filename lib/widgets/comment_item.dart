import 'package:flutter/material.dart';
import 'package:syncme/models/comment.dart';
import 'package:intl/intl.dart';

final DateFormat formatterForComments = DateFormat('H:m d/M/y');

class CommentItem extends StatelessWidget {
  const CommentItem({required this.comment, required this.onReply, super.key});
  final Comment comment;
  final void Function() onReply;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.user.logo),
          ),
          title: Text(
            '@${comment.user.username}',
            style: const TextStyle(
              color: Color(0xFFB28ECC),
            ),
          ),
          subtitle: Text(
            'at • ${formatterForComments.format(comment.date)}',
            style: const TextStyle(color: Color(0xFFB28ECC)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            comment.text,
            style: const TextStyle(
              color: Color(0xFFD3B3E9),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onReply,
                icon: const Icon(
                  Icons.reply,
                  color: Color(0xFFD3B3E9),
                ),
                label: const Text(
                  'Reply',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD3B3E9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
