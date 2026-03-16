import 'package:flutter/foundation.dart';
import '../services/api_service.dart' as api;
import '../models/webtoon.dart' as models;

class KitsuProvider with ChangeNotifier {
  List<models.Webtoon> _webtoons = [];
  bool _isLoading = false;
  String? _error;

  List<models.Webtoon> get webtoons => _webtoons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchManga({int limit = 20}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _webtoons = await api.ApiService.fetchKitsuWebtoons(limit: limit);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
