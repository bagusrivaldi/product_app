# Mini Product App

Mini Product App adalah aplikasi Flutter sederhana yang memiliki fitur authentication, product CRUD, profile, persistent session, dan state management menggunakan Provider.

## Features

- Login menggunakan REST API DummyJSON
- Simpan access token dengan SharedPreferences
- Persistent session
- Auto redirect ke Home jika user sudah login
- Bottom Navigation Bar dengan 5 menu
- Product list
- Search product dengan debounce
- Product detail
- Add product
- Pick image dari gallery
- Edit product
- Delete product
- Profile user
- Logout
- Pull to refresh
- Empty state dan error state
- Skeleton loading
- Reusable widgets
- Material 3 UI

## Tech Stack

- Flutter 3.x
- Dart 3.x
- Provider
- Dio
- Shared Preferences
- Image Picker
- Shimmer

## API

Aplikasi ini menggunakan API dari DummyJSON:

- Auth API: https://dummyjson.com/docs/auth
- Product API: https://dummyjson.com/docs/products

## Test Account

Username: emilys  
Password: emilyspass

## Clone Project

```bash
git clone <repository-url>
cd bagus_project
```

## Install Dependencies

```bash
flutter pub get
```

## Run App

Pastikan device/emulator sudah aktif, lalu jalankan:

```bash
flutter run
```

## Analyze Project

```bash
flutter analyze
```

## Format Code

```bash
dart format .
```

## Build APK Debug

```bash
flutter build apk --debug
```

## Build APK Release

```bash
flutter build apk --release
```

Hasil build APK release ada di:

```txt
build/app/outputs/flutter-apk/app-release.apk
```

## Prebuilt APK

File APK release juga sudah disediakan di repository/project:

```txt
build/app/outputs/flutter-apk/app-release.apk
```

APK berhasil di-build dengan informasi berikut:

```txt
✓ Built build/app/outputs/flutter-apk/app-release.apk (50.5MB)
```

## Build APK Split Per ABI

Untuk ukuran APK yang lebih kecil:

```bash
flutter build apk --split-per-abi
```

Hasil build ada di:

```txt
build/app/outputs/flutter-apk/
```

## Project Structure

```txt
lib/
├── core/
│   ├── api/
│   ├── storage/
│   └── widget/
│
├── feature/
│   ├── auth/
│   ├── home/
│   ├── product/
│   └── profile/
│
└── main.dart
```

## Notes

DummyJSON menggunakan fake CRUD. Data product yang ditambahkan, diedit, atau dihapus tidak benar-benar tersimpan di server. Untuk kebutuhan demo, data baru dikelola melalui state lokal aplikasi.
