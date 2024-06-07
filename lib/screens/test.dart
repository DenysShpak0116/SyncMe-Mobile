import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/post.dart';
import 'package:intl/intl.dart';
import 'package:syncme/providers/likedposts_provider.dart';
import 'package:syncme/providers/posts_provider.dart';
import 'package:transparent_image/transparent_image.dart';

final DateFormat formatter = DateFormat('d/M/y');

class PostItem extends ConsumerStatefulWidget {
  const PostItem({
    super.key,
  });

  @override
  ConsumerState<PostItem> createState() {
    return _PostItemState();
  }
}

class _PostItemState extends ConsumerState<PostItem> {
  bool _isLiked = false;
  late Post post;
  @override
  void initState() {
    super.initState();
    List<Post> posts = ref.read(postsProvider);
    post = posts.first;
  }

  void _like() {
    if (!_isLiked) {
      setState(
        () {
          _isLiked = !_isLiked;
          post.countOfLikes++;
        },
      );
      ref.read(likedPostsProvider.notifier).likePost(post);
    } else {
      setState(
        () {
          _isLiked = !_isLiked;
          post.countOfLikes--;
        },
      );
      ref.read(likedPostsProvider.notifier).removeLikeFromPost(post);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLiked = ref
        .watch(likedPostsProvider)
        .where((post) => post.postId == post.postId)
        .isNotEmpty;

    Widget content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 94, 59, 118),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post.author.authorImage),
                    ),
                    title: Text(
                      post.author.username,
                      style: const TextStyle(
                        color: Color(0xFFB28ECC),
                      ),
                    ),
                    subtitle: Text(
                      'from • ${post.author.group.name}',
                      style: const TextStyle(color: Color(0xFFB28ECC)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${post.emotionalAnalysis!.emotionalState}%',
                        style: const TextStyle(
                          color: Color(0xFFB28ECC),
                        ),
                      ),
                      const Icon(
                        size: 20,
                        Icons.emoji_emotions,
                        color: Color(0xFFB28ECC),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        formatter.format(
                          post.date,
                        ),
                        style: const TextStyle(
                          color: Color(0xFFB28ECC),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Image.asset(
                        'assets/images/x.png',
                        width: 16.0,
                        height: 16.0,
                        color: const Color(0xFFB28ECC),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () async {},
                child: Column(
                  children: [
                    Text(
                      post.textContent,
                      maxLines: 3,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD3B3E9),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    if (post.imgContent != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: NetworkImage(post.imgContent!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (post.imgContent != null)
                      const SizedBox(
                        height: 5,
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _like,
                    icon: const Icon(Icons.add),
                    color: _isLiked
                        ? const Color.fromARGB(255, 194, 33, 119)
                        : const Color(0xFFD3B3E9),
                  ),
                  Text(
                    post.countOfLikes.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD3B3E9),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {},
                    child: const Text(
                      'View all comments',
                      style: TextStyle(
                        color: Color(0xFFD3B3E9),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.repeat),
                    color: const Color(0xFFD3B3E9),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );

    if (false) {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 94, 59, 118),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(post.author.authorImage),
                      ),
                      title: Text(
                        post.author.username,
                        style: const TextStyle(
                          color: Color(0xFFB28ECC),
                        ),
                      ),
                      subtitle: Text(
                        'from • ${post.author.group.name}',
                        style: const TextStyle(color: Color(0xFFB28ECC)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${post.emotionalAnalysis!.emotionalState}%',
                            style: const TextStyle(
                              color: Color(0xFFB28ECC),
                            ),
                          ),
                          const Icon(
                            size: 20,
                            Icons.emoji_emotions,
                            color: Color(0xFFB28ECC),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            formatter.format(
                              post.date,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFB28ECC),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),

                          Image.asset(
                            'assets/images/x.png',
                            width: 16.0,
                            height: 16.0,
                            color: const Color(0xFFB28ECC),
                          ),
                          // const Icon(
                          //   IconData(
                          //     0xf0586,
                          //     fontFamily: 'MaterialIcons',
                          //   ),
                          //   color: Color(0xff744E8E),
                          // ),
                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.more_vert,
                          //     color: Color(0xff744E8E),
                          //   ),
                          //   onPressed: () {},
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () async {},
                  child: Expanded(
                    child: Column(
                      children: [
                        Text(
                          post.textContent,
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFD3B3E9),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        if (post.imgContent != null)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: FadeInImage(
                                placeholder: MemoryImage(kTransparentImage),
                                image: NetworkImage(post.imgContent!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (post.imgContent != null)
                          const SizedBox(
                            height: 5,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: _like,
                        icon: const Icon(Icons.add),
                        color: _isLiked
                            ? const Color.fromARGB(255, 194, 33, 119)
                            : const Color(0xFFD3B3E9)),
                    Text(
                      post.countOfLikes.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD3B3E9),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {},
                      child: const Text(
                        'View all comments',
                        style: TextStyle(
                          color: Color(0xFFD3B3E9),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.repeat),
                      color: const Color(0xFFD3B3E9),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              )
            ],
          ),
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
    );
  }
}
