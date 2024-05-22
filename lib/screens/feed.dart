import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() {
    return _FeedState();
  }
}

class _FeedState extends State<Feed> {
  int i = 0;

  void _connectDB() async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
          host: 'syncme.mysql.database.azure.com',
          port: 3306,
          user: 'SyncMeAdmin',
          db: 'syncme',
          password: 'Smad_mysql123'),
    );
    var results = await conn.query(
      'select PostText, PostImg, Date from syncme.notification where syncme.notification.NotificationId = ?',
      ['1'],
    );
    for (var row in results) {
      print('PostText: ${row[0]}, PostImg: ${row[1]} Data: ${row[2]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              i++;
              _connectDB();
            });
          },
          child: Text(i.toString()),
        ),
      ),
    );
  }
}
