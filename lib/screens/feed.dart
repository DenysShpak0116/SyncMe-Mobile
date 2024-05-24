import 'package:flutter/material.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/widgets/post_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() {
    return _FeedScreenState();
  }
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  final databaseService = DatabaseService();

  @override
  void dispose() {
    databaseService.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    List<Post> loadedPosts = await databaseService.loadPosts();
    setState(() {
      _posts = loadedPosts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No posts from your groups yet.'),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_posts.isNotEmpty) {
      content = ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (ctx, index) => PostItem(
          post: _posts[index],
        ),
      );
    }

    return content;
  }
}
