import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/webtoon.dart';

final logger = Logger();

class ApiService {
  static const String baseUrl = 'https://api.mangadex.org';

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
        queryParams['tags[]'] = [genre];
      }
      final response = await dio.get(
        '$baseUrl/manga',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Webtoon.fromMangadexJson(json)).toList();
      } else {
        logger.w('API response code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio Error: ${e.message}');
    } catch (e) {
      logger.e('API Error: $e');
    }
    return [];
  }
}
