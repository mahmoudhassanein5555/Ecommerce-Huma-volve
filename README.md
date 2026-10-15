# Ecommerce Huma-volve

A Flutter e-commerce demo using the Platzi Fake Store API.

## Architecture

Auth and Home follow Clean Architecture:

- `domain`: framework-independent entities, repository contracts, and use cases.
- `data`: API data sources, response models, and repository implementations.
- `presentation`: screens and Provider-based state management.

The shared product entity is in `lib/core/domain/entities/product.dart`. API
response parsing is kept in the Home data layer.

## API

The API base URL is configured in `lib/core/network/api_client.dart`.

- Auth: `POST /auth/login`, `GET /auth/profile`, and `POST /users`.
- Home: `GET /products` and `GET /categories`.

The access token and signed-in session are held in memory; they are not
persisted between app launches.

## Run

```shell
flutter pub get
flutter run
```

Run tests and static analysis with:

```shell
flutter test
flutter analyze
```
