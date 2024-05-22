import 'package:syncme/models/emotional_analysis.dart';
import 'package:syncme/models/group.dart';

class Author {
  Author({
    required this.authorId,
    required this.name,
    required this.socialMedia,
    required this.authorImage,
    required this.authorBackgroundImage,
    required this.group,
    required this.emotionalAnalysis,
  });

  final String authorId;
  final String name;
  final String socialMedia;
  final String authorImage;
  final String authorBackgroundImage;
  final Group group;
  final EmotionalAnalysis emotionalAnalysis;
}
