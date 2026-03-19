# Simplified Architecture – Model, Service, Screen, Bloc

A streamlined feature structure that keeps Clean Architecture principles while reducing folder depth.

---

## Standard Feature Structure

Every feature follows the same four folders:

```
feature_name/
├── model/       # Data models, entities, DTOs
├── service/     # API calls, repositories, data access
├── screen/      # UI screens and widgets
└── bloc/        # Bloc, events, states
```

---

## Folder Responsibilities

### `model/`
- **Purpose:** Data structures used by the feature
- **Contents:**
  - Entity classes (e.g. `TokenModel`, `OrderModel`)
  - Request/response DTOs
  - Enums used by the feature
- **Example:** `auth/model/token_models.dart`

### `service/`
- **Purpose:** Data access and business logic
- **Contents:**
  - API calls (via Dio or other clients)
  - Repository implementations
  - Local storage (SharedPreferences, etc.)
- **Example:** `auth/service/auth_repository.dart`

### `screen/`
- **Purpose:** UI
- **Contents:**
  - Screens and pages
  - Feature-specific widgets
- **Example:** `auth/screen/signin_screen.dart`

### `bloc/`
- **Purpose:** State management
- **Contents:**
  - Bloc class
  - Events
  - States
- **Example:** `auth/bloc/auth_bloc.dart`, `auth_event.dart`, `auth_state.dart`

---

## Project Layout

```
lib/
├── core/                    # Shared (theme, responsive, widgets)
├── config/                  # Routes, Dio, theme wiring
├── common/                  # Constants, utils, shared widgets
│
├── auth/
│   ├── model/               # token_models, user_type_enum
│   ├── service/             # auth_repository
│   ├── screen/              # signin_screen, signup_screen
│   └── bloc/                # auth_bloc, auth_event, auth_state
│
├── features/
│   ├── app_init/
│   │   ├── model/           # (if needed)
│   │   ├── service/         # app_init_repository
│   │   ├── screen/          # app_init_screen
│   │   └── bloc/            # app_init_bloc, events, state
│   │
│   ├── dashboard/
│   │   ├── model/
│   │   ├── service/
│   │   ├── screen/          # dashboard_view, profile_view
│   │   └── bloc/
│   │
│   ├── notification/
│   │   ├── model/           # notification_model
│   │   ├── service/         # notification_repository
│   │   ├── screen/          # notification_view
│   │   └── bloc/            # notification_bloc
│   │
│   ├── order/
│   │   ├── model/           # order_model
│   │   ├── service/         # order_repository
│   │   ├── screen/          # my_order_view
│   │   └── bloc/            # order_bloc
│   │
│   ├── add_customer/
│   │   ├── model/           # add_customer_model
│   │   ├── service/         # add_customer_service
│   │   ├── screen/          # add_customer_screen
│   │   └── bloc/            # add_customer_bloc
│   │
│   └── otp/
│       ├── model/           # otp_generate_model, otp_verification_state
│       ├── service/         # otp_service, add_customer_service
│       ├── screen/          # otp_verification_screen
│       └── bloc/            # otp_bloc, otp_event, otp_state
│
└── main.dart
```

---

## Dependency Flow

```
screen → bloc → service → model
```

- **Screen** uses Bloc for state and navigation
- **Bloc** calls Service for data and emits States
- **Service** uses Models for request/response and persistence

---

## Migration from Current Structure

| Old Path                    | New Path              |
|----------------------------|------------------------|
| `domain/entities/*`        | `model/*`              |
| `domain/repositories/*`    | `service/*` (interface + impl) |
| `data/datasources/*`       | `service/*`            |
| `data/repositories/*`      | `service/*`            |
| `presentation/screen/*`    | `screen/*`             |
| `presentation/bloc/*`      | `bloc/*`               |
| `view_model/*`             | `bloc/*`               |
| `views/*`                  | `screen/*`             |

---

## Implemented Features

- **auth/** – Fully migrated to `model/`, `service/`, `screen/`, `bloc/`
- **features/app_init/** – Fully migrated to `model/`, `service/`, `screen/`, `bloc/`

Legacy re-exports remain at `auth/views/`, `auth/repository/`, `auth/view_model/`, `auth/models/`, `auth/enums/` for backward compatibility.
