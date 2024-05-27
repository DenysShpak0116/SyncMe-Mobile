import 'package:flutter/material.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/post.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('d/M/y');

class PostItem extends StatefulWidget {
  const PostItem({
    required this.onSelectPostWithScrolling,
    required this.onSelectPost,
    required this.post,
    required this.postImage,
    required this.isLiked,
    super.key,
  });
  final Post post;
  final Widget? postImage;
  final bool isLiked;
  final void Function() onSelectPost;
  final void Function() onSelectPostWithScrolling;

  @override
  State<PostItem> createState() {
    return _PostItemState();
  }
}

class _PostItemState extends State<PostItem> {
  bool _isLiked = false;
  final databaseService = DatabaseService();

  @override
  void initState() {
    _isLiked = widget.isLiked;
    super.initState();
  }

  @override
  void dispose() {
    databaseService.close();
    super.dispose();
  }

  void _like() {
    if (!_isLiked) {
      setState(
        () {
          _isLiked = !_isLiked;
          widget.post.countOfLikes++;
        },
      );
      databaseService.likePost(widget.post);
    } else {
      setState(
        () {
          _isLiked = !_isLiked;
          widget.post.countOfLikes--;
        },
      );
      databaseService.removeLikeFromPost(widget.post);
    }
  }

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
                      style: const TextStyle(color: Color(0xFFB28ECC)),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Text(
                        '75%',
                        style: TextStyle(
                          color: Color(0xFFB28ECC),
                        ),
                      ),
                      const Icon(
                        size: 20,
                        Icons.emoji_emotions,
                        color: Color(0xFFB28ECC),
                      ),
                      const SizedBox(
                        width: 4,
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
                        width: 4,
                      ),
                      const Icon(
                        IconData(
                          0xf0586,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: Color(0xff744E8E),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Color(0xff744E8E),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: widget.onSelectPost,
                child: Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.post.textContent,
                        maxLines: 3,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD3B3E9),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      if (widget.post.imgContent != null)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: widget.postImage,
                          ),
                        ),
                      if (widget.post.imgContent != null)
                        const SizedBox(
                          height: 5,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                      onPressed: _like,
                      icon: const Icon(Icons.add),
                      color: _isLiked
                          ? const Color.fromARGB(255, 194, 33, 119)
                          : const Color(0xFFD3B3E9)),
                  Text(
                    widget.post.countOfLikes.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD3B3E9),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onSelectPostWithScrolling,
                    child: const Text(
                      'View all comments',
                      style: TextStyle(
                        color: Color(0xFFD3B3E9),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.repeat),
                    color: const Color(0xFFD3B3E9),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            )
          ],
        ),
      ),
    );
  }
}
