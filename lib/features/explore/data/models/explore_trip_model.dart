class ExploreTrip {
  final String id;
  final String title;
  final String coverImageUrl;
  final int likesCount;
  final int commentsCount;

  ExploreTrip({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.likesCount,
    required this.commentsCount,
  });

  factory ExploreTrip.fromJson(Map<String, dynamic> json) {
    return ExploreTrip(
      id: json['id'],
      title: json['title'],
      coverImageUrl: json['cover_image_url'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
    );
  }
}
