import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/core/constants/app_constants.dart';
import 'package:triptango/features/home/provider/home_provider.dart';
import 'package:triptango/features/home/widgets/featured_trips_section.dart';
import 'package:triptango/features/home/widgets/upcoming_trips_carousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider()..fetchFeaturedTrips()..fetchUpcomingTrips(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.upcomingTrips.isNotEmpty)
                    const UpcomingTripsCarousel(),
                  const SizedBox(height: AppConstants.paddingL),
                  const FeaturedTripsSection(),
                  const SizedBox(height: AppConstants.paddingXL),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
