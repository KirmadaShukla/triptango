class ExploreTrip {
  final String id;
  final String title;
  final String coverImageUrl;
  final int likesCount;
  final String location;
  final String creatorName;
  final DateTime createdAt;
  final String? isLiked; // Optional field for trip destination


  ExploreTrip({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.likesCount,
    required this.location,
    required this.creatorName,
    required this.createdAt,
    this.isLiked,
  });

  factory ExploreTrip.fromJson(Map<String, dynamic> json) {
    return ExploreTrip(
      id: json['id'],
      title: json['title'],
      coverImageUrl: json['cover_image_url'],
      likesCount: json['likes_count'] ?? 0,
      location: json['destination'],
      creatorName: json['creator']['name'],
      createdAt: DateTime.parse(json['created_at']),
      isLiked: json['is_liked'] as String?, // Optional field
    );
  }
}
