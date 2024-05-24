import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:syncme/models/author.dart';
import 'package:syncme/models/group.dart';
import 'package:syncme/models/post.dart';
import 'dart:convert';

import 'package:syncme/widgets/post_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() {
    return _FeedScreenState();
  }
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    List<Post> loadedPosts = [];

    final conn = await MySqlConnection.connect(
      ConnectionSettings(
          host: 'syncme.mysql.database.azure.com',
          port: 3306,
          user: 'SyncMeAdmin',
          db: 'syncme',
          password: 'Smad_mysql123'),
    );
    var postsResults = await conn.query('select * from syncme.post');

    for (var postRow in postsResults) {
      var authorResult = await conn.query(
          'select * from syncme.author where syncme.author.AuthorId = ${postRow[6]}');
      ResultRow authorRow = authorResult.toList()[0];

      var groupResult = await conn.query(
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

    setState(() {
      _posts = loadedPosts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No posts from your groups yet.'),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_posts.isNotEmpty) {
      content = ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (ctx, index) => PostItem(
          post: _posts[index],
        ),
      );
    }

    return Scaffold(
      body: content,
    );
  }
}
