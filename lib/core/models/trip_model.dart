import 'user_model.dart';

class TripModel {
  final String id;
  final String title;
  final String destination;
  final String startDate;
  final String endDate;
  final String? description;
  final UserModel? creator;
  final List<UserModel>? participants;
  final String? createdAt;
  final double? budget;
  final int? groupSize;
  final String? currency;
  final String? status;
  final String? coverImageUrl;
  final String? updatedAt;
  final bool isPublic;
  final String? interests;

  
  TripModel({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.description,
    this.creator,
    this.participants,
    this.createdAt,
    this.budget,
    this.groupSize,
    this.currency,
    this.status,
    this.coverImageUrl,
    this.updatedAt,
    required this.isPublic,
    this.interests,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      description: json['description'] as String?,
      creator: json['creator'] != null ? UserModel.fromJson(json['creator']) : null,
      participants: json['participants'] != null
          ? (json['participants'] as List<dynamic>).map((e) => UserModel.fromJson(e)).toList()
          : null,
      createdAt: json['created_at'] as String?,
      budget: json['budget'] != null
          ? (json['budget'] is num
              ? (json['budget'] as num).toDouble()
              : double.tryParse(json['budget'].toString()))
          : null,
      groupSize: json['group_size'] != null
          ? (json['group_size'] is int
              ? json['group_size'] as int
              : int.tryParse(json['group_size'].toString()))
          : null,
      currency: json['currency'] as String?,
      status: json['status'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      updatedAt: json['updated_at'] as String?,
      isPublic: json['is_public'] as bool? ?? true,
      interests: json['interests'] as String?,
    );
  }
}
