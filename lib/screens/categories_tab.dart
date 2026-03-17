import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/webtoon_provider.dart';
import '../services/tag_service.dart';
import '../widgets/webtoon_card.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String? selectedGenre;
  List<String> genresList = [];
  bool isLoadingTags = true;

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      final tagMap = await TagService.getTagMap();
      setState(() {
        genresList = tagMap.keys.map((key) => key.capitalize()).toList()
          ..sort();
        isLoadingTags = false;
      });
      // Initial load
      if (mounted) {
        Provider.of<WebtoonProvider>(
          context,
          listen: false,
        ).fetchWebtoons(limit: 50);
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingTags = false);
    }
  }

  Future<void> _loadWebtoons() async {
    if (selectedGenre == null) return;
    final provider = Provider.of<WebtoonProvider>(context, listen: false);
    await provider.fetchWebtoons(
      limit: 50,
      genre: selectedGenre!.toLowerCase(),
    );
  }

  Future<void> _refreshWebtoons() async => _loadWebtoons();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebtoonProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Categories filter chips
            Container(
              height: 80,
              padding: const EdgeInsets.all(8),
              child: isLoadingTags
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: genresList.map((genreName) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(genreName),
                              selected:
                                  selectedGenre == genreName.toLowerCase(),
                              onSelected: (selected) {
                                setState(() {
                                  selectedGenre = selected
                                      ? genreName.toLowerCase()
                                      : null;
                                });
                                _loadWebtoons();
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),

            // Webtoons grid
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
                                    "No webtoons for category. Try another.",
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
                        itemBuilder: (context, index) =>
                            WebtoonCard(webtoon: provider.webtoons[index]),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

// Extension for capitalize
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
