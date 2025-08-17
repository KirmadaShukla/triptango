
import 'package:flutter/material.dart';
import 'package:triptango/core/services/api_service.dart';

class LikeProvider with ChangeNotifier {
  bool isLiked;

  LikeProvider({required this.isLiked});

  Future<void> toggleLike(String tripId) async {
    isLiked = !isLiked;
    notifyListeners();

    try {
      if (isLiked) {
        await ApiService.likeTrip(tripId);
      } else {
        // TODO: Implement unlike functionality
      }
    } catch (e) {
      isLiked = !isLiked;
      notifyListeners();
      print(e);
    }
  }
}
