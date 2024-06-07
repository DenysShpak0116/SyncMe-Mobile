import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/post.dart';
import 'package:intl/intl.dart';
import 'package:syncme/providers/likedposts_provider.dart';

final DateFormat formatter = DateFormat('d/M/y');

class PostItem extends ConsumerStatefulWidget {
  const PostItem({
    required this.onSelectPostWithScrolling,
    required this.onSelectPost,
    required this.post,
    required this.postImage,
    super.key,
  });
  final Post post;
  final Widget? postImage;
  final Future<bool?> Function() onSelectPost;
  final Future<bool?> Function() onSelectPostWithScrolling;

  @override
  ConsumerState<PostItem> createState() {
    return _PostItemState();
  }
}

class _PostItemState extends ConsumerState<PostItem> {
  bool _isLiked = false;

  void _like() {
    if (!_isLiked) {
      setState(() {
        _isLiked = !_isLiked;
        widget.post.countOfLikes++;
      });
      ref.read(likedPostsProvider.notifier).likePost(widget.post);
    } else {
      setState(() {
        _isLiked = !_isLiked;
        widget.post.countOfLikes--;
      });
      ref.read(likedPostsProvider.notifier).removeLikeFromPost(widget.post);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLiked = ref
        .watch(likedPostsProvider)
        .where((post) => post.postId == widget.post.postId)
        .isNotEmpty;

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
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.post.emotionalAnalysis!.emotionalState}%',
                        style: const TextStyle(
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
                        formatter.format(widget.post.date),
                        style: const TextStyle(
                          color: Color(0xFFB28ECC),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Image.asset(
                        'assets/images/x.png',
                        width: 16.0,
                        height: 16.0,
                        color: const Color(0xFFB28ECC),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () async {
                  bool? isLiked = await widget.onSelectPost();
                  if (isLiked != null) {
                    setState(() {
                      _isLiked = isLiked;
                    });
                  }
                },
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _like,
                    icon: const Icon(Icons.add),
                    color: _isLiked
                        ? const Color.fromARGB(255, 194, 33, 119)
                        : const Color(0xFFD3B3E9),
                  ),
                  Text(
                    widget.post.countOfLikes.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD3B3E9),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      bool? isLiked = await widget.onSelectPostWithScrolling();
                      if (isLiked != null) {
                        setState(() {
                          _isLiked = isLiked;
                        });
                      }
                    },
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
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
