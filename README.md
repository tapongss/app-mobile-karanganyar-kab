# SAKTI Karanganyar (prototipe)

Super app layanan publik digital Pemkab Karanganyar (Flutter).

## Menjalankan
```bash
flutter create --org id.ac.telkomuniversity --project-name sakti_karanganyar .
flutter pub get
flutter run
```
(`flutter create .` hanya menambah folder android/ios; file `lib/` dan `pubspec.yaml` tidak ditimpa.)

Android 11+: tambahkan di `android/app/src/main/AndroidManifest.xml` (di atas `<application>`):
```xml
<queries>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
</queries>
```

## Struktur
- `lib/data/catalog_data.dart` : data katalog & kantor (edit di sini). Cari `TODO`.
- `lib/data/service_repository.dart` : antarmuka sumber data; ganti ke API saat disetujui.
- `lib/screens/` : beranda, katalog, detail, kantor, akun, pencarian.

## Roadmap
1. Login SSO SAKTI (`flutter_appauth`) 2. Pelacakan status permohonan 3. Notifikasi FCM
4. Multibahasa 5. Speech-to-text 6. Chatbot FAQ 7. Anti-hoax
