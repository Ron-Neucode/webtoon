import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/webtoon.dart';

class ApiService {
  static const String baseUrl =
      "https://mocki.io/v1/your-mock-json"; // Replace with MangaDex or your own API

  static Future<List<Webtoon>> fetchWebtoons() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Webtoon.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load webtoons");
    }
  }
}
