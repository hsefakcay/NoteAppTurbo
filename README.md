# Note App Turbo - Flutter

Modern not uygulaması - Firebase Authentication, FastAPI backend ve offline-first mimari ile.

## 🎬 Demo

> https://drive.google.com/file/d/1fs61tjXk6veBm26maLLRoaYU1S69C5kZ/view?usp=sharing

## ✨ Özellikler

### 🎯 Temel Özellikler
- 🔐 **Firebase Authentication** - Email/Password ile güvenli giriş
- 📝 **CRUD Operations** - Not oluştur, düzenle, sil
- 📌 **Pin to Top** - Önemli notları üstte sabitle
- 🔍 **Search & Filter** - Başlık ve içerikte arama, sıralama
- 💾 **Offline-First** - Hive ile local caching ve otomatik sync
- 🎨 **Modern UI** - Material Design 3 ile responsive tasarım
- ↩️ **Undo Delete** - Silinen notları geri al

### 🤖 AI Özellikleri
- ✨ **AI-Powered Flashcards** - Notlarınızdan otomatik öğrenme kartları oluşturun
- 🧠 **Smart Learning** - Yapay zeka destekli içerik analizi

### 🌍 Çok Dilli Destek
- 🇹🇷 **Türkçe** - Tam Türkçe arayüz
- 🇬🇧 **English** - Full English interface
- 🔄 **Runtime Switching** - Uygulama içinden dil değiştirme
- 📝 **Localized Errors** - Çok dilli hata mesajları

### 🎨 UI/UX
- 🌓 **Dark/Light Mode** - Sistem teması ile otomatik geçiş
- 📱 **Responsive Design** - Tüm ekran boyutları için optimize
- 🎭 **Modern Dialogs** - Material Design 3 uyumlu diyaloglar
- 🎯 **Onboarding** - İlk kullanıcılar için rehber ekranı
- 🎨 **Gradient Buttons** - Modern görsel hiyerarşi

## 🛠️ Teknolojiler

### Core
- **Flutter 3.9+** - Cross-platform framework
- **Bloc/Cubit** - State management
- **Firebase Auth** - Authentication
- **Dio** - HTTP client with interceptors
- **Hive** - Local database (offline-first)
- **GetIt** - Dependency injection (Clean Architecture)

### UI/UX
- **Kartal** - Responsive utility extensions
- **Easy Localization** - i18n support
- **Smooth Page Indicator** - Onboarding indicators

### Code Quality
- **Equatable** - Value equality
- **Very Good Analysis** - Strict linting
- **Flutter Lints** - Best practices

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── di/                    # Dependency injection (GetIt)
│   └── network/               # API client (Dio + interceptors)
├── feature/
│   ├── auth/                  # Login & Register
│   │   └── bloc/              # Auth Cubit
│   ├── home/                  # Notes list & CRUD
│   │   ├── bloc/              # Notes & Flashcard Cubits
│   │   ├── dialogs/           # Flashcard dialog
│   │   └── widgets/           # Note cards, search, filters
│   ├── onboarding/            # First-launch onboarding
│   ├── settings/              # Settings & theme
│   │   ├── bloc/              # Settings Cubit
│   │   ├── dialogs/           # Theme, language dialogs
│   │   └── widgets/           # Settings sections
│   └── splash/                # Splash screen
├── product/
│   ├── constants/             # App constants & routes
│   ├── initialize/            # App initialization
│   ├── models/                # Data models (Note, Flashcard, etc.)
│   ├── routes/                # App router
│   ├── service/               # API & local services
│   └── widgets/               # Shared widgets
└── main.dart

assets/
├── env/
│   └── .env                   # Environment variables
└── translations/
    ├── tr.json                # Turkish translations
    └── en.json                # English translations
```

## ⚙️ Kurulum

### 1. Gereksinimleri Kontrol Et

- Flutter SDK 3.9 veya üzeri
- Dart SDK 3.0 veya üzeri
- Firebase projesi (authentication aktif)

### 2. Bağımlılıkları Yükle

```bash
flutter pub get
```

### 3. Firebase Yapılandırması

#### Android

`android/app/google-services.json` dosyasını Firebase Console'dan indir ve yerleştir.

#### iOS

`ios/Runner/GoogleService-Info.plist` dosyasını Firebase Console'dan indir ve yerleştir.

### 4. Environment Dosyası

`assets/env/.env` dosyası oluştur:

```env
API_BASE_URL=http://127.0.0.1:8000
API_PATH_PREFIX=/api
```

**Not:** 
- Android Emulator için: `http://10.0.2.2:8000`
- iOS Simulator için: `http://127.0.0.1:8000`

## 🏃 Çalıştırma

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Belirli cihaz
flutter run -d chrome  # Web
flutter run -d macos   # macOS
```

## 🏗️ Build

### Android APK

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 🧪 Test

```bash
# Tüm testleri çalıştır
flutter test

