# hive_implementation

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## This project

Simple demo using Hive (local DB) and GetX for state/routing.

Features implemented:

- Sign up / Sign in (credentials stored in Hive `users` box)
- Home screen with product list (stored in Hive `products` box)
- Add product: name, image (from gallery), price, expiry date

## How to run

1. Install Flutter SDK and set up your environment.
2. From the project root run:

```bash
flutter pub get
flutter run
```

No code generation is required because TypeAdapters are implemented manually.
