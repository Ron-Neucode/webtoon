import 'package:flutter/material.dart';
import '../models/webtoon.dart';
import '../services/api_service.dart';

class WebtoonProvider with ChangeNotifier {
  List<Webtoon> _webtoons = [];
  List<Webtoon> _searchResults = [];
  Webtoon? _details;
  bool _isLoading = false;
  String? _error;

  List<Webtoon> get webtoons => _webtoons;
  List<Webtoon> get searchResults => _searchResults;
  Webtoon? get details => _details;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWebtoons({int limit = 20, String? genre}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _webtoons = await ApiService.fetchWebtoons(limit: limit, genre: genre);
    } catch (e) {
      _error = e.toString();
      _webtoons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchWebtoons(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await ApiService.searchWebtoons(query);
    } catch (e) {
      _error = e.toString();
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWebtoonDetails(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _details = await ApiService.getWebtoonDetails(id);
    } catch (e) {
      _error = e.toString();
      _details = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTopWebtoons({int limit = 20}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _webtoons = await ApiService.getTopWebtoons(limit: limit);
    } catch (e) {
      _error = e.toString();
      _webtoons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRecommendations(String genre, {int limit = 20}) async {
    await fetchWebtoons(limit: limit, genre: genre);
  }
}
