import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../providers/webtoon_provider.dart';
import '../widgets/webtoon_card.dart';
import '../models/webtoon.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Load initial webtoons
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WebtoonProvider>(
        context,
        listen: false,
      ).fetchWebtoons(limit: 50);
    });
  }

  Future<void> _refreshWebtoons() async {
    Provider.of<WebtoonProvider>(
      context,
      listen: false,
    ).fetchWebtoons(limit: 50);
  }

  void _onSearchSubmit(String query) {
    if (query.trim().isNotEmpty) {
      Provider.of<WebtoonProvider>(
        context,
        listen: false,
      ).searchWebtoons(query.trim());
      setState(() => _isSearching = true);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _isSearching = false);
    Provider.of<WebtoonProvider>(
      context,
      listen: false,
    ).fetchWebtoons(limit: 50);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebtoonProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading &&
            provider.webtoons.isEmpty &&
            provider.searchResults.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Webtoon> displayWebtoons = _isSearching
            ? provider.searchResults
            : provider.webtoons;

        final String title = _isSearching
            ? '${displayWebtoons.length} Search Results'
            : 'Latest Webtoons';

        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _onSearchSubmit,
                      decoration: InputDecoration(
                        hintText: 'Search webtoons by title...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            _isSearching && _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _clearSearch,
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Results header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _isSearching
                    ? () async => _onSearchSubmit(_searchController.text)
                    : _refreshWebtoons,
                child: displayWebtoons.isEmpty && provider.isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading webtoons...'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: displayWebtoons.length,
                        itemBuilder: (context, index) {
                          return WebtoonCard(webtoon: displayWebtoons[index]);
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
