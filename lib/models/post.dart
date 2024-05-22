class Post {
  Post({
    required this.postId,
    required this.imgContent,
    required this.videoContent,
    required this.date,
    required this.countOfLikes,
    required this.authorId,
    required this.emotionalAnalysId,
  });

  final String postId;
  final String imgContent;
  final String videoContent;
  final DateTime date;
  final String countOfLikes;
  final String authorId;
  final String emotionalAnalysId;
}
