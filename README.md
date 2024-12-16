# rent_house

A new Flutter project.
3.22.0
## Getting Started

### Build APK:
# Staging
flutter build apk --flavor staging -t lib/main_staging.dart
# Live
flutter build apk --flavor product -t lib/main_product.dart

### Build AAB:
# Live
flutter build appbundle --flavor product -t lib/main_product.dart
# Staging
flutter build appbundle --flavor staging -t lib/main_staging.dart