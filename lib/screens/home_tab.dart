import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/api_service.dart';
import '../widgets/webtoon_card.dart';
import '../models/webtoon.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Webtoon>>(
      future: ApiService.fetchWebtoons(limit: 50),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return Center(
            child: Text("No webtoons available. Check console for errors."),
          );
        } else {
          final webtoons = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(8),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              itemCount: webtoons.length,
              itemBuilder: (context, index) =>
                  WebtoonCard(webtoon: webtoons[index]),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          );
        }
      },
    );
  }
}
