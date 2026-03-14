import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/webtoon.dart';
import '../widgets/webtoon_card.dart';

class CategoriesTab extends StatefulWidget {
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
    webtoonsFuture = ApiService.fetchWebtoons(limit: 50);
    selectedGenre = null;
  }

  List<Webtoon> _getFilteredWebtoons(List<Webtoon> webtoons) {
    if (selectedGenre == null) return webtoons;
    return webtoons
        .where(
          (webtoon) => webtoon.genres.any(
            (genre) => genre.toLowerCase() == selectedGenre!.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: genres
                  .map(
                    (genre) => Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(genre),
                        selected: selectedGenre == genre,
                        onSelected: (selected) {
                          setState(() {
                            selectedGenre = selected ? genre : null;
                          });
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
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(child: Text('No webtoons available'));
              }
              final webtoons = snapshot.data!;
              final filtered = _getFilteredWebtoons(webtoons);
              return GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return WebtoonCard(webtoon: filtered[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
