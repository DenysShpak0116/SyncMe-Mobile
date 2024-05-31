import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/user.dart';
import 'package:syncme/providers/likedposts_provider.dart';
import 'package:syncme/providers/posts_provider.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier(this.ref) : super(null);
  final databaseService = DatabaseService();
  final Ref ref;

  Future<bool> createNewUser(User user) async {
    final userId = await databaseService.insertNewUser(user);

    if (userId == -1) {
      return false;
    }

    user.userId = userId!;

    state = user;

    return true;
  }

  Future<bool> setUser(String email, String password) async {
    if (state != null && state!.email == email && state!.password == password) {
      await ref.read(postsProvider.notifier).loadPosts();
    await ref.read(likedPostsProvider.notifier).loadLikedPosts();
      return true;
    }

    final User? user = await databaseService.loginUser(email, password);

    if (user == null) {
      return false;
    }

    state = user;

    await ref.read(postsProvider.notifier).loadPosts();
    await ref.read(likedPostsProvider.notifier).loadLikedPosts();

    return true;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) => UserNotifier(ref),
);
