import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/webtoon.dart';
import 'tag_service.dart';

final logger = Logger();

class ApiService {
  // 3 API Providers
  static const String mangadexBaseUrl =
      'https://api.mangadex.org'; // Provider 1: Manga
  static const String jikanBaseUrl =
      'https://api.jikan.moe/v4'; // Provider 2: MAL
  static const String kitsuBaseUrl =
      'https://kitsu.io/api/edge'; // Provider 3: Manhwa/Manga

  static const String baseUrl = mangadexBaseUrl;

  // Alias for existing screens (Mangadex)
  static Future<List<Webtoon>> fetchWebtoons({int limit = 20, String? genre}) =>
      fetchMangadexWebtoons(limit: limit, genre: genre);

  // Mangadex endpoint
  static Future<List<Webtoon>> fetchMangadexWebtoons({
    int limit = 20,
    String? genre,
  }) async {
    final dio = Dio();
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit,
        'includes[]': ['cover_art'],
        'contentRating[]': ['safe'],
      };
      if (genre != null && genre.isNotEmpty) {
        final tagMap = await TagService.getTagMap();
        final tagId = tagMap[genre.toLowerCase()];
        if (tagId != null) {
          queryParams['tags[]'] = [tagId];
        } else {
          logger.w('No tag ID for genre: $genre');
        }
      }
      final response = await dio.get(
        '$mangadexBaseUrl/manga',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Webtoon.fromMangadexJson(json)).toList();
      } else {
        logger.w('Mangadex API response code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Mangadex Dio Error: ${e.message}');
    } catch (e) {
      logger.e('Mangadex API Error: $e');
    }
    return [];
  }

  // Jikan (MAL) endpoint
  static Future<List<Webtoon>> fetchJikanWebtoons({int limit = 20}) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        '$jikanBaseUrl/top/manga',
        queryParameters: {'limit': limit},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Webtoon.fromJikanJson(json)).toList();
      }
    } catch (e) {
      logger.e('Jikan API Error: $e');
    }
    return [];
  }

  // Kitsu endpoint
  static Future<List<Webtoon>> fetchKitsuWebtoons({int limit = 20}) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        '$kitsuBaseUrl/manga',
        queryParameters: {
          'page[limit]': limit,
          'fields[manga]': 'titles,posterImage,description',
          'include': 'coverArt',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Webtoon.fromKitsuJson(json)).toList();
      }
    } catch (e) {
      logger.e('Kitsu API Error: $e');
    }
    return [];
  }
}
