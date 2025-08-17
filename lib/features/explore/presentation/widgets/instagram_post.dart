import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/core/utils/date_formatter.dart';
import 'package:triptango/features/explore/presentation/providers/like_provider.dart';
import 'package:triptango/features/explore/presentation/widgets/comments_bottom_sheet.dart';

class InstagramPost extends StatefulWidget {
  final dynamic trip;
  const InstagramPost({super.key, required this.trip});

  @override
  State<InstagramPost> createState() => _InstagramPostState();
}

class _InstagramPostState extends State<InstagramPost> {
  bool _showHeart = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LikeProvider(isLiked: widget.trip.isLiked),
      child: Consumer<LikeProvider>(
        builder: (context, likeProvider, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      // Profile Picture
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            widget.trip.coverImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, size: 20),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Username and Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.trip.creatorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (widget.trip.location != null)
                              Text(
                                widget.trip.location,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // More Options
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
          // Post Image
          GestureDetector(
            onDoubleTap: () {
              likeProvider.toggleLike(widget.trip.id.toString());
              setState(() {
                _showHeart = true;
              });
              Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  _showHeart = false;
                });
              });
            },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.network(
                          widget.trip.coverImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 50),
                              ),
                            );
                          },
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _showHeart ? 1.0 : 0.0,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    children: [
                IconButton(
                  icon: Icon(
                    likeProvider.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: likeProvider.isLiked ? Colors.red : Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    likeProvider.toggleLike(widget.trip.id.toString());
                  },
                ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, size: 24),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => CommentsBottomSheet(tripId: widget.trip.id.toString()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_outlined, size: 24),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border, size: 24),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                // Likes Count
                if (widget.trip.likesCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${widget.trip.likesCount} likes',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                
                // Caption
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${widget.trip.creatorName} ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: widget.trip.title),
                      ],
                    ),
                  ),
                ),
                
                // Comments
                if (widget.trip.commentsCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    child: Text(
                      'View all ${widget.trip.commentsCount} comments',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                
                // Time Posted
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                  child: Text(
                    formatTimeAgo(widget.trip.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
