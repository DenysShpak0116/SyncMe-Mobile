import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/comment.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/likedposts_provider.dart';
import 'package:syncme/widgets/comment_item.dart';
import 'package:syncme/widgets/post_item.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({
    required this.postImage,
    required this.scrollingToComments,
    required this.post,
    super.key,
  });
  final Post post;
  final bool scrollingToComments;
  final Widget? postImage;

  @override
  ConsumerState<PostScreen> createState() {
    return _PostScreenState();
  }
}

class _PostScreenState extends ConsumerState<PostScreen> {
  final databaseService = DatabaseService();
  bool _isLiked = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();

  List<Comment> _comments = [];
  bool _isCommentsLoading = true;

  @override
  void initState() {
    _loadComments();
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
      ref.read(likedPostsProvider.notifier).likePost(widget.post);
    } else {
      setState(
        () {
          _isLiked = !_isLiked;
          widget.post.countOfLikes--;
        },
      );
      ref.read(likedPostsProvider.notifier).removeLikeFromPost(widget.post);
    }
  }

  Future<void> _loadComments() async {
    List<Comment> loadedComments =
        await databaseService.loadComments(widget.post);
    setState(() {
      _comments = loadedComments;
      _isCommentsLoading = false;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    _isLiked = ref
        .watch(likedPostsProvider)
        .where((post) => post.postId == widget.post.postId)
        .isNotEmpty;

    Widget commentsContent = const Center(
      child: Text('No comments yet.'),
    );

    if (_isCommentsLoading) {
      commentsContent = const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    }

    if (!_isCommentsLoading && _comments.isNotEmpty) {
      commentsContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            _comments.map((comment) => CommentItem(comment: comment)).toList(),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        Navigator.of(context).pop<bool?>(
          _isLiked,
        );
      },
      child: Scaffold(
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
                          fontWeight: FontWeight.w800,
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
              SizedBox(
                height: 4,
                key: _targetKey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
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
              commentsContent,
            ],
          ),
        ),
      ),
    );
  }
}
