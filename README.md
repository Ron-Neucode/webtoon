# Webtoon & Anime Discovery App

A modern Flutter mobile application for discovering, browsing, and managing webtoons, anime, and manga from multiple APIs. Features beautiful animations, offline support, dark mode, and personalized library.

## ✨ Features

- **Multi-API Integration**:
  - Jikan (MyAnimeList)
  - Kitsu
  - Mangadex
  - Webtoon-specific provider
- **Tabbed Navigation**: Home, Library, Categories, Profile, Dashboard
- **Rich UI**: Staggered grids, animated cards, detail screens with cast/characters
- **Offline Support**: Hive database for favorites/library
- **Dark/Light Theme**: System-adaptive theming
- **Advanced Search & Filtering**: By tags, genres, status
- **Responsive Design**: Works on all screen sizes

## 🏗️ Tech Stack

| Category             | Technologies                |
| -------------------- | --------------------------- |
| **Framework**        | Flutter 3.10+               |
| **State Management** | Provider                    |
| **Networking**       | Dio + cached_network_image  |
| **Persistence**      | Hive + SharedPreferences    |
| **Animations**       | flutter_animate, animations |
| **UI Layout**        | flutter_staggered_grid_view |
| **Logging**          | logger                      |

## 📁 Project Structure

```
lib/
├── main.dart                 # App entrypoint & providers
├── models/                   # Data models (Webtoon, etc.)
├── providers/                # API providers & theme
│   ├── jikan_provider.dart
│   ├── kitsu_provider.dart
│   ├── mangadex_provider.dart
│   └── webtoon_provider.dart
├── screens/                  # Main UI screens
│   ├── home_tab.dart
│   ├── library_tab.dart
│   ├── categories_tab.dart
│   ├── profile_tab.dart
│   └── detail_screen.dart
├── services/                 # API & business logic
│   ├── api_service.dart
│   └── tag_service.dart
└── widgets/                  # Reusable components
    └── webtoon_card.dart
```

## 🚀 Quick Start

**Important**: Always run Flutter commands from the project root (`c:/API-SYSTEM/webtoon`):

```bash
# Navigate to project & install dependencies
cd webtoon && flutter pub get

# Run in debug mode
cd webtoon && flutter run

# Build for release
cd webtoon && flutter build apk --release
# or
cd webtoon && flutter build ios --release
```

### Development Workflow

```
cd webtoon && flutter pub get
cd webtoon && flutter run -d chrome  # Web
cd webtoon && flutter run           # Mobile emulator
```

## 🔧 Environment Setup

1. **Flutter SDK**: `^3.10.7`
2. **Run `flutter doctor`**: Ensure Android/iOS/web setups complete
3. **Hive Initialization**: Auto-handled in `main.dart`
4. **Assets**: Fonts (Comic Neue) & images in `assets/`

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows/macOS/Linux (desktop)

## 🔮 APIs Used

1. **Jikan (MyAnimeList)**: Anime/manga data, characters, episodes
2. **Kitsu**: Alternative anime/manga source
3. **Mangadex**: Manga reading platform integration
4. **Webtoon**: Naver Webtoon specific content

## 🎨 Customization

- **Theme**: Modify `theme_provider.dart`
- **Assets**: Add to `assets/` and `pubspec.yaml`
- **New Provider**: Extend provider pattern for additional APIs
- **Fonts**: Comic Neue included, add more in `pubspec.yaml`

## 🐛 Troubleshooting

| Issue                   | Solution                                         |
| ----------------------- | ------------------------------------------------ |
| `No pubspec.yaml found` | Prefix with `cd webtoon &&`                      |
| `Hive init error`       | Delete app data, restart                         |
| Network fails           | Check API rate limits                            |
| Build fails             | `cd webtoon && flutter clean && flutter pub get` |

## 📈 Future Roadmap

- [ ] User authentication & sync
- [ ] Reading progress tracking
- [ ] Push notifications
- [ ] Social sharing
- [ ] Advanced search with filters

## 🤝 Contributing

1. Fork & create feature branch
2. `flutter format .`
3. `flutter analyze`
4. Submit PR

---

**Built with ❤️ for webtoon & anime fans!**
