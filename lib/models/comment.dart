import 'package:syncme/models/post.dart';
import 'package:syncme/models/user.dart';

class Comment {
  Comment({
    required this.commentId,
    required this.text,
    required this.date,
    required this.user,
    required this.post,
  });
  int commentId;
  final String text;
  final DateTime date;
  final User user;
  final Post post;
}
