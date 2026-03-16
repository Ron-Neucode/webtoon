import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/webtoon.dart';
import '../screens/detail_screen.dart';
import 'dart:convert';

class WebtoonCard extends StatelessWidget {
  final Webtoon webtoon;

  const WebtoonCard({super.key, required this.webtoon});

  Future<void> _toggleBookmark(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('loggedInUser');
    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save webtoons')),
      );
      return;
    }

    List<String> library = prefs.getStringList('library_$username') ?? [];
    final webtoonJsonStr = jsonEncode(webtoon.toJson());
    final isBookmarked = library.any((jsonStr) {
      try {
        return jsonDecode(jsonStr)['id'] == webtoon.id;
      } catch (e) {
        return false;
      }
    });
    if (isBookmarked) {
      library.removeWhere((jsonStr) {
        try {
          return jsonDecode(jsonStr)['id'] == webtoon.id;
        } catch (e) {
          return false;
        }
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from library')));
    } else {
      library.add(webtoonJsonStr);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to library')));
    }

    await prefs.setStringList('library_$username', library);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(webtoon: webtoon)),
      ),
      child: Hero(
        tag: webtoon.id,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: webtoon.thumbnail,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  onPressed: () => _toggleBookmark(context),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 179),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        webtoon.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (webtoon.genres.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: webtoon.genres
                                .take(3)
                                .map(
                                  (g) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Chip(
                                      label: Text(
                                        g,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.purple.withValues(
                                        alpha: 204,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).scale();
  }
}
