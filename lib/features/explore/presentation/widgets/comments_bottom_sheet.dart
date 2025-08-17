import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triptango/core/models/comment_model.dart';
import 'package:triptango/features/explore/presentation/providers/comments_provider.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String tripId;
  const CommentsBottomSheet({super.key, required this.tripId});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommentsProvider>(context, listen: false)
          .fetchComments(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommentsProvider(),
      child: Consumer<CommentsProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: provider.isLoading
                      ? _buildShimmerEffect()
                      : _buildCommentsList(provider.comments),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentsList(List<Comment> comments) {
    if (comments.isEmpty) {
      return const Center(
        child: Text('No comments yet.'),
      );
    }

    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.userProfilePic),
          ),
          title: Text(comment.userName),
          subtitle: Text(comment.comment),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
            ),
            title: Container(
              height: 16,
              width: 100,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 12,
              width: 200,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
