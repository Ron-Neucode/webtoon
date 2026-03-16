# MangaVerse Polish & Fix TODO

## Current Status

App functional: APIs, login, tabs, bookmarks (SharedPrefs), nice cards/grids.

## Step-by-Step Plan (Approved: Full fixes + UI/UX polish)

### 1. Bug Fixes (High Priority)

- [✅] Step 1 Bug Fixes complete.

### 2. UI/UX/Design Polish

- [✅] Update main.dart theme/dark mode.\n- [✅] theme_provider.dart created.
- [ ] Profile: Connect dark toggle to provider.
- [ ] Add search bar to home_tab.dart/categories_tab.dart.
- [ ] Skeleton loading in grids.

### 3. Functionality Enhancements

- [ ] Providers: Add fetchMore for infinite scroll.
- [ ] Screens: Implement infinite scroll listeners.
- [ ] Integrate Jikan/Kitsu: e.g., Home mix or separate sections.
- [ ] Detail: Fetch real chapters if possible.

### 4. Persistence Upgrade (Optional but TODO)

- [ ] Hive: Webtoon adapter, hive_service.dart for library.
- [ ] Migrate SharedPrefs on first run.

### 5. Testing & Production

- [ ] Enhance widget_test.dart: Provider mocks.
- [ ] Run: `flutter pub get && flutter analyze && flutter test && flutter run`

## Progress Tracking

Start with Step 1.

Next command after each: `flutter analyze` to check.
