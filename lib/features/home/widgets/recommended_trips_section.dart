import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/features/home/provider/home_provider.dart';
import 'package:triptango/features/home/widgets/recommended_trip_card.dart';

class RecommendedTripsSection extends StatelessWidget {
  const RecommendedTripsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        if (provider.recommendedTrips.isEmpty) {
          return const Center(child: Text('No recommended trips found.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recommended for You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.recommendedTrips.length,
                itemBuilder: (context, index) {
                  final trip = provider.recommendedTrips[index];
                  return RecommendedTripCard(trip: trip);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