# Belirli test dosyası
flutter test test/widget_test.dart
```

## 📱 Özellikler Detayı

### 🎯 Onboarding Flow
- **Welcome Screen** - Uygulama tanıtımı
- **AI Flashcard Highlight** - AI özelliğinin tanıtımı
- **Sync Info** - Cloud senkronizasyon bilgisi
- **Call-to-Action** - Login/Register yönlendirmesi
- **Skip Option** - İsteğe bağlı atlama
- **Hive Storage** - Onboarding durumu kalıcı olarak saklanır

### 🌍 Localization System
- **Runtime Language Switching** - Uygulama yeniden başlatmaya gerek yok
- **JSON-based Translations** - Kolay yönetilebilir çeviri dosyaları
- **Context-aware** - Easy Localization ile güçlü i18n
- **Comprehensive Coverage** - Tüm UI, validations, errors localized
- **Persistent Selection** - Dil seçimi kaydedilir

### 🤖 AI-Powered Flashcards
- **Automatic Generation** - Notlardan otomatik flashcard oluşturma
- **Smart Analysis** - AI ile içerik analizi
- **Interactive Learning** - Soru-cevap formatı
- **Swipeable Cards** - Modern kart geçiş animasyonları
- **Progress Tracking** - Flashcard ilerleme takibi

### 🔐 Authentication
- Firebase email/password authentication
- Auto login (token persistence)
- Logout functionality
- Localized error messages

### 📝 Notes Management
- Create, read, update, delete notes
- Pin/unpin important notes
- Real-time search & filter
- Multiple sort options (date, title, pinned)
- Undo delete with SnackBar
- Modern bottom sheet for note editing

### 💾 Offline-First Architecture
- Hive local database
- Automatic background sync
- Sync queue for offline actions
- Fallback to cache when offline
- Network connectivity monitoring

### 🎨 Modern UI
- Material Design 3 components
- Dark/Light/System theme modes
- Responsive design with Kartal
- Gradient buttons
- Modern dialogs with icons
- Smooth animations and transitions

### 🔧 Error Handling
- Token refresh on 401
- Retry mechanism for failed requests
- Localized user-friendly error messages
- Offline error fallbacks

## 🔧 Mimari

### State Management: Bloc/Cubit

```dart
// Example: Notes Cubit
class NotesCubit extends Cubit<NotesState> {
  // Online-first with offline fallback
  Future<void> loadNotes() async {
    try {
      final remote = await _service.fetchNotes();
      await _cacheNotes(remote);
      emit(state.copyWith(notes: remote));
    } catch (e) {
      final cached = await _getCachedNotes();
      emit(state.copyWith(notes: cached));
    }
  }
}
```

### Dependency Injection: GetIt

```dart
final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton(() => ApiClient());
  serviceLocator.registerLazySingleton(() => NoteService(serviceLocator()));
}
```

## 🌐 Backend Gereksinimleri

Bu uygulama Note App Turbo Backend API'ye ihtiyaç duyar:

- Backend repository: `../note_app_backend`
- API base URL: `http://127.0.0.1:8000`
- Endpoints: `/api/notes`

Backend kurulumu için `../note_app_backend/README.md` dosyasına bakın.

## 📦 Kullanılan Paketler

```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # Firebase
  firebase_core: ^3.15.2
  firebase_auth: ^5.2.0

  # Networking
  dio: ^5.7.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # State Management
  flutter_bloc: ^9.0.0
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^7.7.0

  # Utilities
  flutter_dotenv: ^5.1.0
  kartal: ^3.5.0

  # Localization
  easy_localization: ^3.0.7

  # UI Components
  smooth_page_indicator: ^1.2.0+3

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Linting
  flutter_lints: ^5.0.0
  very_good_analysis: ^7.0.0
  
  # Code Generation
  build_runner: ^2.4.13
  hive_generator: ^2.0.1
```

## 📸 Ekran Görüntüleri

> Ekran görüntüleri eklenecek

### Ana Özellikler
- 🎯 Onboarding akışı (4 ekran)
- 📝 Not listesi (Light/Dark mode)
- ✏️ Not düzenleme (Modern bottom sheet)
- 🤖 AI Flashcard dialog
- ⚙️ Ayarlar ekranı
- 🌍 Dil değiştirme
- 🎨 Tema seçimi

## 📝 Changelog

### v2.0.0 (Latest) - Localization & Onboarding
- ✨ Full localization support (TR/EN)
- 🎯 Modern onboarding flow
- 🤖 AI-powered flashcards
- 🎨 Material Design 3 UI improvements
- 📱 Responsive design with Kartal
- 🌓 Enhanced dark mode
- 🎭 Modern dialogs
- 🔧 Hive-based settings storage

### v1.0.0 - Initial Release
- 🔐 Firebase Authentication
- 📝 CRUD operations for notes
- 💾 Offline-first architecture
- 🔄 Auto sync
- 📌 Pin to top
- 🔍 Search functionality

## 🐛 Sorun Giderme

### Backend'e Bağlanamıyorum

1. Backend'in çalıştığından emin olun
2. `.env` dosyasındaki URL'yi kontrol edin
3. Android emulator için `10.0.2.2` kullanın

### Firebase Authentication Hatası

1. `google-services.json` / `GoogleService-Info.plist` dosyalarını kontrol edin
2. Firebase Console'da Email/Password authentication'ın aktif olduğundan emin olun
3. Firebase proje ID'sini kontrol edin

### Hive Box Hatası

```bash
# Cache'i temizle
flutter clean
flutter pub get
```

## 📚 Daha Fazla Bilgi

- [Flutter Documentation](https://flutter.dev/docs)
- [Bloc Library](https://bloclibrary.dev)
- [Firebase Flutter](https://firebase.flutter.dev)
- [Dio Package](https://pub.dev/packages/dio)
- [Hive Database](https://docs.hivedb.dev)

## 👥 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing`)
5. Pull Request açın

## 📄 Lisans

MIT License
