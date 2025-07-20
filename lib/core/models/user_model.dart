import 'address_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? bio;
  final bool? isActive;
  final String? dateJoined;
  final int? tripsCompleted;
  final int? tripsCancelled;
  final int? totalTripsJoined;
  final int? totalReviewsReceived;
  final int? totalReviewsGiven;
  final double? averageRatingReceived;
  final int? points;
  final String? interest;
  final Address? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.bio,
    this.isActive,
    this.dateJoined,
    this.tripsCompleted,
    this.tripsCancelled,
    this.totalTripsJoined,
    this.totalReviewsReceived,
    this.totalReviewsGiven,
    this.averageRatingReceived,
    this.points,
    this.interest,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String, // required
      bio: json['bio'] as String?,
      isActive: json['is_active'] as bool?,
      dateJoined: json['date_joined'] as String?,
      tripsCompleted: json['trips_completed'] as int?,
      tripsCancelled: json['trips_cancelled'] as int?,
      totalTripsJoined: json['total_trips_joined'] as int?,
      totalReviewsReceived: json['total_reviews_received'] as int?,
      totalReviewsGiven: json['total_reviews_given'] as int?,
      averageRatingReceived: (json['average_rating_received'] as num?)?.toDouble(),
      points: json['points'] as int?,
      interest: json['interest'] as String?,
      address: json['address'] != null ? Address(
        addressLine1: json['address']['addressLine1'] ?? '',
        addressLine2: json['address']['addressLine2'],
        country: json['address']['country'] ?? '',
        state: json['address']['state'] ?? '',
        city: json['address']['city'] ?? '',
        pincode: json['address']['pincode'] ?? '',
      ) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      if (bio != null) 'bio': bio,
      if (isActive != null) 'is_active': isActive,
      if (dateJoined != null) 'date_joined': dateJoined,
      if (tripsCompleted != null) 'trips_completed': tripsCompleted,
      if (tripsCancelled != null) 'trips_cancelled': tripsCancelled,
      if (totalTripsJoined != null) 'total_trips_joined': totalTripsJoined,
      if (totalReviewsReceived != null) 'total_reviews_received': totalReviewsReceived,
      if (totalReviewsGiven != null) 'total_reviews_given': totalReviewsGiven,
      if (averageRatingReceived != null) 'average_rating_received': averageRatingReceived,
      if (points != null) 'points': points,
      if (interest != null) 'interest': interest,
      if (address != null) 'address': address!.toJson(),
    };
  }
} 