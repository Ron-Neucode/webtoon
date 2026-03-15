import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/webtoon.dart';
import '../widgets/webtoon_card.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String? selectedGenre;
  late Future<List<Webtoon>> webtoonsFuture;
  final List<String> genres = [
    "Action",
    "Adventure",
    "Comedy",
    "Drama",
    "Fantasy",
    "Romance",
    "Shounen",
    "Seinen",
    "Slice of Life",
    "Supernatural",
  ];

  @override
  void initState() {
    super.initState();
    selectedGenre = null;
    _loadWebtoons();
  }

  Future<void> _loadWebtoons() async {
    setState(() {
      webtoonsFuture = ApiService.fetchWebtoons(
        limit: 50,
        genre: selectedGenre,
      );
    });
  }

  Future<void> _refreshWebtoons() async {
    await _loadWebtoons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: genres
                  .map(
                    (genre) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(genre),
                        selected: selectedGenre == genre,
                        onSelected: (selected) {
                          setState(() {
                            selectedGenre = selected ? genre : null;
                          });
                          _loadWebtoons();
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Webtoon>>(
            future: webtoonsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text(
                            "No webtoons available for this category. Try another filter.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _refreshWebtoons,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              final webtoons = snapshot.data!;
              return RefreshIndicator(
                onRefresh: _refreshWebtoons,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: webtoons.length,
                  itemBuilder: (context, index) {
                    return WebtoonCard(webtoon: webtoons[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
