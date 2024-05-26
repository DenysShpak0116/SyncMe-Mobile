import 'package:flutter/material.dart';
import 'package:syncme/models/comment.dart';
import 'package:syncme/widgets/post_item.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({required this.comment, super.key});
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://pbs.twimg.com/profile_images/994592419705274369/RLplF55e_400x400.jpg'),
          ),
          title: Text(
            comment.user.username,
            style: const TextStyle(
              color: Color(0xFFB28ECC),
            ),
          ),
          subtitle: Text(
            'at • ${formatter.format(comment.date)}',
            style: const TextStyle(color: Color(0xFFB28ECC)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            comment.text,
            style: const TextStyle(
              color: Color(0xFFD3B3E9),
            ),
          ),
        ),
      ],
    );
  }
}
