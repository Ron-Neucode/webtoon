import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/webtoon.dart';
import 'tag_service.dart';

final logger = Logger();

class ApiService {
  // Mangadex base URL
  static const String baseUrl = 'https://api.mangadex.org';

  // Core endpoint: fetchWebtoons - simplified minimal params
  static Future<List<Webtoon>> fetchWebtoons({
    int limit = 20,
    String? genre,
  }) async {
    final dio = Dio()
      ..options.validateStatus = (status) => status != null && status < 500;
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit,
        'includes[]': ['cover_art'],
        'order[createdAt]': 'desc',
      };
      if (genre != null && genre.isNotEmpty) {
        final tagMap = await TagService.getTagMap();
        final tagId = tagMap[genre.toLowerCase()];
        if (tagId != null) {
          queryParams['includedTags[]'] = [tagId];
        } else {
          logger.w('No tag ID for genre: $genre - fetching without tag filter');
        }
      }
      logger.i('Fetching with params: $queryParams');
      final response = await dio.get(
        '$baseUrl/manga',
        queryParameters: queryParams,
      );
      logger.i(
        'Response status: ${response.statusCode}, data keys: ${response.data.keys.toList()}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final results = data
            .map((json) => Webtoon.fromMangadexJson(json))
            .toList();
        logger.i('Fetched ${results.length} webtoons');
        return results;
      } else {
        logger.w(
          'Mangadex API status ${response.statusCode}: ${response.data}',
        );
      }
    } on DioException catch (e) {
      logger.e('Mangadex Dio Error: ${e.message}');
      logger.e('Response: ${e.response?.data}');
    } catch (e) {
      logger.e('Mangadex API Error: $e');
    }
    logger.w('Returning empty list due to error');
    return [];
  }

  // searchWebtoons
  static Future<List<Webtoon>> searchWebtoons(String query) async {
    final dio = Dio()
      ..options.validateStatus = (status) => status != null && status < 500;
    try {
      final response = await dio.get(
        '$baseUrl/manga',
        queryParameters: {
          'limit': 20,
          'includes[]': ['cover_art'],
          'title': query,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Webtoon.fromMangadexJson(json)).toList();
      }
    } on DioException catch (e) {
      logger.e('Search Dio Error: ${e.message}');
    } catch (e) {
      logger.e('Search API Error: $e');
    }
    return [];
  }

  // getWebtoonDetails
  static Future<Webtoon> getWebtoonDetails(String id) async {
    final dio = Dio()..options.validateStatus = (status) => true;
    try {
      final response = await dio.get(
        '$baseUrl/manga/$id',
        queryParameters: {
          'includes[]': ['cover_art', 'author', 'artist', 'tag'],
        },
      );
      if (response.statusCode == 200) {
        return Webtoon.fromMangadexJson(response.data);
      }
    } on DioException catch (e) {
      logger.e('Details Dio Error: ${e.message}');
    } catch (e) {
      logger.e('Details API Error: $e');
    }
    throw Exception('Failed to load webtoon details');
  }

  // getTopWebtoons
  static Future<List<Webtoon>> getTopWebtoons({int limit = 20}) async {
    final dio = Dio()
      ..options.validateStatus = (status) => status != null && status < 500;
    try {
      final response = await dio.get(
        '$baseUrl/manga',
        queryParameters: {
          'limit': limit,
          'includes[]': ['cover_art'],
          'order[relevance]': 'desc',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Webtoon.fromMangadexJson(json)).toList();
      }
    } on DioException catch (e) {
      logger.e('Top Dio Error: ${e.message}');
    } catch (e) {
      logger.e('Top API Error: $e');
    }
    return [];
  }
}
