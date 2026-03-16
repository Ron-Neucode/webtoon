import 'package:flutter/foundation.dart';
import '../services/api_service.dart' as api;
import '../models/webtoon.dart' as models;

class MangadexProvider with ChangeNotifier {
  List<models.Webtoon> _webtoons = [];
  bool _isLoading = false;
  String? _error;

  List<models.Webtoon> get webtoons => _webtoons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWebtoons({int limit = 20, String? genre}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _webtoons = await api.ApiService.fetchMangadexWebtoons(
        limit: limit,
        genre: genre,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
