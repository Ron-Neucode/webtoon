import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/webtoon.dart';
import 'tag_service.dart';

final logger = Logger();

class ApiService {
  // Single API: Mangadex only
  static const String baseUrl = 'https://api.mangadex.org';

  // Endpoint 1: Fetch webtoons (w/ optional genre filter)
  static Future<List<Webtoon>> fetchWebtoons({
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
        '$baseUrl/manga',
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

  // Endpoint 2: Search webtoons
  static Future<List<Webtoon>> searchWebtoons(
    String query, {
    int limit = 20,
  }) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        '$baseUrl/manga',
        queryParameters: {
          'limit': limit,
          'title': query,
          'includes[]': ['cover_art'],
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Webtoon.fromMangadexJson(json)).toList();
      }
    } on DioException catch (e) {
      logger.e('Search Dio Error: ${e.message}');
    } catch (e) {
      logger.e('Search API Error: $e');
    }
    return [];
  }

  // Endpoint 3: Get webtoon details
  static Future<Webtoon> getWebtoonDetails(String id) async {
    final dio = Dio();
    try {
      final response = await dio.get('$baseUrl/manga/$id?includes[]=cover_art');
      if (response.statusCode == 200) {
        return Webtoon.fromMangadexJson(response.data['data']);
      }
    } on DioException catch (e) {
      logger.e('Details Dio Error: ${e.message}');
    } catch (e) {
      logger.e('Details API Error: $e');
    }
    throw Exception('Failed to load details');
  }

  // Endpoint 4: Get top webtoons
  static Future<List<Webtoon>> getTopWebtoons({int limit = 20}) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        '$baseUrl/manga',
        queryParameters: {
          'limit': limit,
          'order[createdAt]': 'desc',
          'includes[]': ['cover_art'],
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Webtoon.fromMangadexJson(json)).toList();
      }
    } on DioException catch (e) {
      logger.e('Top Dio Error: ${e.message}');
    } catch (e) {
      logger.e('Top API Error: $e');
    }
    return [];
  }

  // Endpoint 5: Get recommendations by genre
  static Future<List<Webtoon>> getRecommendations(
    String genre, {
    int limit = 20,
  }) async {
    return fetchWebtoons(limit: limit, genre: genre);
  }
}
