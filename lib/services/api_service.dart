import 'package:dio/dio.dart';
import '../models/webtoon.dart';

class ApiService {
  static const String baseUrl = 'https://api.mangadex.org/manga';

  static Future<List<Webtoon>> fetchWebtoons({int limit = 20}) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        baseUrl,
        queryParameters: {'limit': limit, 'includes[]': 'cover_art'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Webtoon.fromMangadexJson(json)).toList();
      } else {
        print('API response code: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }
}
