# 🌊 Point Nemo – Maritime Services & Fleet Booking Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![GetX](https://img.shields.io/badge/State-GetX-8A2BE2)](https://pub.dev/packages/get)
[![Socket.IO](https://img.shields.io/badge/RealTime-Socket.IO-black?logo=socketdotio&logoColor=white)](https://socket.io)
[![Stripe](https://img.shields.io/badge/Payment-Stripe-635BFF?logo=stripe&logoColor=white)](https://stripe.com)
[![Firebase](https://img.shields.io/badge/Firebase-FCM-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%26%20Android-lightgrey?logo=apple&logoColor=white)](https://flutter.dev)
[![Version](https://img.shields.io/badge/Version-1.0.1-blue)](pubspec.yaml)

**Point Nemo** is a production-ready, multi-role cross-platform mobile application (iOS & Android) built for the maritime industry. It connects **Customers**, **Boat/Fleet Owners**, and **Captains** on a single platform — enabling on-demand water activities, vessel rentals, captain hiring, and real-time communication.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture](#-architecture)
- [Tech Stack](#%EF%B8%8F-tech-stack)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Environment Setup](#-environment-setup)
- [Core Services](#-core-services)

---

## 🧭 Overview

Point Nemo is designed around **three distinct user roles**, each with its own isolated feature flow and shared core services:

| Role | Primary Actions |
|------|----------------|
| 🏄 **Customer** | Discover activities, book boats, chat with owners, manage bookings |
| 🏢 **Business Owner** | Register boats, create services, hire captains, manage fleet bookings |
| ⚓ **Captain** | Accept trip assignments, manage availability, track earnings |

All roles share a unified real-time chat system, push notification layer, and bilingual UI.

---

## ✨ Key Features

### 🏄 Customer Flow
- **Activity & Boat Discovery** — Browse water sports, boat rentals, and nautical courses with rich detail pages
- **Search & Filter** — Find vessels by type, capacity, price range, and amenities
- **Booking & Payments** — Seamless in-app checkout powered by **Stripe**, with instant booking confirmation and refund requests
- **Favorites** — Save and revisit preferred services and boats

### 🏢 Business Owner Flow
- **Fleet Management** — Register and manage boats with full specifications, image galleries, and availability calendars
- **Service Creation** — Create and publish custom maritime packages, excursions, and water sport activities
- **Captain Hiring** — Browse certified captain profiles and assign them to upcoming trips
- **Booking Management** — Accept or decline incoming customer bookings with real-time status tracking

### ⚓ Captain Flow
- **Trip Schedules** — View and manage all assigned and incoming trip requests
- **Booking Actions** — Accept or reject bookings and control availability
- **Profile Management** — Maintain captain profile with certifications and experience

### 💬 Shared Features
- **Real-Time Chat** — Live messaging powered by **Socket.IO** with typing indicators, conversation history, and connection recovery
- **Push Notifications** — Background and foreground alerts via **Firebase Cloud Messaging (FCM)** with local notification support
- **Multi-Provider Auth** — Email/OTP, **Google Sign-In**, and **Sign in with Apple** with JWT token auto-refresh
- **Bilingual Support** — Dynamic **English & Arabic (RTL/LTR)** localization with runtime language switching
- **Role Switcher** — Users can switch roles (Customer ↔ Business Owner ↔ Captain) from a shared role-selection screen

---

## 🏛️ Architecture

The app follows a **feature-first clean architecture** with GetX for state management and dependency injection:

```
lib/
├── main.dart               # App entry point & Firebase/Dotenv init
├── app.dart                # Root MaterialApp with GetX routing & localization
├── core/                   # Shared infrastructure (DI-agnostic)
│   ├── services/           # Singleton services (Network, Socket, Auth, Storage)
│   ├── models/             # Shared data models (ResponseData, etc.)
│   ├── bindings/           # Global GetX dependency bindings
│   ├── localization/       # ARB-based i18n (EN + AR)
│   ├── custom/             # Custom widgets & UI components
│   └── utils/              # Helpers, logger, extensions
├── features/               # Feature modules (isolated by role)
│   ├── .common/            # Cross-role features (Chat, Profile, Notifications, Nav)
│   ├── _user_flow/         # Customer: Home, Explore, Search, Bookings
│   ├── _business_owner_flow/ # Owner: Home, Fleet, Services, Bookings, Favorites
│   ├── _captain_flow/      # Captain: Home, Bookings, Profile
│   ├── authentication/     # Login, Register, OTP, Forgot Password
│   ├── onboarding/         # Onboarding screens
│   ├── splash/             # Splash screen & initialization
│   ├── welcome/            # Welcome / landing screen
│   └── stripe_payment/     # Stripe WebView payment integration
└── routes/                 # Named route definitions & GetX pages
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.9+ / Dart 3.9+ |
| **State Management** | GetX (Controllers, `Obx` reactive bindings, `Bindings`) |
| **Networking** | `http` — REST with JWT Bearer auth, multipart uploads, full CRUD |
| **Real-Time** | `socket_io_client` — WebSocket chat with pending-join queue |
| **Authentication** | Firebase Auth, Google Sign-In, Sign in with Apple, OTP |
| **Payments** | Stripe Gateway via WebView integration |
| **Push Notifications** | Firebase Cloud Messaging + Flutter Local Notifications |
| **Local Storage** | `shared_preferences` for token/session persistence |
| **Localization** | Flutter `flutter_localizations` + ARB files (EN/AR RTL) |
| **Image Handling** | `image_picker`, `file_picker`, `cached_network_image` |
| **Secrets** | `flutter_dotenv` for secure API key management |
| **UI / UX** | `google_fonts`, `flutter_svg`, `shimmer`, `pinput`, `flutter_spinkit` |

---

## 📁 Project Structure

```
point_nemo_service_and_activities/
├── lib/                    # Dart source code
├── assets/
│   ├── images/             # App imagery
│   ├── icons/              # SVG & PNG icons
│   └── logos/              # App logo variants (used for launcher icons)
├── android/                # Android-specific configuration
├── ios/                    # iOS-specific configuration
├── pubspec.yaml            # Dependencies & flutter configuration
├── l10n.yaml               # Localization configuration
├── firebase.json           # Firebase project config
├── .env_example            # Environment variable template
└── analysis_options.yaml   # Dart lint rules
```

---

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/Saniat-Injam/point_nemo_service_and_activities.git
cd point_nemo_service_and_activities

# 2. Install Flutter dependencies
flutter pub get

# 3. Set up environment variables
cp .env_example .env
# Edit .env and fill in your Firebase API keys

# 4. Run the app
flutter run
```

---

## 🔐 Environment Setup

Create a `.env` file at the project root (copy from `.env_example`):

```env
Firebase_android_api_key = "Your Firebase Android API Key"
Firebase_ios_api_key     = "Your Firebase iOS API Key"
Firebase_web_api_key     = "Your Firebase Web API Key"
```

> ⚠️ **Never commit `.env` to version control.** It is already listed in `.gitignore`.

You will also need to add:
- `android/app/google-services.json` — Firebase Android config
- `ios/Runner/GoogleService-Info.plist` — Firebase iOS config
- `lib/firebase_options.dart` — generated via `flutterfire configure`

---

## ⚙️ Core Services

### `NetworkCaller`
A robust HTTP client wrapping the `http` package with:
- **Full CRUD** — `GET`, `POST`, `PUT`, `PATCH`, `DELETE`
- **Multipart uploads** — single and multi-file support with MIME detection
- **JWT Auth** — automatic Bearer token injection from `StorageService`
- **Auto token refresh** — on 401 responses, silently refreshes the access token before logging out
- **Structured error handling** — typed `ResponseData` model with status codes and messages

### `SocketService` (GetX Singleton)
A resilient Socket.IO client with:
- WebSocket transport with JWT auth headers
- **Pending-join queue** — queues `join-conversation` events if emitted before connection is established
- Observable `isConnected` state for reactive UI updates
- Listener cleanup (`clearListeners`) to prevent duplicate callbacks
- Events: `join-conversation`, `conversation-joined`, `send-message`, `new-message`, `user-typing`

### `StorageService`
Persistent session management via `shared_preferences`:
- Access & refresh token storage with auto-refresh on expiry
- User profile caching

### Auth Services
- **`GoogleAuthService`** — Google Sign-In with Firebase credential linking
- **`AppleAuthService`** — Sign in with Apple with nonce generation
- **`FirebaseMessagingService`** — FCM token registration and background message handling
- **`LocalNotificationService`** — Foreground notification display

---

## 🌐 Localization

The app supports **English** and **Arabic (RTL)** out of the box, with:
- ARB-based translation files managed by `flutter_localizations`
- Runtime language switching without app restart
- Automatic RTL layout direction for Arabic users

---

*Built with Flutter — cross-platform from a single codebase.*
