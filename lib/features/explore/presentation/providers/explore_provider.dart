import 'package:flutter/material.dart';
import 'package:triptango/core/services/api_service.dart';
import 'package:triptango/features/explore/data/models/explore_trip_model.dart';

class ExploreProvider extends ChangeNotifier {
  List<ExploreTrip> _trips = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  DateTime? _lastFetched;

  List<ExploreTrip> get trips => _trips;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchTrips({bool forceRefresh = false}) async {
    final now = DateTime.now();
    if (!forceRefresh && _lastFetched != null && now.difference(_lastFetched!) < const Duration(minutes: 5) && _trips.isNotEmpty) {
      return;
    }

    if (_isLoading || (!_hasMore && !forceRefresh)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getExploreTrips(forceRefresh ? 1 : _currentPage);
      final newTrips = (response.data['results'] as List)
          .map((trip) => ExploreTrip.fromJson(trip))
          .toList();

      if (forceRefresh) {
        _trips.clear();
        _currentPage = 1;
        _hasMore = true;
      }

      if (newTrips.isEmpty) {
        _hasMore = false;
      } else {
        _trips.addAll(newTrips);
        _currentPage++;
        _lastFetched = now;
      }
    } catch (e) {
      debugPrint('Error fetching trips: $e');
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refresh() {
    fetchTrips(forceRefresh: true);
  }
}
