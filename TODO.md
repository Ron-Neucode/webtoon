# API Consolidation TODO

## Plan Progress

- [x] Step 1: Update lib/services/api_service.dart (Mangadex only, add searchWebtoons, getWebtoonDetails, getTopWebtoons → 5 endpoints total)

- [x] Step 2: Create lib/providers/webtoon_provider.dart (unified provider)
- [x] Step 3: Delete lib/providers/jikan_provider.dart & lib/providers/kitsu_provider.dart
- [ ] Step 4: Update lib/main.dart (use WebtoonProvider only)
- [x] Step 5: Update lib/screens/home_tab.dart & lib/screens/categories_tab.dart (use WebtoonProvider)
- [x] Step 6: Test app (flutter run), verify home/categories load, no errors
- [x] Step 7: Complete task

Current: Starting Step 1
