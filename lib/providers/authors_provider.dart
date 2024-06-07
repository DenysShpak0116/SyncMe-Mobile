import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/author.dart';
import 'package:syncme/models/group.dart';

class AuthorsNotifier extends StateNotifier<List<Author>> {
  AuthorsNotifier({required this.group}) : super([]) {
    loadAuthors();
  }

  final Group group;
  final databaseService = DatabaseService();

  Future<void> loadAuthors() async {
    final authors = await databaseService.loadAuthors(group);
    state = authors;
  }
}

final authorsProvider =
    StateNotifierProvider.family<AuthorsNotifier, List<Author>, Group>(
  (ref, group) => AuthorsNotifier(group: group),
);
