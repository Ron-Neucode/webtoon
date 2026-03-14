import 'package:flutter/material.dart';

class CategoriesTab extends StatelessWidget {
  final List<String> genres = [
    "Romance",
    "Action",
    "Fantasy",
    "Comedy",
    "Drama",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.category),
            title: Text(genres[index]),
            onTap: () {
              // TODO: Implement filtering by genre
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Selected ${genres[index]}")),
              );
            },
          ),
        );
      },
    );
  }
}
