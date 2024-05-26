import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Future<bool> createNewUser(User user) async {
    final databaseService = DatabaseService();
    final userId = await databaseService.insertNewUser(user);

    if (userId == -1) {
      return false;
    }

    user.userId = userId!;

    state = user;

    return true;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) => UserNotifier(),
);
