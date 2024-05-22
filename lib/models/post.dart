import 'package:syncme/models/author.dart';
import 'package:syncme/models/emotional_analysis.dart';

class Post {
  Post({
    required this.postId,
    required this.imgContent,
    required this.videoContent,
    required this.date,
    required this.countOfLikes,
    required this.author,
    required this.emotionalAnalysis,
  });

  final String postId;
  final String imgContent;
  final String videoContent;
  final DateTime date;
  final String countOfLikes;
  final Author author;
  final EmotionalAnalysis emotionalAnalysis;
}
