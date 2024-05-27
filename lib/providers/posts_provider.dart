import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/post.dart';

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier(this.ref) : super([]) {
    loadPosts();
  }

  final Ref ref;
  final databaseService = DatabaseService();

  Future<void> loadPosts() async {
    final posts = await databaseService.loadPosts();
    state = posts;
  }
}

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>(
  (ref) => PostsNotifier(ref),
);
