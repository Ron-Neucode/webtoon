import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/webtoon.dart';
import '../widgets/webtoon_card.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  String? _username;
  List<Webtoon> _savedWebtoons = [];

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('loggedInUser') ?? prefs.getString('username');
    final jsonList = prefs.getStringList('library_$_username') ?? [];
    _savedWebtoons = jsonList.map((jsonStr) {
      try {
        return Webtoon.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        // Backward compat for old title strings
        return Webtoon(
          id: '',
          title: jsonStr,
          thumbnail: '',
          description: '',
          genres: [],
        );
      }
    }).toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _removeWebtoon(int index) async {
    if (_username == null) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('library_$_username') ?? [];
    jsonList.removeAt(index);
    await prefs.setStringList('library_$_username', jsonList);
    await _loadLibrary(); // Reload parsed list
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Removed from library')));
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null || _savedWebtoons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No saved webtoons yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap bookmark on webtoon cards to save them here!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadLibrary,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLibrary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _savedWebtoons.length,
          itemBuilder: (context, index) {
            return WebtoonCard(webtoon: _savedWebtoons[index]);
          },
        ),
      ),
    );
  }
}
