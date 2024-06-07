import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/comment.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/comments_provider.dart';
import 'package:syncme/providers/likedposts_provider.dart';
import 'package:syncme/widgets/comment_item.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('d/M/y');

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
  bool _isLiked = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();
  final _commentController = TextEditingController();

  bool _isCommentsLoading = true;
  bool _isCommentLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadComments();
    super.initState();
  }

  Future<void> _loadComments() async {
    await ref.read(commentsProvider(widget.post).notifier).loadComments();

    setState(() {
      _isCommentsLoading = false;
    });

    if (widget.scrollingToComments) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final RenderBox? renderBox =
              _targetKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final position = renderBox.localToGlobal(Offset.zero).dy;
            final offsetPosition = _scrollController.position.pixels +
                position -
                kToolbarHeight * 2;

            if (offsetPosition > _scrollController.position.maxScrollExtent) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            } else {
              _scrollController.animateTo(
                offsetPosition,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            }
          }
        },
      );
    }
  }

  void _like() {
    setState(
      () {
        _isLiked = !_isLiked;
        if (_isLiked) {
          widget.post.countOfLikes++;
          ref.read(likedPostsProvider.notifier).likePost(widget.post);
        } else {
          widget.post.countOfLikes--;
          ref.read(likedPostsProvider.notifier).removeLikeFromPost(widget.post);
        }
      },
    );
  }

  void _comment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _isCommentLoading = true;
    });

    await ref
        .read(commentsProvider(widget.post).notifier)
        .comment(_commentController.text.trim());
    setState(() {
      _commentController.clear();
      _isCommentLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isLiked = ref
        .watch(likedPostsProvider)
        .where((post) => post.postId == widget.post.postId)
        .isNotEmpty;

    List<Comment> comments = ref.watch(commentsProvider(widget.post));

    Widget commentsContent = const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          'No comments yet.',
          style: TextStyle(
            color: Color(0xFFB28ECC),
            fontSize: 20,
          ),
        ),
      ),
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

    if (!_isCommentsLoading && comments.isNotEmpty) {
      commentsContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments
            .map((comment) => CommentItem(
                  comment: comment,
                  onReply: () {
                    setState(() {
                      _commentController.text = '@${comment.user.username}, ';
                    });
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        final RenderBox? renderBox = _targetKey.currentContext
                            ?.findRenderObject() as RenderBox?;
                        if (renderBox != null) {
                          final position =
                              renderBox.localToGlobal(Offset.zero).dy;
                          final offsetPosition =
                              _scrollController.position.pixels +
                                  position -
                                  kToolbarHeight * 2;

                          if (offsetPosition >
                              _scrollController.position.maxScrollExtent) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          } else {
                            _scrollController.animateTo(
                              offsetPosition,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      },
                    );
                  },
                ))
            .toList(),
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
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.post.emotionalAnalysis?.emotionalState ?? 'N/A'}%',
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
                          width: 18.0,
                          height: 18.0,
                          color: const Color(0xFFB28ECC),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      height: 12,
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
              Padding(
                key: _targetKey,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: _commentController,
                            cursorColor: const Color.fromARGB(255, 94, 59, 118),
                            style: const TextStyle(
                              color: Color(0xFFD3B3E9),
                            ),
                            decoration: const InputDecoration(
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
                      icon: _isCommentLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Color(0xFF794D98),
                            ),
                      onPressed: _isCommentLoading ? null : _comment,
                    ),
                  ],
                ),
              ),
              commentsContent,
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
