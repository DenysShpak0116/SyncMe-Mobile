import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/widgets/post_item.dart';
import 'package:transparent_image/transparent_image.dart';

class PostScreen extends StatefulWidget {
  const PostScreen(
      {required this.scrollingToComments, required this.post, super.key});
  final Post post;
  final bool scrollingToComments;

  @override
  State<PostScreen> createState() {
    return _PostScreenState();
  }
}

class _PostScreenState extends State<PostScreen> {
  bool _isLiked = false;
  final databaseService = DatabaseService();
  
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();

  @override
  void initState() {
    if (widget.scrollingToComments) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final RenderBox renderBox =
              _targetKey.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero).dy;

          _scrollController.animateTo(
            position - kToolbarHeight * 2,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        },
      );
    }

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF794D98),
        ),
        title: SizedBox(
          width: 80,
          child: Image.asset(
            'assets/images/SyncMe.png',
            color: const Color(0xFF794D98),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 94, 59, 118),
      body: SingleChildScrollView(
        controller: _scrollController,
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
              child: Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.post.textContent,
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
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: NetworkImage(widget.post.imgContent!),
                            fit: BoxFit.cover,
                          ),
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
                          : const Color(0xFFD3B3E9)),
                  Text(
                    widget.post.countOfLikes.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD3B3E9),
                    ),
                  ),
                  const Spacer(),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      key: _targetKey,
                      decoration: BoxDecoration(
                        color: const Color(0xFF794D98),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          cursorColor: Color.fromARGB(255, 94, 59, 118),
                          style: TextStyle(
                            color: Color(0xFFD3B3E9),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            hintStyle: TextStyle(
                              color: Color(0xFFD3B3E9),
                            ),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFF794D98),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Text(
              widget.post.textContent,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFFD3B3E9),
              ),
            ),
            Text(
              widget.post.textContent,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFFD3B3E9),
              ),
            ),
            Text(
              widget.post.textContent,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFFD3B3E9),
              ),
            ),
            Text(
              widget.post.textContent,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFFD3B3E9),
              ),
            ),
            Text(
              widget.post.textContent,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFFD3B3E9),
              ),
            ),
            Text(
              widget.post.textContent,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFFD3B3E9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
