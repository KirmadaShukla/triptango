import 'package:flutter/material.dart';
import 'package:triptango/core/services/api_service.dart';
import 'package:triptango/core/models/comment_model.dart';

class CommentsProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  Future<void> fetchComments(String tripId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getComments(tripId);
      final List<dynamic> data = response.data;
      _comments = data.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
