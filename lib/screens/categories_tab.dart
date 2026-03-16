import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mangadex_provider.dart';
import '../widgets/webtoon_card.dart';
import '../models/webtoon.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String? selectedGenre;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MangadexProvider>(context, listen: false);
      provider.fetchWebtoons(limit: 50);
    });
  }

  Future<void> _loadWebtoons() async {
    final provider = Provider.of<MangadexProvider>(context, listen: false);
    await provider.fetchWebtoons(limit: 50, genre: selectedGenre ?? '');
  }

  Future<void> _refreshWebtoons() async {
    await _loadWebtoons();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MangadexProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: genres.map((genre) {
                    return Padding(
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
                    );
                  }).toList(),
                ),
              ),
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (provider.error != null || provider.webtoons.isEmpty)
                  ? Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                provider.error ??
                                    "No webtoons available for this category. Try another filter.",
                                style: const TextStyle(fontSize: 16),
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
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshWebtoons,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: provider.webtoons.length,
                        itemBuilder: (context, index) {
                          return WebtoonCard(webtoon: provider.webtoons[index]);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
