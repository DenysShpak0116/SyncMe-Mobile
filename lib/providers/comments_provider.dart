import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/comment.dart';
import 'package:syncme/models/post.dart';

class CommentsNotifier extends StateNotifier<List<Comment>> {
  CommentsNotifier({required this.post}) : super([]);
  final databaseService = DatabaseService();
  final Post post;

  Future<void> loadComments() async {
    final comments = await databaseService.loadComments(post);
    state = comments;
  }
}

final commentsProvider =
    StateNotifierProvider.family<CommentsNotifier, List<Comment>, Post>(
  (ref, post) => CommentsNotifier(post: post),
);