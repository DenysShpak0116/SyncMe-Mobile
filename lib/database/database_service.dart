import 'package:mysql1/mysql1.dart';
import 'package:syncme/models/author.dart';
import 'package:syncme/models/comment.dart';
import 'package:syncme/models/group.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/models/user.dart';

class DatabaseService {
  MySqlConnection? _connection;

  Future<void> connect() async {
    _connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: 'syncme.mysql.database.azure.com',
        port: 3306,
        user: 'SyncMeAdmin',
        db: 'syncme',
        password: 'Smad_mysql123',
      ),
    );
  }

  MySqlConnection? get connection => _connection;

  Future<void> close() async {
    await _connection?.close();
  }

  Future<List<Post>> loadPosts() async {
    if (_connection == null) {
      await connect();
    }
    List<Post> loadedPosts = [];
    var postsResults = await _connection!.query('select * from syncme.post');

    for (var postRow in postsResults) {
      var authorResult = await _connection!.query(
          'select * from syncme.author where syncme.author.AuthorId = ${postRow[6]}');
      ResultRow authorRow = authorResult.toList()[0];

      var groupResult = await _connection!.query(
          'select * from syncme.group where syncme.group.GroupId = ${authorRow[5]}');
      ResultRow groupRow = groupResult.toList()[0];

      Group group = Group(
        groupId: groupRow[0],
        name: groupRow[1],
        groupImage: groupRow[2],
        groundBackgroundImage: groupRow[3],
        emotionalAnalysis: groupRow[4],
      );

      Author author = Author(
        authorId: authorRow[0],
        name: authorRow[1],
        socialMedia: authorRow[2],
        authorImage: authorRow[3],
        authorBackgroundImage: authorRow[4],
        group: group,
        emotionalAnalysis: authorRow[6],
        username: authorRow[7],
      );
      Post post = Post(
        postId: postRow[0],
        textContent: postRow[1].toString(),
        imgContent: postRow[2],
        videoContent: postRow[3],
        date: postRow[4],
        countOfLikes: postRow[5],
        author: author,
        emotionalAnalysis: postRow[7],
      );
      loadedPosts.add(post);
    }
    return loadedPosts;
  }

  void likePost(Post post) async {
    if (_connection == null) {
      await connect();
    }
    await _connection!.query(
        'update syncme.post set syncme.post.CountOfLikes = syncme.post.CountOfLikes + 1 where syncme.post.PostId = ${post.postId}');
  }

  void removeLikeFromPost(Post post) async {
    if (_connection == null) {
      await connect();
    }
    await _connection!.query(
        'update syncme.post set syncme.post.CountOfLikes = syncme.post.CountOfLikes - 1 where syncme.post.PostId = ${post.postId}');
  }

  Future<List<Comment>> loadComments(Post post) async {
    if (_connection == null) {
      await connect();
    }
    List<Comment> loadedComments = [];

    var commentsResults = await _connection!.query(
        'select * from syncme.comment where syncme.comment.PostId = ${post.postId}');

    for (var commentRow in commentsResults) {
      var userResult = await _connection!.query(
          'select * from syncme.user where syncme.user.UserId = ${commentRow[3]}');
      ResultRow userRow = userResult.toList()[0];

      Sex userSex = Sex.male;
      if (userRow[6] == 'Female') {
        userSex = Sex.female;
      }
      if (userRow[6] == 'Other') {
        userSex = Sex.other;
      }
      User user = User(
        userId: userRow[0],
        username: userRow[1],
        password: userRow[2],
        email: userRow[3],
        firstName: userRow[4],
        lastName: userRow[5],
        sex: userSex,
        country: userRow[7],
        role: userRow[8],
      );

      Comment comment = Comment(
        commentId: commentRow[0],
        text: commentRow[1].toString(),
        date: commentRow[2],
        user: user,
        post: post,
      );
      loadedComments.add(comment);
    }

    return loadedComments;
  }

  Future<Results> executeQuery(String query, [List<Object?>? values]) async {
    if (_connection == null) {
      await connect();
    }
    return await _connection!.query(query, values);
  }
}
