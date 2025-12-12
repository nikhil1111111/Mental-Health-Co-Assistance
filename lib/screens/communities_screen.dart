import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import '../main.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  String selectedCommunity = 'General';

  @override
  void initState() {
    super.initState();
    if (isFirebaseSupported) {
      Provider.of<PostProvider>(context, listen: false).loadPosts(selectedCommunity);
    }
  }

  void onCommunityChanged(String? community) {
    if (community != null) {
      setState(() {
        selectedCommunity = community;
      });
      if (isFirebaseSupported) {
        Provider.of<PostProvider>(context, listen: false).loadPosts(community);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirebaseSupported) {
      return const Center(
        child: Text('Communities feature not available on this platform'),
      );
    }
    final posts = Provider.of<PostProvider>(context).posts;

    return Column(
      children: [
        DropdownButton<String>(
          value: selectedCommunity,
          items: <String>['General', 'Plumbing', 'Electrician', 'Carpentry', 'Cleaning']
              .map((community) => DropdownMenuItem(
                    value: community,
                    child: Text(community),
                  ))
              .toList(),
          onChanged: onCommunityChanged,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          ),
        ),
      ],
    );
  }
}
