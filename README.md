# ecommerce_app_huma_volve

A new Flutter project.

## Product deep links

The home screen loads products and categories from the EscuelaJS API. On
Android, open a product directly with a link in the form
`ecommerce://product/<id>`, where `<id>` is a product ID returned by that API.
For example:

```powershell
adb shell am start -a android.intent.action.VIEW -d "ecommerce://product/1"
```

Products without API-provided color or size options do not show those selectors.
This API is a public demo store, not a private production catalog.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
