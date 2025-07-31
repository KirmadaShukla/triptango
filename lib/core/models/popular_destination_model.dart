class PopularDestination {
  final String destination;
  final int tripCount;

  PopularDestination({required this.destination, required this.tripCount});

  factory PopularDestination.fromJson(Map<String, dynamic> json) {
    return PopularDestination(
      destination: json['destination'],
      tripCount: json['trip_count'],
    );
  }
}
