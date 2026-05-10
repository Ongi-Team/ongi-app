# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**온기 (Ongi)** — a Flutter app connecting elderly users with their guardians/caregivers. The app has two distinct user flows: one for guardians (3-tab nav) and one for elderly users (2-tab nav).

## Commands

```bash
# Run the app
flutter run

# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Static analysis
flutter analyze

# Build
flutter build ios --release
flutter build apk --release
```

> **iOS:** After changing native dependencies, run `pod install` inside `ios/`.

## Environment Setup

A `.env` file in the project root is required (not committed to git):
```
base_url=https://ongi-smartcare.site/
```

## Architecture

**Layer structure:**
- `lib/core/` — DI setup (`get_it`), routing (`go_router`), design constants
- `lib/data/` — API client (`dio`), repositories, services, DTOs
- `lib/domain/` — business logic services (prepared, mostly empty)
- `lib/features/` — feature modules (auth, guardian, elder)
- `lib/shared/` — shared widgets used across features

**State management:** Provider (`ChangeNotifier`) with a ViewModel-per-screen pattern. ViewModels are registered via `ChangeNotifierProvider` at the screen or shell level. When a ViewModel must span multiple screens (e.g., multi-step signup), it is hoisted to the parent `ShellRoute`.

**Dependency injection:** GetIt service locator. All singletons (`ApiClient`, `AuthService`, `SecureStorageRepository`) are registered in `lib/core/di/service_locator.dart` and initialized in `main()` before `runApp()`.

**Routing:** GoRouter v14 with `StatefulShellRoute.indexedStack` for persistent tab navigation. Route name constants live in `lib/core/router/routes.dart`.

**API layer:** Dio v5 configured in `lib/data/network/api_client.dart` with two interceptors:
1. **Token interceptor** — injects `Authorization: Bearer <token>` on every request and handles 401 by calling the reissue endpoint and retrying.
2. **Log interceptor** — logs all requests/responses.

Tokens are stored in `flutter_secure_storage` (iOS Keychain / Android Keystore) via `SecureStorageRepository`.

**API constants:** All endpoint path strings live in `lib/core/constants/apis.dart`.

## Design System

- **Primary color:** Orange `#FF752B` (`OngiColor.primary`)
- **Typography:** Pretendard font family (5 weights). Text styles defined in `lib/core/constants/styles.dart` as `OngiTextStyle.*`.
- **Color palette:** `lib/core/constants/colors.dart` — grays (`systemGray01`–`05`), white, success green, fail red.
- **Shared widgets:** `BasicTextField`, `BasicButton`, `BasicAppBar` in `lib/shared/widgets/`.

## Feature Module Conventions

```
features/<feature>/
├── <name>_screen.dart       # UI page
├── <name>_view_model.dart   # ChangeNotifier state
└── <sub_feature>/           # Nested screens/VMs
```

Screens: `*_screen.dart` | ViewModels: `*_view_model.dart` | Services: `*_service.dart` | Repositories: `*_repository.dart`

## Known Incomplete Areas

Several API calls have `// TODO` placeholders still pending integration:
- `LoginViewModel` — actual login API call
- `SignupViewModel` — actual signup API call
- `AuthService` — reissue endpoint URL

Navigation links for "아이디 찾기" (Find ID) and "비밀번호 변경" (Change Password) on the login screen are also unimplemented.
