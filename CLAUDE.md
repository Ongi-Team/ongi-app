# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**온기 (Ongi)** — a Flutter app connecting elderly users with their guardians/caregivers. Two distinct user flows after login: guardian (3-tab nav: 홈/일정/설정) and elder (2-tab nav: 홈/설정).

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

Firebase config files also required (not committed):
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart` (generated via `flutterfire configure`)

## Architecture

**Layer structure:**
- `lib/core/` — DI (`get_it`), routing (`go_router`), design constants, enums, utils
- `lib/data/` — API client (`dio`), repositories, services, DTOs (split into `request/` and `response/`)
- `lib/features/` — feature modules (auth, guardian, elder)
- `lib/shared/` — shared widgets and utils

**State management:** Provider (`ChangeNotifier`) with a ViewModel-per-screen pattern. ViewModels are registered via `ChangeNotifierProvider` at screen level. The signup flow hoists `SignupViewModel` to the parent `ShellRoute` so all 4 signup screens share one VM.

**Dependency injection:** GetIt service locator. Singletons registered in `lib/core/di/service_locator.dart` and initialized in `main()` before `runApp()`:
- `SecureStorageRepository` — flutter_secure_storage wrapper (tokens, role, FCM token, user info)
- `ApiClient` — Dio instance with interceptors
- `AuthService` — all auth API calls
- `AuthSession` — in-memory temp store for login credentials during the login→role-select flow

**Routing:** GoRouter v14 with `StatefulShellRoute.indexedStack` for persistent tab navigation. Route constants in `lib/core/router/routes.dart`.

**API layer:** Dio v5 in `lib/data/network/api_client.dart` with two interceptors:
1. **Token interceptor** — injects `Authorization: Bearer <token>` on every request; handles 401 by calling the reissue endpoint and retrying.
2. **Log interceptor** — logs all requests/responses.

All endpoint strings live in `lib/core/constants/apis.dart`. Base URL prefix rule: no leading `/` since `base_url` in `.env` ends with `/`.

## Auth Flow

Login is a two-step process spanning two screens:
1. **LoginScreen** — validates ID/password, stores credentials in `AuthSession` (in-memory singleton), navigates to `RoleSelectScreen`.
2. **RoleSelectScreen** — user selects GUARDIAN or ELDER, then `confirm()` calls the actual `POST /api/auth/login` with `loginMode` + `fcmToken` + `osType`. On success, tokens and user info are saved to `SecureStorageRepository`, `AuthSession` is cleared, and the user is routed to the appropriate shell.

Signup flow: PhoneNumberScreen → AccountInfoScreen → ElderlyInfoScreen → SignupCompleteScreen. All share `SignupViewModel` via the signup `ShellRoute`.

## Firebase / FCM

- `AppDelegate.swift` configures Firebase natively (`FirebaseApp.configure()`) and handles APNS token → FCM delegation.
- `main.dart` calls `Firebase.initializeApp()` to initialize the Flutter-side Firebase binding, then `requestNotificationPermission()`.
- FCM token is fetched after permission grant and saved to `SecureStorageRepository` under key `fcm_token`.
- On iOS, APNS token availability is polled (up to 5× with 1s delay) before requesting the FCM token.
- Requires Push Notifications + Background Modes (Remote notifications) capabilities in Xcode.

## Design System

- **Primary color:** Orange `#FF752B` (`OngiColor.primary`)
- **Typography:** Pretendard font (5 weights). Text styles: `OngiTextStyle.*` in `lib/core/constants/styles.dart`.
- **Color palette:** `lib/core/constants/colors.dart` — `systemGray01`–`05`, white, success green, fail red.
- **Shared widgets:** `BasicTextField`, `BasicButton`, `BasicAppBar`, `CheckActionButton` in `lib/shared/widgets/`.

**`BasicButton` behavior:** `isClickable` controls color only (orange vs gray). Tap-blocking is done by passing `onPressed: null` at the call site — not via `isClickable`.

## Feature Module Conventions

```
features/<feature>/
├── <name>_screen.dart       # UI + ChangeNotifierProvider wrapper
├── <name>_view_model.dart   # ChangeNotifier state
└── <sub_feature>/
```

Screens that scroll use `Expanded(child: SingleChildScrollView(...))` with the primary action button fixed at the bottom via a `Padding` outside the scroll area.

## DTOs

- Request DTOs: `lib/data/dto/request/` — have `toJson()`
- Response DTOs: `lib/data/dto/response/` — have `fromJson()` factory constructors

## Known Incomplete Areas

- `AuthService.reissueToken()` — reissue endpoint URL is a placeholder
- Navigation for "아이디 찾기" and "비밀번호 변경" on the login screen is unimplemented
- Guardian/elder home screens are stubs; schedule and settings screens are `_PlaceholderScreen`
