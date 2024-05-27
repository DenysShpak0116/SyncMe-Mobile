import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);
  final databaseService = DatabaseService();

  Future<bool> createNewUser(User user) async {
    final userId = await databaseService.insertNewUser(user);

    if (userId == -1) {
      return false;
    }

    user.userId = userId!;

    databaseService.close();

    return true;
  }

  Future<bool> setUser(String email, String password) async {
    final User? user = await databaseService.loginUser(email, password);

    if (user == null) {
      return false;
    }

    state = user;
    
    databaseService.close();

    return true;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) => UserNotifier(),
);
