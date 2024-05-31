import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/posts_provider.dart';
import 'package:syncme/screens/post.dart';
import 'package:syncme/widgets/post_item.dart';
import 'package:transparent_image/transparent_image.dart';

class Feed extends ConsumerStatefulWidget {
  const Feed({super.key});

  @override
  ConsumerState<Feed> createState() {
    return _FeedScreenState();
  }
}

class _FeedScreenState extends ConsumerState<Feed> {

  Future<bool?> _selectPost(BuildContext context, Post post) async {
    bool? isPostWasLiked = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (ctx) => PostScreen(
          post: post,
          scrollingToComments: false,
          postImage: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(post.imgContent!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    return isPostWasLiked;
  }

  Future<bool?> _selectPostWithScrolling(BuildContext context, Post post) async {
    bool? isPostWasLiked = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (ctx) => PostScreen(
          post: post,
          scrollingToComments: true,
          postImage: FadeInImage(
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
    final posts = ref.watch(postsProvider);

    Widget content = const Center(
      child: Text('No posts from your groups yet.'),
    );

    if (posts.isNotEmpty) {
      content = ListView.builder(
        itemCount: posts.length,
        itemBuilder: (ctx, index) => PostItem(
            post: posts[index],
            postImage: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(posts[index].imgContent!),
              fit: BoxFit.cover,
            ),
            onSelectPost: ()  {
              return _selectPost(context, posts[index]);
            },
            onSelectPostWithScrolling: () {
              return _selectPostWithScrolling(context, posts[index]);
            }),
      );
    }

    return content;
  }
}
