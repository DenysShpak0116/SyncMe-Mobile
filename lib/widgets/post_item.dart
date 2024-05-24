import 'package:flutter/material.dart';
import 'package:syncme/models/post.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat.yMMMd();

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 94, 59, 118),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.post.author.authorImage),
                    ),
                    title: Text(
                      widget.post.author.username,
                      style: const TextStyle(
                        color: Color(0xFFB28ECC),
                      ),
                    ),
                    subtitle: Text(
                      'from • ${widget.post.author.group.name}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '75%',
                        style: const TextStyle(
                          color: Color(0xFFB28ECC),
                        ),
                      ),
                      const Icon(Icons.emoji_emotions,color: Color(0xFFB28ECC),),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        formatter.format(
                          widget.post.date,
                        ),
                        style: const TextStyle(
                          color: Color(0xFFB28ECC),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Icon(
                        IconData(
                          0xf0586,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: Color(0xff744E8E),
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Color(0xff744E8E),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.post.textContent,
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFD3B3E9)),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            if (widget.post.imgContent != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(widget.post.imgContent!),
                ),
              ),
            if (widget.post.imgContent != null)
              const SizedBox(
                height: 5,
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
      ),
    );
  }
}
