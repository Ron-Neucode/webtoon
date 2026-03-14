import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/webtoon_card.dart';
import '../models/webtoon.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Webtoon>>(
      future: ApiService.fetchWebtoons(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading webtoons"));
        } else {
          final webtoons = snapshot.data!;
          return ListView.builder(
            itemCount: webtoons.length,
            itemBuilder: (context, index) {
              return WebtoonCard(webtoon: webtoons[index]);
            },
          );
        }
      },
    );
  }
}
