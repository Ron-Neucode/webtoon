import 'package:flutter/material.dart';
import '../models/webtoon.dart';

class WebtoonCard extends StatelessWidget {
  final Webtoon webtoon;

  WebtoonCard({required this.webtoon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          webtoon.thumbnail,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(webtoon.title),
        subtitle: Text(
          webtoon.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
