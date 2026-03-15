import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/api_service.dart';
import '../widgets/webtoon_card.dart';
import '../models/webtoon.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<Webtoon>> webtoonsFuture;

  @override
  void initState() {
    super.initState();
    webtoonsFuture = ApiService.fetchWebtoons(limit: 50);
  }

  Future<void> _refreshWebtoons() async {
    setState(() {
      webtoonsFuture = ApiService.fetchWebtoons(limit: 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Webtoon>>(
      future: webtoonsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
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
                      "No webtoons available. Check logs for errors.",
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
        } else {
          final webtoons = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshWebtoons,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: webtoons.length,
                itemBuilder: (context, index) =>
                    WebtoonCard(webtoon: webtoons[index]),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
            ),
          );
        }
      },
    );
  }
}
