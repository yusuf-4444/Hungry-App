# 🍔 Hungry - Food Delivery App

A modern food delivery app built with Flutter, Clean Architecture & BLoC pattern.

## Features

- Browse & Search food items with real-time filtering
- Product Customization (spice levels, toppings, side options)
- Smart Cart Management with quantity control
- Multiple Payment Methods (Cash/Card)
- Profile Management & Auto-Login
- Guest Mode for browsing without registration

## Architecture

Clean Architecture with Feature-First structure:

```
lib/
├── core/
│   ├── network/        # Dio, Retrofit, API services
│   ├── di/             # Dependency Injection
│   └── constants/      # App constants
├── features/
│   ├── auth/           # Authentication
│   ├── home/           # Food listing
│   ├── product/        # Product details
│   ├── cart/           # Cart management
│   └── checkout/       # Order placement
└── shared/             # Reusable widgets
```

## Tech Stack

- **Flutter & Dart**
- **BLoC/Cubit** - State Management
- **Retrofit + Dio** - Networking
- **GetIt** - Dependency Injection
- **Freezed** - Code Generation
- **SharedPreferences** - Local Storage

## Network Layer

Type-safe API calls with Retrofit:

```dart
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiServices {
  @GET("/products")
  Future<FoodDataModel> getFood();
}
```

Unified error handling:

```dart
@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  factory ApiResult.success(T data) = Success<T>;
  factory ApiResult.failure(String error) = Failure<T>;
}
```

Smart token management with Dio interceptors.

## State Management

Clean Cubit pattern with smart caching:

```dart
class FoodCubit extends Cubit<FoodState> {
  Future<void> getFood({bool forceRefresh = false}) async {
    if (_hasLoadedData && !forceRefresh) {
      emit(FoodState.success(cachedData));
      return;
    }
    // Fetch from API...
  }
}
```

## Getting Started

```bash
git clone https://github.com/yusuf-4444/Hungry-App.git
cd Hungry-App
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## API

Base URL: `https://sonic-zdi0.onrender.com/api`

Main endpoints: `/products`, `/login`, `/register`, `/cart`, `/orders`

## Key Features

- Clean Architecture implementation
- Smart caching to minimize API calls
- Comprehensive error handling
- Secure token-based authentication
- Pull-to-refresh on all screens
- Skeleton loading states

## Future Enhancements

- Real-time order tracking
- Push notifications
- Payment gateway integration
- Multi-language support

## Author

**Yusuf Mohamed**

- GitHub: [@yusuf-4444](https://github.com/yusuf-4444)
- LinkedIn: [Yusuf Mohamed](https://www.linkedin.com/in/yusuf-mohamed-8a2798306/)

## License

MIT License

---

⭐ Star this repo if you found it helpful!
