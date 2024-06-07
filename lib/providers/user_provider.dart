import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/user.dart';
import 'package:syncme/providers/likedposts_provider.dart';
import 'package:syncme/providers/posts_provider.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter/foundation.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier(this.ref) : super(null);
  final databaseService = DatabaseService();
  final Ref ref;

  Future<bool> createNewUser(User user) async {
    try {
      user.password = await hashPassword(user.password);

      final userId = await databaseService.insertNewUser(user);

      if (userId == -1) {
        return false;
      }

      user.userId = userId!;

      state = user;

      return true;
    } catch (e) {
      debugPrint('Error creating new user: $e');
      return false;
    }
  }

  Future<bool> setUser(String email, String password) async {
    try {
      final User? user = await databaseService.getUserByEmail(email);

      if (user == null) {
        return false;
      }

      if (!await checkPassword(password, user.password)) {
        return false;
      }

      state = user;

      await ref.read(postsProvider.notifier).loadPosts();
      await ref.read(likedPostsProvider.notifier).loadLikedPosts();

      return true;
    } catch (e) {
      debugPrint('Error setting user: $e');
      return false;
    }
  }

  Future<String> hashPassword(String password) async {
    final salt = await FlutterBcrypt.saltWithRounds(rounds: 14);
    final hashedPassword =
        await FlutterBcrypt.hashPw(password: password, salt: salt);
    return hashedPassword;
  }

  Future<bool> checkPassword(String password, String hashedPassword) async {
    final result = await FlutterBcrypt.verify(
      password: password,
      hash: hashedPassword,
    );
    return result;
  }

  Future<void> setLogo(String logo) async {
    state!.logo = logo;
    databaseService.updateLogo(state!, logo);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) => UserNotifier(ref),
);
