import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/core/models/trip_model.dart';
import 'package:triptango/features/home/provider/home_provider.dart';
import 'dart:ui';
import 'dart:async';

class UpcomingTripsCarousel extends StatefulWidget {
  const UpcomingTripsCarousel({super.key});

  @override
  State<UpcomingTripsCarousel> createState() => _UpcomingTripsCarouselState();
}

class _UpcomingTripsCarouselState extends State<UpcomingTripsCarousel> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    if (provider.upcomingTrips.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          int nextPage = (_pageController.page?.round() ?? 0) + 1;
          if (nextPage >= provider.upcomingTrips.length) {
            nextPage = 0; // Loop back to the first item
          }
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<HomeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stylish heading with gradient effect
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'Upcoming Adventures',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Base color, overridden by gradient
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Carousel with loading and error states
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (provider.errorMessage != null) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      provider.errorMessage!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.error.withOpacity(0.8),
                      ),
                    ),
                  ),
                );
              }

              if (provider.upcomingTrips.isEmpty) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'No upcoming trips found.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    // Carousel
                    PageView.builder(
                      controller: _pageController,
                      itemCount: provider.upcomingTrips.length,
                      itemBuilder: (context, index) {
                        final trip = provider.upcomingTrips[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _TripCarouselCard(trip: trip),
                        );
                      },
                    ),
                    // Dots indicator
                    if (provider.upcomingTrips.length > 1)
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: _DotsIndicator(
                          itemCount: provider.upcomingTrips.length,
                          controller: _pageController,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Internal widget for each carousel card
class _TripCarouselCard extends StatelessWidget {
  final TripModel trip;

  const _TripCarouselCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Add tap functionality if needed
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: trip.coverImageUrl != null
                  ? Image.network(
                      trip.coverImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300]?.withOpacity(0.5),
                        child: const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.white70,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300]?.withOpacity(0.5),
                      child: const Icon(
                        Icons.image,
                        size: 48,
                        color: Colors.white70,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// Dots indicator widget
class _DotsIndicator extends StatelessWidget {
  final int itemCount;
  final PageController controller;

  const _DotsIndicator({required this.itemCount, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            double value = 1.0;
            if (controller.hasClients && controller.position.hasContentDimensions) {
              value = controller.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.4, 1.0);
            }
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(value),
              ),
            );
          },
        );
      }),
    );
  }
}