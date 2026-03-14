import 'package:flutter/material.dart';
import '../models/webtoon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DetailScreen extends StatelessWidget {
  final Webtoon webtoon;

  const DetailScreen({Key? key, required this.webtoon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(webtoon.title),
              background: Hero(
                tag: webtoon.id,
                child: Image.network(
                  webtoon.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    webtoon.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.purple),
                      SizedBox(width: 8),
                      Wrap(
                        spacing: 4,
                        children: webtoon.genres
                            .map(
                              (g) => Chip(
                                label: Text(g, style: TextStyle(fontSize: 12)),
                                backgroundColor: Colors.purple[100],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Chapters',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (c, i) => ListTile(
                      leading: CircleAvatar(child: Text('${i + 1}')),
                      title: Text('Chapter ${i + 1}'),
                      trailing: Icon(Icons.touch_app),
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reading Chapter ${i + 1}...')),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Started reading ${webtoon.title}'),
                      ),
                    ),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start Reading'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56),
                    ),
                  ).animate().slideY(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
