# mart_erp - Architecture Documentation

This document describes the refactored architecture following Clean Architecture principles and design patterns from [SourceMaking Design Patterns](https://sourcemaking.com/design_patterns).

## Overview

The application follows a **feature-wise structure** with shared **core** module, emphasizing:
- Separation of concerns (presentation, domain, data)
- Design patterns for maintainability and scalability
- Responsive UI with dark/light theming
- OOP principles (encapsulation, abstraction)

---

## Project Structure

```
lib/
├── core/                    # Shared foundation
│   ├── domain/              # Domain contracts
│   │   └── repositories/    # Repository interfaces
│   ├── theme/               # Theming system
│   │   ├── app_color_palette.dart   # Color semantics
│   │   ├── app_typography.dart      # Typography scale
│   │   ├── app_spacing.dart         # Spacing constants
│   │   ├── theme_strategy.dart      # Strategy pattern
│   │   └── app_theme_config.dart    # Theme resolution
│   ├── responsive/          # Layout utilities
│   │   ├── breakpoints.dart
│   │   └── responsive_builder.dart
│   └── widgets/             # Reusable UI
│       └── responsive_container.dart
├── config/                  # App configuration
│   ├── routes/
│   ├── theme/               # Theme wiring
│   └── dio/                 # HTTP client (Factory pattern)
└── features/                # Feature modules
    ├── auth/
    ├── dashboard/
    ├── notification/
    ├── order/
    └── ...
```

---

## Design Patterns Applied

| Pattern | Location | Purpose |
|---------|----------|---------|
| **Repository** | `ThemeRepository`, `AuthRepository`, etc. | Abstracts data sources; implementations in data layer |
| **Factory** | `DioClientFactory` | Centralized Dio client creation with configurable interceptors |
| **Strategy** | `ThemeStrategy`, `LightThemeStrategy`, `DarkThemeStrategy` | Encapsulates theme selection algorithm |
| **Singleton** | Dio clients, `ThemeNotifier` | Single instance for app-wide services |
| **Observer** | `ValueNotifier` in ThemeNotifier | Notifies UI of theme changes |

---

## Theming System

### Color Palettes
- **LightColorPalette**: Primary green (#008A3F), fresh background (#EFF3ED)
- **DarkColorPalette**: Light green accent (#95E0A5), dark background (#181F1B)

### Typography
- Material 3 text scale (displayLarge through labelSmall)
- Semantic color binding (onSurface, onBackground)

### Spacing
- 4px grid: xs(4), sm(8), md(16), lg(24), xl(32), xxl(48)

### Theme Toggle
- Accessible from Profile tab app bar
- Persisted via SharedPreferences
- Animated transition (300ms)

---

## Responsive Design

### Breakpoints
| Type | Width |
|------|-------|
| Mobile | < 600px |
| Tablet | 600-840px |
| Desktop | 840-1200px |
| Wide | > 1200px |

### Usage
```dart
ResponsiveBuilder(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

---

## State Management

- **BLoC** for feature-level state (Auth, Order, Notification, etc.)
- **ValueNotifier** for theme and local UI state
- **Repository pattern** for data access

---

## Dependencies

Key packages: `flutter_bloc`, `dio`, `equatable`, `fpdart`, `sizer`, `flutter_screenutil`

---

## Future Refactoring

1. **Domain layer per feature**: Add use cases and entity interfaces
2. **Dependency Injection**: Consider `get_it` or `injectable` for cleaner DI
3. **Feature modules**: Isolate features with clear boundaries
