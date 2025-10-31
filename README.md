# Note App Turbo - Flutter

Modern not uygulaması - Firebase Authentication, FastAPI backend ve offline-first mimari ile.

## ✨ Özellikler

- 🔐 **Firebase Authentication** - Email/Password ile güvenli giriş
- 📝 **CRUD Operations** - Not oluştur, düzenle, sil
- 📌 **Pin to Top** - Önemli notları üstte sabitle
- 🔍 **Search** - Başlık ve içerikte arama
- 💾 **Offline Support** - Hive ile local caching
- 🎨 **Modern UI** - Clean ve responsive tasarım
- 🔄 **Auto Sync** - Otomatik senkronizasyon
- ↩️ **Undo Delete** - Silinen notları geri al

## 🛠️ Teknolojiler

- **Flutter 3.9+** - Cross-platform framework
- **Bloc/Cubit** - State management
- **Firebase Auth** - Authentication
- **Dio** - HTTP client
- **Hive** - Local database (offline support)
- **GetIt** - Dependency injection
- **Equatable** - Value equality
- **Kartal** - Utility extensions

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── di/              # Dependency injection (GetIt)
│   └── network/         # API client (Dio + interceptors)
├── feature/
│   ├── auth/            # Login & Register
│   │   └── bloc/        # Auth Cubit
│   ├── home/            # Notes list & CRUD
│   │   └── bloc/        # Notes Cubit
│   └── splash/          # Splash screen
├── product/
│   ├── constants/       # App constants
│   ├── initialize/      # App initialization
│   ├── models/          # Data models
│   └── service/         # API services
└── main.dart
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

### Authentication
- Firebase email/password authentication
- Auto login (token persistence)
- Logout functionality

### Notes Management
- Create, read, update, delete notes
- Pin/unpin important notes
- Real-time search
- Sorted by pinned status & update time

### Offline Support
- Hive local database
- Automatic sync when online
- Fallback to cache when offline

### Error Handling
- Token refresh on 401
- Retry mechanism
- User-friendly error messages

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
  firebase_core: ^3.15.2
  firebase_auth: ^5.2.0
  dio: ^5.7.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_bloc: ^9.0.0
  equatable: ^2.0.5
  get_it: ^7.7.0
  flutter_dotenv: ^5.1.0
  kartal: ^3.5.0

dev_dependencies:
  flutter_lints: ^5.0.0
  very_good_analysis: ^7.0.0
```

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
