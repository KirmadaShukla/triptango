import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/core/constants/app_constants.dart';
import 'package:triptango/features/home/provider/home_provider.dart';
import 'package:triptango/features/home/widgets/featured_trips_section.dart';
import 'package:triptango/features/home/widgets/hero_section.dart';
import 'package:triptango/features/home/widgets/recommended_trips_section.dart';
import 'package:triptango/features/home/widgets/upcoming_trips_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    final widgetsCount = 4;
    _slideAnimations = List.generate(
      widgetsCount,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index / widgetsCount,
            (index + 1) / widgetsCount,
            curve: Curves.elasticOut,
          ),
        ),
      ),
    );

    _fadeAnimations = List.generate(
      widgetsCount,
      (index) => Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index / widgetsCount,
            (index + 1) / widgetsCount,
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedWidget(Widget child, int index) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider()
        ..fetchFeaturedTrips()
        ..fetchUpcomingTrips()
        ..fetchRecommendedTrips(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedWidget(const HeroSection(), 0),
                  if (provider.upcomingTrips.isNotEmpty)
                    _buildAnimatedWidget(const UpcomingTripsCarousel(), 1),
                  _buildAnimatedWidget(const FeaturedTripsSpotlight(), 2),
                  const SizedBox(height: AppConstants.paddingL),
                  if (provider.recommendedTrips.isNotEmpty)
                    _buildAnimatedWidget(const RecommendedTripsSection(), 3),
                  const SizedBox(height: AppConstants.paddingL),
                  if (provider.trendingDestinations.isNotEmpty)
                    // _buildAnimatedWidget(const TrendingDestinationsSection(), 4),
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
