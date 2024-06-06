import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/database/database_service.dart';
import 'package:syncme/models/comment.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/user_provider.dart';

class CommentsNotifier extends StateNotifier<List<Comment>> {
  CommentsNotifier({required this.ref, required this.post}) : super([]);
  final databaseService = DatabaseService();
  final Post post;
  final Ref ref;

  Future<void> loadComments() async {
    final comments = await databaseService.loadComments(post);
    state = comments;
  }

  Future<void> comment(String commentText) async {
    Comment comment = Comment(
        commentId: -1,
        text: commentText,
        date: DateTime.now(),
        user: ref.read(userProvider)!,
        post: post);

    comment.commentId = await databaseService.insertNewComment(comment);
    state.insert(0, comment);
  }

  // Future<void> commentByIndex(String commentText, int index) async {
  //   Comment comment = Comment(
  //       commentId: -1,
  //       text: commentText,
  //       date: DateTime.now(),
  //       user: ref.read(userProvider)!,
  //       post: post);

  //   comment.commentId = await databaseService.insertNewComment(comment);
  //   state.insert(index + 1, comment);
  // }
}

final commentsProvider =
    StateNotifierProvider.family<CommentsNotifier, List<Comment>, Post>(
  (ref, post) => CommentsNotifier(ref: ref, post: post),
);
