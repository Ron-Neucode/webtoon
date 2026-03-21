import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class TagService {
  static const String mangadexBaseUrl = 'https://api.mangadex.org';

  static Future<Map<String, String>> getTagMap() async {
    final dio = Dio();
    try {
      final response = await dio.get('$mangadexBaseUrl/manga/tag?limit=100');
      if (response.statusCode == 200) {
        final Map<String, String> tagMap = {};
        final List<dynamic> tags = response.data['data'];
        for (var tag in tags) {
          final id = tag['id'];
          final name = tag['attributes']['name']['en'] ?? '';
          if (name.isNotEmpty) {
            tagMap[name.toLowerCase()] = id;
          }
        }
        logger.i('Loaded ${tagMap.length} Mangadex tags');
        return tagMap;
      }
    } catch (e) {
      logger.e('Tag fetch error: $e');
    }
    return {};
  }
}
