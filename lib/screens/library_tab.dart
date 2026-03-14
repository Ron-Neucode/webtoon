import 'package:flutter/material.dart';

class LibraryTab extends StatelessWidget {
  final List<String> savedWebtoons = [
    "Tower of God",
    "Solo Leveling",
    "Lore Olympus",
  ];

  @override
  Widget build(BuildContext context) {
    return savedWebtoons.isEmpty
        ? Center(child: Text("No saved webtoons yet"))
        : ListView.builder(
            itemCount: savedWebtoons.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.bookmark),
                  title: Text(savedWebtoons[index]),
                ),
              );
            },
          );
  }
}
