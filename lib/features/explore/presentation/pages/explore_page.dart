import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triptango/features/explore/presentation/providers/explore_provider.dart';

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
    final exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (exploreProvider.trips.isEmpty) {
        exploreProvider.fetchTrips();
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        exploreProvider.fetchTrips();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Consumer<ExploreProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.trips.isEmpty) {
            return _buildShimmerEffect();
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchTrips(forceRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.trips.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.trips.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trip = provider.trips[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(trip.coverImageUrl),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(trip.title,
                            style: const TextStyle(fontSize: 18.0)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite),
                              const SizedBox(width: 4.0),
                              Text('${trip.likesCount}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.comment),
                              const SizedBox(width: 4.0),
                              Text('${trip.commentsCount}'),
                            ],
                          ),
                          const Icon(Icons.share),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 200.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 20.0,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(3, (index) => Container(
                    height: 20.0,
                    width: 50.0,
                    color: Colors.white,
                  )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
