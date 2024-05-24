import 'package:syncme/models/author.dart';
import 'package:syncme/models/emotional_analysis.dart';

class Post {
  Post({
    required this.postId,
    required this.textContent,
    required this.imgContent,
    required this.videoContent,
    required this.date,
    required this.countOfLikes,
    required this.author,
    required this.emotionalAnalysis,
  });

  final int postId;
  final String textContent;
  final String? imgContent;
  final String? videoContent;
  final DateTime date;
  int countOfLikes;
  final Author author;
  final EmotionalAnalysis? emotionalAnalysis;
}
