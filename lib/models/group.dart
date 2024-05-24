import 'package:syncme/models/emotional_analysis.dart';

class Group {
  Group({
    required this.groupId,
    required this.name,
    required this.groupImage,
    required this.groundBackgroundImage,
    required this.emotionalAnalysis,
  });

  final String groupId;
  final String name;
  final String groupImage;
  final String groundBackgroundImage;
  final EmotionalAnalysis? emotionalAnalysis;
}
