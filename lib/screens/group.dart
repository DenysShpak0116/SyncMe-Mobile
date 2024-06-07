import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/author.dart';
import 'package:syncme/models/emotional_analysis.dart';
import 'package:syncme/models/group.dart';
import 'package:syncme/models/post.dart';
import 'package:syncme/providers/posts_provider.dart';
import 'package:syncme/screens/post.dart';
import 'package:syncme/widgets/post_item.dart';
import 'package:transparent_image/transparent_image.dart';

class GroupScreen extends ConsumerStatefulWidget {
  const GroupScreen({required this.group, required this.authors, super.key});
  final Group group;
  final List<Author> authors;

  @override
  ConsumerState<GroupScreen> createState() {
    return _GroupScreenState();
  }
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  bool _isGroupFollowed = false;

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

  void _selectGroup(BuildContext context, Group group, List<Author> authors) {
    authors = authors.getRange(0, 4).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (ctx) => GroupScreen(group: group, authors: authors)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref
        .watch(postsProvider)
        .where((post) => post.author.group.groupId == widget.group.groupId)
        .toList();

    Widget content = ListView.builder(
      itemCount: posts.length + 1,
      itemBuilder: (ctx, index) => index == 0
          ? Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.group.groundBackgroundImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.group.groupImage),
                            radius: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.group.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD3B3E9),
                                ),
                              ),
                              Text(
                                widget.group.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFD3B3E9),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 94, 59, 118)),
                                onPressed: () {
                                  setState(() {
                                    _isGroupFollowed = !_isGroupFollowed;
                                  });
                                },
                                child: _isGroupFollowed
                                    ? Text(
                                        'Follow the group',
                                        style: TextStyle(
                                          color: Color(0xFFB28ECC),
                                        ),
                                      )
                                    : Text(
                                        'Unfollow the group',
                                        style: TextStyle(
                                          color: Color(0xFFB28ECC),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 6 / 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        children: [
                          for (final author in widget.authors)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFD3B3E9), width: 2),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      author.authorBackgroundImage),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.9),
                                    BlendMode.dstATop,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(author.authorImage),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    author.name.length > 10
                                        ? '${author.name.substring(0, 10)}...'
                                        : author.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                      color: Color.fromARGB(255, 234, 212, 249),
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 40.0,
                                          color: Colors.black.withOpacity(0.8),
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : PostItem(
              post: posts[index - 1],
              postImage: posts[index - 1].imgContent == null
                  ? null
                  : FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(posts[index - 1].imgContent!),
                      fit: BoxFit.cover,
                    ),
              onSelectPost: () {
                return _selectPost(context, posts[index - 1]);
              },
              onSelectPostWithScrolling: () {
                return _selectPostWithScrolling(context, posts[index - 1]);
              },
              selectGroup: _selectGroup,
            ),
    );
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
