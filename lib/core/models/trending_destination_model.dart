class TrendingDestinationModel {
  final String destination;
  final int tripCount;
  final String coverImageUrl;

  TrendingDestinationModel({
    required this.destination,
    required this.tripCount,
    required this.coverImageUrl,
  });

  factory TrendingDestinationModel.fromJson(Map<String, dynamic> json) {
    return TrendingDestinationModel(
      destination: json['destination'],
      tripCount: json['trip_count'],
      coverImageUrl: json['cover_image_url'],
    );
  }
}
