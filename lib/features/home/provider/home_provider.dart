import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptango/core/models/popular_destination_model.dart';
import 'package:triptango/core/models/trip_model.dart';
import '../../../core/services/api_service.dart';
class HomeProvider extends ChangeNotifier {
    bool _isLoading = false;
  String? _errorMessage;
  List<TripModel> _trips = [];
  List<TripModel> _upcomingTrips = [];
  List<TripModel> _recommendedTrips = [];
  List<PopularDestination> _popularDestinations = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<TripModel> get featuredTrips => _trips;
  List<TripModel> get upcomingTrips => _upcomingTrips;
  List<TripModel> get recommendedTrips => _recommendedTrips;
  List<PopularDestination> get popularDestinations => _popularDestinations;

  Future<void> fetchUpcomingTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.getUpcomingTrips();
      if (response.statusCode == 200) {
        final List<dynamic> tripData = response.data;
        _upcomingTrips = tripData.map((data) => TripModel.fromJson(data)).toList();
      } else {
        _errorMessage = 'Failed to load upcoming trips';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFeaturedTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.getFeaturedTrips();
      if (response.statusCode == 200) {
        final List<dynamic> tripData = response.data;
        _trips = tripData.map((data) => TripModel.fromJson(data)).toList();
              } else {
        _errorMessage = 'Failed to load featured trips';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecommendedTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.getRecommendedTrips();
      if (response.statusCode == 200) {
        final List<dynamic> tripData = response.data;
        _recommendedTrips = tripData.map((data) => TripModel.fromJson(data)).toList();
      } else {
        _errorMessage = 'Failed to load recommended trips';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopularDestinations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.getPopularDestinations();
      if (response.statusCode == 200) {
        final List<dynamic> tripData = response.data;
        _popularDestinations = tripData.map((data) => PopularDestination.fromJson(data)).toList();
      } else {
        _errorMessage = 'Failed to load popular destinations';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
