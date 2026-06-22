# Mini Katalog Uygulaması

Flutter ile geliştirilmiş, ürünlerin listelenip detaylı olarak görüntülenebildiği, sepete ürün ekleme/çıkarma ve kullanıcı giriş/kayıt işlemlerinin yapılabildiği bir mobil alışveriş uygulaması konseptidir.

## 🚀 Özellikler

- ✅ Kullanıcı kaydı ve giriş işlemleri
- ✅ Ürün listeleme ve detay görüntüleme
- ✅ Sepete ürün ekleme ve çıkarma
- ✅ Arama çubuğu ile ürün filtreleme
- ✅ Derecelendirme puanı ve yıldız gösterimi
- ✅ Promosyon bannerı ile kampanya gösterimi
- ✅ Mock API servisi ile sahte backend davranışı
- ✅ Local storage ile veri persist etme

## 🛠️ Kullanılan Flutter Sürümü

- **Dart SDK Version:** `3.12.2`
- **Flutter Version:** `3.44.2`

## 📦 Kurulum

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

## 📁 Proje Yapısı

```
lib/
|   main.dart
|
+---components
|       custom_text_field.dart
|       product_card.dart
|       promo_banner.dart
|       rating_stars.dart
|       search_bar_widget.dart
|
+---models
|       product_model.dart
|
+---services
|       api_service.dart
|       cart_service.dart
|       local_storage_service.dart
|
\---views
        cart_screen.dart
        home_screen.dart
        login_screen.dart
        product_detail_screen.dart
        register_screen.dart
```

## 🔧 Teknolojiler

- **Dart** - Programlama dili
- **Flutter** - UI toolkit
- **http** - API istekleri için HTTP paketi
- **Local Storage** - Cihaz üzerinde veri saklama

## 👨‍💻 Geliştirici

Fevzi FİDAN
