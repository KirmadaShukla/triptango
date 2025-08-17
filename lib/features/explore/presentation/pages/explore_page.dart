import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triptango/features/explore/presentation/providers/explore_provider.dart';
import 'package:triptango/features/explore/presentation/widgets/instagram_post.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
    if (exploreProvider.trips.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        exploreProvider.fetchTrips();
      });
    }
  }

  void _onScroll() {
    final exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      exploreProvider.fetchTrips();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ExploreProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.trips.isEmpty) {
            return _buildShimmerEffect();
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchTrips(forceRefresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: provider.trips.length,
                    itemBuilder: (context, index) {
                      final trip = provider.trips[index];
                      return InstagramPost(trip: trip);
                    },
                  ),
                ),
              ),
              if (provider.isLoading && provider.trips.isNotEmpty)
                _buildBottomShimmerEffect(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildShimmerItem();
        },
      ),
    );
  }

  Widget _buildBottomShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 80,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Image Shimmer
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: Colors.white,
            ),
          ),
          
          // Actions Shimmer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 24, height: 24, color: Colors.white),
                    const SizedBox(width: 16),
                    Container(width: 24, height: 24, color: Colors.white),
                    const SizedBox(width: 16),
                    Container(width: 24, height: 24, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 12, width: 80, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 12, width: double.infinity, color: Colors.white),
                const SizedBox(height: 4),
                Container(height: 12, width: 200, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
