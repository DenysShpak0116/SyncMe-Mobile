import 'package:mysql1/mysql1.dart';
import 'package:syncme/models/author.dart';
import 'package:syncme/models/comment.dart';
import 'package:syncme/models/emotional_analysis.dart';
import 'package:syncme/models/group.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseService {
  MySqlConnection? _connection;

  final String host = dotenv.env['DB_HOST']!;
  final int port = int.parse(dotenv.env['DB_PORT']!);
  final String database = dotenv.env['DB_DATABASE']!;
  final String username = dotenv.env['DB_USERNAME']!;
  final String password = dotenv.env['DB_PASSWORD']!;

  Future<void> connect() async {
    _connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: host,
        port: port,
        user: username,
        db: database,
        password: password,
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
    List<Author> loadedAuthors = [];
    var postsResults = await _connection!.query('select * from syncme.post');

    for (var postRow in postsResults) {
      if (loadedAuthors
          .where((element) => element.authorId == postRow[4])
          .isEmpty) {
        var authorResult = await _connection!.query(
            'select * from syncme.author where syncme.author.AuthorId = ${postRow[4]}');
        ResultRow authorRow = authorResult.toList()[0];

        var groupResult = await _connection!.query(
            'select * from syncme.group where syncme.group.GroupId = ${authorRow[5]}');
        ResultRow groupRow = groupResult.toList()[0];

        EmotionalAnalysis? eaGroup;
        if (groupRow[4] != null) {
          var eaResult = await _connection!.query(
              'select * from syncme.emotionalanalysis where syncme.emotionalanalysis.EmotionalAnalysisId = ${groupRow[4]}');
          ResultRow eaRow = eaResult.toList()[0];
          eaGroup = EmotionalAnalysis(
              emotionalAnalysisId: eaRow[0],
              emotionalState: eaRow[1],
              emotionalIcon: eaRow[2]);
        }

        Group group = Group(
          groupId: groupRow[0],
          name: groupRow[1],
          groupImage: groupRow[2],
          groundBackgroundImage: groupRow[3],
          emotionalAnalysis: eaGroup,
        );

        EmotionalAnalysis? eaAuthor;
        if (authorRow[6] != null) {
          var eaResult = await _connection!.query(
              'select * from syncme.emotionalanalysis where syncme.emotionalanalysis.EmotionalAnalysisId = ${authorRow[6]}');
          ResultRow eaRow = eaResult.toList()[0];
          eaAuthor = EmotionalAnalysis(
              emotionalAnalysisId: eaRow[0],
              emotionalState: eaRow[1],
              emotionalIcon: eaRow[2]);
        }

        Author author = Author(
          authorId: authorRow[0],
          name: authorRow[1],
          socialMedia: authorRow[2],
          authorImage: authorRow[3],
          authorBackgroundImage: authorRow[4],
          group: group,
          emotionalAnalysis: eaAuthor,
          username: authorRow[7],
        );
        loadedAuthors.add(author);
      }

      EmotionalAnalysis? eaPost;
      if (postRow[5] != null) {
        var eaResult = await _connection!.query(
            'select * from syncme.emotionalanalysis where syncme.emotionalanalysis.EmotionalAnalysisId = ${postRow[5]}');
        ResultRow eaRow = eaResult.toList()[0];
        eaPost = EmotionalAnalysis(
            emotionalAnalysisId: eaRow[0],
            emotionalState: eaRow[1],
            emotionalIcon: eaRow[2]);
      }

      String? imgContent;
      var imgResult = await _connection!.query(
          'select * from syncme.xphoto where syncme.xphoto.PostId = ${postRow[0]}');
      imgContent = imgResult.toList().isEmpty ? null : imgResult.toList()[0][1];

      Post post = Post(
        postId: postRow[0],
        textContent: postRow[1].toString(),
        imgContent: imgContent,
        videoContent: null,
        date: postRow[2],
        countOfLikes: postRow[3],
        author: loadedAuthors
          .firstWhere((element) => element.authorId == postRow[4]),
        emotionalAnalysis: eaPost,
      );
      loadedPosts.add(post);
    }
    return loadedPosts;
  }

  Future<List<Post>> loadLikedPosts(User user) async {
    if (_connection == null) {
      await connect();
    }
    List<Post> loadedPosts = [];
    List<Author> loadedAuthors = [];

    var postsResults = await _connection!.query(
        'select syncme.post.PostId, TextContent, Date, CountOfLikes, AuthorId, EmotionalAnalysisId from syncme.post, syncme.user, syncme.userlikedpost where syncme.user.UserId = syncme.userlikedpost.UserId and syncme.user.UserId = ? and syncme.post.PostId = syncme.userlikedpost.PostId',
        [user.userId]);

    for (var postRow in postsResults) {
      if (loadedAuthors
          .where((element) => element.authorId == postRow[4])
          .isEmpty) {
        var authorResult = await _connection!.query(
            'select * from syncme.author where syncme.author.AuthorId = ${postRow[4]}');
        ResultRow authorRow = authorResult.toList()[0];

        var groupResult = await _connection!.query(
            'select * from syncme.group where syncme.group.GroupId = ${authorRow[5]}');
        ResultRow groupRow = groupResult.toList()[0];

        EmotionalAnalysis? eaGroup;
        if (groupRow[4] != null) {
          var eaResult = await _connection!.query(
              'select * from syncme.emotionalanalysis where syncme.emotionalanalysis.EmotionalAnalysisId = ${groupRow[4]}');
          ResultRow eaRow = eaResult.toList()[0];
          eaGroup = EmotionalAnalysis(
              emotionalAnalysisId: eaRow[0],
              emotionalState: eaRow[1],
              emotionalIcon: eaRow[2]);
        }

        Group group = Group(
          groupId: groupRow[0],
          name: groupRow[1],
          groupImage: groupRow[2],
          groundBackgroundImage: groupRow[3],
          emotionalAnalysis: eaGroup,
        );

        EmotionalAnalysis? eaAuthor;
        if (authorRow[6] != null) {
          var eaResult = await _connection!.query(
              'select * from syncme.emotionalanalysis where syncme.emotionalanalysis.EmotionalAnalysisId = ${authorRow[6]}');
          ResultRow eaRow = eaResult.toList()[0];
          eaAuthor = EmotionalAnalysis(
              emotionalAnalysisId: eaRow[0],
              emotionalState: eaRow[1],
              emotionalIcon: eaRow[2]);
        }

        Author author = Author(
          authorId: authorRow[0],
          name: authorRow[1],
          socialMedia: authorRow[2],
          authorImage: authorRow[3],
          authorBackgroundImage: authorRow[4],
          group: group,
          emotionalAnalysis: eaAuthor,
          username: authorRow[7],
        );
        loadedAuthors.add(author);
      }

      EmotionalAnalysis? eaPost;
      if (postRow[5] != null) {
        var eaResult = await _connection!.query(
            'select * from syncme.emotionalanalysis where syncme.emotionalanalysis.EmotionalAnalysisId = ${postRow[5]}');
        ResultRow eaRow = eaResult.toList()[0];
        eaPost = EmotionalAnalysis(
            emotionalAnalysisId: eaRow[0],
            emotionalState: eaRow[1],
            emotionalIcon: eaRow[2]);
      }

      String? imgContent;
      var imgResult = await _connection!.query(
          'select * from syncme.xphoto where syncme.xphoto.PostId = ${postRow[0]}');
      imgContent = imgResult.toList().isEmpty ? null : imgResult.toList()[0][1];

      Post post = Post(
        postId: postRow[0],
        textContent: postRow[1].toString(),
        imgContent: imgContent,
        videoContent: null,
        date: postRow[2],
        countOfLikes: postRow[3],
        author: loadedAuthors
          .firstWhere((element) => element.authorId == postRow[4]),
        emotionalAnalysis: eaPost,
      );
      loadedPosts.add(post);
    }
    return loadedPosts;
  }

  void likePost(Post post, User user) async {
    if (_connection == null) {
      await connect();
    }
    await _connection!.query(
        'update syncme.post set syncme.post.CountOfLikes = syncme.post.CountOfLikes + 1 where syncme.post.PostId = ${post.postId}');
    await _connection!.query(
      'INSERT INTO syncme.userlikedpost (PostId, UserId) values (?, ?)',
      [
        post.postId,
        user.userId,
      ],
    );
  }

  void removeLikeFromPost(Post post, User user) async {
    if (_connection == null) {
      await connect();
    }
    await _connection!.query(
        'update syncme.post set syncme.post.CountOfLikes = syncme.post.CountOfLikes - 1 where syncme.post.PostId = ${post.postId}');
    await _connection!.query(
      'delete from syncme.userlikedpost where PostId = ? and UserId = ?',
      [
        post.postId,
        user.userId,
      ],
    );
  }

  Future<List<Comment>> loadComments(Post post) async {
    if (_connection == null) {
      await connect();
    }
    List<Comment> loadedComments = [];

    var commentsResults = await _connection!.query(
        'select * from syncme.comment where syncme.comment.PostId = ${post.postId} order by syncme.comment.Date desc');

    for (var commentRow in commentsResults) {
      var userResult = await _connection!.query(
          'select * from syncme.user where syncme.user.UserId = ${commentRow[3]}');
      ResultRow userRow = userResult.toList()[0];

      User user = User(
        userId: userRow[0],
        username: userRow[1],
        password: userRow[2],
        email: userRow[3],
        firstName: userRow[4],
        lastName: userRow[5],
        sex: userRow[6],
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

  Future<int?> insertNewUser(User user) async {
    if (_connection == null) {
      await connect();
    }

    var result = await _connection!.query(
        'select * from syncme.user where syncme.user.Email = ? or syncme.user.Username = ?',
        [user.email, user.username]);

    if (result.toList().isNotEmpty) {
      return -1;
    }

    var insertResult = await _connection!.query(
        'INSERT INTO syncme.user (Username, Password, Email, FirstName, LastName, Sex, Country, Role) values (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          user.username,
          user.password,
          user.email,
          user.firstName,
          user.lastName,
          user.sex,
          user.country,
          user.role,
        ]);

    return insertResult.insertId;
  }

  Future<User?> getUserByEmail(String email) async {
    if (_connection == null) {
      await connect();
    }

    var result = await _connection!.query(
        'select * from syncme.user where syncme.user.Email = ?', [email]);

    if (result.toList().isEmpty) {
      return null;
    }

    return User(
      userId: result.first[0],
      username: result.first[1],
      password: result.first[2],
      email: result.first[3],
      firstName: result.first[4],
      lastName: result.first[5],
      sex: result.first[6],
      country: result.first[7],
      role: result.first[8],
    );
  }

  Future<int> insertNewComment(Comment comment) async {
    if (_connection == null) {
      await connect();
    }

    var utcDate = comment.date.toUtc();
    utcDate = utcDate.add(const Duration(hours: 3));

    var insertResult = await _connection!.query(
        'INSERT INTO syncme.comment (Text, Date, UserId, PostId) values (?, ?, ?, ?)',
        [
          comment.text,
          utcDate,
          comment.user.userId,
          comment.post.postId,
        ]);

    return insertResult.insertId!;
  }
}
