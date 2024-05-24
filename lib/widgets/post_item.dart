import 'package:flutter/material.dart';
import 'package:syncme/models/post.dart';

class PostItem extends StatefulWidget {
  const PostItem({required this.post, super.key});
  final Post post;

  @override
  State<PostItem> createState() {
    return _PostItemState();
  }
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 121,77,152),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.post.author.authorBackgroundImage),
            ),
            title: Text(
              'Mikio Ikemoto',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'from • Famous manga',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: Icon(
              Icons.more_horiz,
              color: Colors.white70,
            ),
          ),
          Stack(
            children: [
              Image.asset(
                'assets/image.png', // Make sure to add the image to your assets
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      SizedBox(width: 4),
                      Text('75%', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Write a comment...',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
