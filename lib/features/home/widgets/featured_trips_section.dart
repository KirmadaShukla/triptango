import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/features/home/provider/home_provider.dart';
import 'package:triptango/features/home/widgets/featured_trip_card.dart';

class FeaturedTripsSection extends StatelessWidget {
  const FeaturedTripsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Featured Trips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.featuredTrips.length,
                itemBuilder: (context, index) {
                  final trip = provider.featuredTrips[index];
                  return FeaturedTripCard(trip: trip);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
