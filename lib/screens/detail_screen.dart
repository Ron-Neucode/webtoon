import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/webtoon.dart';
import 'dart:convert';

class DetailScreen extends StatefulWidget {
  final Webtoon webtoon;

  const DetailScreen({super.key, required this.webtoon});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('loggedInUser');
    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save webtoons')),
      );
      return;
    }

    List<String> library = prefs.getStringList('library_$username') ?? [];
    final webtoonJsonStr = jsonEncode(widget.webtoon.toJson());
    final isBookmarked = library.any((jsonStr) {
      try {
        return jsonDecode(jsonStr)['id'] == widget.webtoon.id;
      } catch (e) {
        return false;
      }
    });
    if (isBookmarked) {
      library.removeWhere((jsonStr) {
        try {
          return jsonDecode(jsonStr)['id'] == widget.webtoon.id;
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.webtoon.title),
              background: Hero(
                tag: widget.webtoon.id,
                child: Image.network(
                  widget.webtoon.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: _toggleBookmark,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.webtoon.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.category, color: Colors.purple),
                      const SizedBox(width: 8),
                      Wrap(
                        spacing: 4,
                        children: widget.webtoon.genres
                            .map(
                              (g) => Chip(
                                label: Text(
                                  g,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.purple[100],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Chapters',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (c, i) => Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text('Chapter ${i + 1}'),
                        trailing: const Icon(Icons.touch_app),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reading Chapter ${i + 1}...'),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Started reading ${widget.webtoon.title}',
                                  ),
                                ),
                              ),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Reading'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 56),
                          ),
                        ).animate().slideY(),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: _toggleBookmark,
                        icon: const Icon(Icons.bookmark_border, size: 28),
                        tooltip: 'Bookmark',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
