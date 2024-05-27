import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/likedposts_provider.dart';
import 'package:syncme/providers/posts_provider.dart';
import 'package:syncme/screens/post.dart';
import 'package:syncme/widgets/post_item.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() {
    return _FeedScreenState();
  }
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  bool _isLoading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _loadPosts();
    super.initState();
  }

  Future<void> _loadPosts() async {
    await ref.read(postsProvider.notifier).loadPosts();
    await ref.read(likedPostsProvider.notifier).loadLikedPosts();

    setState(() {
      _isLoading = false;
    });
  }

  void _selectPost(BuildContext context, Post post) {
    final likedPosts = ref.read(likedPostsProvider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PostScreen(
          post: post,
          scrollingToComments: false,
          postImage: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(post.imgContent!),
            fit: BoxFit.cover,
          ),
          isLiked: likedPosts.where((post) => post.postId == post.postId).isNotEmpty,
        ),
      ),
    );
  }

  void _selectPostWithScrolling(BuildContext context, Post post) {
    final likedPosts = ref.read(likedPostsProvider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PostScreen(
          post: post,
          scrollingToComments: true,
          postImage: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(post.imgContent!),
            fit: BoxFit.cover,
          ),
          isLiked: likedPosts.where((post) => post.postId == post.postId).isNotEmpty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    final likedPosts = ref.watch(likedPostsProvider);

    Widget content = const Center(
      child: Text('No posts from your groups yet.'),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (posts.isNotEmpty) {
      content = ListView.builder(
        itemCount: posts.length,
        itemBuilder: (ctx, index) => PostItem(
          post: posts[index],
          postImage: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(posts[index].imgContent!),
            fit: BoxFit.cover,
          ),
          onSelectPost: () {
            _selectPost(context, posts[index]);
          },
          onSelectPostWithScrolling: () {
            _selectPostWithScrolling(context, posts[index]);
          },
          isLiked: likedPosts.where((post) => post.postId == posts[index].postId).isNotEmpty,
        ),
      );
    }

    return content;
  }
}
