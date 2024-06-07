import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/author.dart';
import 'package:syncme/models/group.dart';
import 'package:syncme/models/user.dart';
import 'package:syncme/providers/user_provider.dart';
import 'package:syncme/screens/auth.dart';
import 'package:syncme/screens/group.dart';
import 'package:syncme/screens/settings.dart';
import 'package:syncme/widgets/tabs_drawer.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/posts_provider.dart';
import 'package:syncme/screens/post.dart';
import 'package:syncme/widgets/post_item.dart';
import 'package:transparent_image/transparent_image.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'settings') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const SettingsScreen(),
        ),
      );
    }
    if (identifier == 'auth') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const AuthScreen(),
        ),
      );
    }
  }

  Future<bool?> _selectPost(BuildContext context, Post post) async {
    bool? isPostWasLiked = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (ctx) => PostScreen(
          post: post,
          scrollingToComments: false,
          postImage: post.imgContent == null
              ? null
              : FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(post.imgContent!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
    return isPostWasLiked;
  }

  void _selectGroup(BuildContext context, Group group, List<Author> authors) {
    authors = authors.getRange(0, 4).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (ctx) => GroupScreen(group: group, authors: authors)),
    );
  }

  Future<bool?> _selectPostWithScrolling(
      BuildContext context, Post post) async {
    bool? isPostWasLiked = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (ctx) => PostScreen(
          post: post,
          scrollingToComments: true,
          postImage: post.imgContent == null
              ? null
              : FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(post.imgContent!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
    return isPostWasLiked;
  }

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider)!;

    final posts = ref.watch(postsProvider);

    Widget content = const Center(
      child: Text('No posts from your groups yet.'),
    );

    if (posts.isNotEmpty) {
      content = ListView.builder(
        itemCount: posts.length,
        itemBuilder: (ctx, index) => PostItem(
          post: posts[index],
          postImage: posts[index].imgContent == null
              ? null
              : FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(posts[index].imgContent!),
                  fit: BoxFit.cover,
                ),
          onSelectPost: () {
            return _selectPost(context, posts[index]);
          },
          onSelectPostWithScrolling: () {
            return _selectPostWithScrolling(context, posts[index]);
          },
          selectGroup: _selectGroup,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 80,
          child: Image.asset(
            'assets/images/SyncMe.png',
            color: const Color(0xFF794D98),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF794D98),
        ),
      ),
      body: content,
      drawer: TabsDrawer(
        onSelectScreen: _setScreen,
        user: user,
      ),
    );
  }
}
