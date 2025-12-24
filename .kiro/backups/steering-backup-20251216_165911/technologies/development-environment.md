**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 10 December 2025

---

---

inclusion: fileMatch
fileMatchPattern: 'pubspec.yaml|analysis_options.yaml|\*.dart'

---

# Flutter Development Environment Setup

## Local Development Setup

- Install Flutter SDK 3.35.5+ from flutter.dev
- Install Dart SDK 3.9.2+ (included with Flutter)
- Use `flutter pub get` for dependency management
- Run `flutter analyze` and `dart format` before committing changes

## Development Tools

- **Android Studio**: Recommended IDE with Flutter plugin
- **VS Code**: Alternative with Flutter and Dart extensions
- **Flutter DevTools**: For debugging and performance analysis
- **Dart DevTools**: For advanced debugging and profiling

## Environment Variables

- Use `.env` files for configuration (never commit to git)
- Store sensitive data in `flutter_secure_storage`
- Document all required environment variables in README
- Use different configurations for debug/release builds

## Local Database Management (Isar)

- Use Isar for local-first data storage
- Define schemas with proper indexing
- Use transactions for related operations
- Implement proper error handling for database operations

## Build and Deployment

- Use `flutter build` commands for different platforms
- Ensure builds are reproducible with locked dependencies
- Test on both debug and release builds
- Document platform-specific build requirements

## Debugging and Logging

- Use Flutter's built-in logging capabilities
- Implement proper error handling with try-catch blocks
- Use Flutter Inspector for widget debugging
- Set up crash reporting for production builds
