import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/user_provider.dart';

class LikedPostsNotifier extends StateNotifier<List<Post>> {
  LikedPostsNotifier(this.ref) : super([]) {
    loadLikedPosts();
  }

  final Ref ref;
  final databaseService = DatabaseService();

  Future<void> loadLikedPosts() async {
    final user = ref.read(userProvider);

    if (user != null) {
      final likedPosts = await databaseService.loadLikedPosts(user);
      state = likedPosts;
    }
  }
}

final likedPostsProvider = StateNotifierProvider<LikedPostsNotifier, List<Post>>(
  (ref) => LikedPostsNotifier(ref),
);
