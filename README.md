# PhysioGhar — Therapist App

PhysioGhar is a Flutter-based mobile application designed for physiotherapists to manage their daily schedules, appointments, patients, availability, profiles, and account activities from a single application.

The application uses a REST API for authentication, therapist management, schedule and availability management, session management, patient records, patient notes, and account-related operations.

---

# Features

### Dashboard

* Therapist profile and availability status
* Current date and daily overview
* Today's schedule
* Upcoming sessions
* Session summary
* Quick access to session details
* Loading, error, and empty states

### Schedule & Availability

* Weekly date selection
* View schedule slots for selected dates
* Open, booked, and blocked slot states
* Add schedule slots
* Block and unblock availability
* Delete schedule slots
* API-synchronized schedule updates

### Session Management

* View requested, upcoming, completed, and cancelled sessions
* Accept session requests
* Decline session requests with a reason
* View session details
* Reschedule upcoming sessions
* Complete sessions with treatment notes
* Cancel sessions with a reason
* Add a session for testing/demo purposes only
* Session status transitions synchronized with the API

### Patient Management

* Patient list
* Patient details
* Patient information and conditions
* Treatment history
* Add patient notes
* Edit patient notes
* Delete patient notes
* Persistent patient notes through the API

### Profile & Account

* View therapist profile
* Edit profile information
* Update profile image
* Update availability
* Language selection
* Account settings
* Submit complaints
* Logout

---

# Tech Stack

* **Flutter:** 3.47.2
* **Dart:** 3.13.2
* **State Management:** `flutter_riverpod`
* **API Communication:** Dio
* **Authentication:** JWT
* **Secure Token Storage:** Flutter Secure Storage
* **UI & Typography:** Google Fonts
* **Image Selection:** Image Picker

---

# Flutter Dependencies

The main Flutter packages used in the project are:

```yaml
flutter_native_splash: ^2.4.8
google_fonts: ^8.2.1
flutter_launcher_icons: ^0.14.4
flutter_secure_storage: ^11.1.1
flutter_riverpod: ^3.4.3
dio: ^5.11.1
jwt_decoder: ^2.0.1
image_picker: ^1.2.3
shimmer: ^4.0.0
flutter_slidable: ^4.0.3
```

---

# Architecture

The application follows a layered architecture to keep UI, state management, data access, and API communication separated.

```text
UI / Screens
     ↓
Riverpod Notifiers
     ↓
Repositories
     ↓
Services
     ↓
Dio / REST API
```

### Main Layers

**UI / Screens**

* Responsible for displaying application state and handling user interactions.

**Riverpod Notifiers**

* Manage application state.
* Handle loading, updating, errors, selected data, and user actions.

**Repositories**

* Provide an abstraction between providers and API services.

**Services**

* Handle HTTP communication with the REST API.

**Dio**

* Handles API requests and responses.

---

# State Management

The application uses **`flutter_riverpod`** for state management.

Riverpod providers are used for major application features including:

* Authentication
* Dashboard
* Therapist profile
* Schedule
* Sessions
* Patients
* Complaints
* Navigation state

The providers handle:

* Loading states
* Updating states
* API errors
* Selected data
* Form-related state
* API-driven state changes

The application was migrated from the previous controller-based implementation to Riverpod-based state management.

---

# API Integration

The Flutter application communicates with the REST API using **Dio**.

The API integration covers:

* Authentication
* JWT token management
* Therapist profile
* Therapist availability
* Schedule management
* Session management
* Patient records
* Patient notes
* Account-related operations
* Complaint submission

The application uses real API integration rather than static/mock application data.

---

# Authentication

The application uses JWT-based authentication.

The authentication flow includes:

1. User login
2. Access token storage
3. Authenticated API requests
4. Token validation
5. Logout and local credential cleanup

Tokens are securely stored using:

```text
flutter_secure_storage
```

JWT decoding is handled using:

```text
jwt_decoder
```

---

# Project Structure

```text
lib/

├── app/
│   └── app.dart
│
├── common_widgets/
│   ├── app_button.dart
│   ├── app_card.dart
│   ├── app_empty_state.dart
│   ├── app_error_state.dart
│   ├── app_loading.dart
│   ├── app_section_header.dart
│   ├── app_snackbar.dart
│   └── app_text_field.dart
│
├── core/
│   ├── constants/
│   ├── exceptions/
│   ├── extensions/
│   ├── network/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── providers/
│   ├── repositories/
│   └── services/
│
├── models/
│
└── screens/
    ├── auth/
    ├── dashboard/
    ├── patients/
    ├── profile/
    ├── schedule/
    └── sessions/
```

---

# Getting Started

## Prerequisites

Make sure the following are installed:

* Flutter SDK 3.47.2
* Dart SDK 3.13.2
* Android Studio
* Android SDK
* Git

---

# Running the Application

Clone the repository:

```bash
git clone <FRONTEND_REPOSITORY_URL>
```

Navigate to the project:

```bash
cd physioghar
```

Install Flutter dependencies:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

### Run on Local Development Environment

When the Flutter application and Django API are running on the same computer:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

### Run on a Physical Android Device

When running the application on a physical Android device, use the computer's local IPv4 address:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:8000/api/v1
```

Example:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8000/api/v1
```

Replace `192.168.1.100` with the current IPv4 address of the computer running the Django API.

---

# API Configuration

The application requires a running REST API.

The API base URL is configured using Flutter's `--dart-define` option through the `API_BASE_URL` environment variable.

This allows the API endpoint to be changed at runtime without modifying the Flutter source code.

## Local Development

When running the Flutter application on the same computer as the Django backend:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

The application falls back to the following URL when `API_BASE_URL` is not provided:

```text
http://127.0.0.1:8000/api/v1
```

## Physical Android Device

When running the application on a physical Android device:

1. Connect the Android device and development computer to the same Wi-Fi/network.
2. Start the Django backend so it accepts connections from other devices.
3. Find the computer's local IPv4 address.
4. Run the Flutter application using that IP address.

Start the Django backend with:

```bash
python manage.py runserver 0.0.0.0:8000
```

Find the computer's IPv4 address using:

```powershell
ipconfig
```

Then run Flutter:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:8000/api/v1
```

For example:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8000/api/v1
```

Replace the example IP with the current IPv4 address of the computer running the Django API.

The computer and Android device must be connected to the same local network for this setup.

This approach allows the same Flutter source code to connect to the backend on different local Wi-Fi networks by providing the current computer IP at runtime.

---

# Physical Android Device Setup

When testing the application on a physical Android device:

1. Connect the Android device and development computer to the same Wi-Fi/network.
2. Start the Django API using:

```bash
python manage.py runserver 0.0.0.0:8000
```

3. Find the computer's local IPv4 address:

```powershell
ipconfig
```

Look for the active network adapter's:

```text
IPv4 Address
```

For example:

```text
192.168.1.100
```

4. Run the Flutter application using the computer's IP:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8000/api/v1
```

The IP above is only an example and should be replaced with the current IPv4 address of the computer.

> **Note:** `127.0.0.1` refers to the device itself. Therefore, it should not be used as the API address when the Flutter application is running on a physical Android device and the Django API is running on another computer.

For local network testing, the Django API server should accept connections from other devices on the network.

---

# Development Notes

* The application uses a real REST API rather than static/mock application data.
* JWT authentication is used for protected API requests.
* Riverpod manages application state and API-driven state changes.
* Loading, updating, error, and empty states are handled throughout the application.
* Schedule changes are synchronized with the API.
* Session lifecycle changes are synchronized with the API.
* Patient notes are persisted through the API.
* The Add Session functionality is included for testing/demo purposes.
* The API base URL can be configured at runtime using `--dart-define`.
* Flutter static analysis has been completed successfully.

---

# Testing

The project was verified using Flutter static analysis:

```bash
flutter analyze
```

Current result:

```text
No issues found!
```

The main application flows were also tested during development, including:

* Authentication
* Dashboard
* Schedule and availability
* Session management
* Patient records
* Patient notes
* Profile management
* Complaint submission
* API communication
* Physical Android device API connectivity

---

# Future Improvements

The following improvements could be added in future versions.

### Personalized Exercise Plans

Create therapist-prescribed exercise programs based on individual patient conditions, treatment goals, and recovery plans.

### Exercise Visuals & Demonstrations

Provide images, illustrations, animations, or short video demonstrations showing the correct exercise technique.

### Exercise Progress Tracking

Allow therapists to monitor patient exercise completion, progress, adherence, and feedback over time.

### Notifications

Add push notifications for:

* Appointment requests
* Appointment confirmations
* Cancellations
* Rescheduling
* Appointment reminders
* Exercise reminders

### Offline Support

Improve offline functionality with local caching and reliable synchronization when the device reconnects to the internet.

### Real-Time Updates

Add real-time schedule and appointment updates for therapists.

### Testing

Expand automated:

* Unit tests
* Widget tests
* Integration tests

### CI/CD

Add automated CI/CD workflows for:

* Static analysis
* Automated tests
* APK builds
* Release builds
* Deployment

### Analytics & Reporting

Provide therapist analytics and treatment progress reports.

### Localization

Expand English/Nepali localization and improve support for additional languages.

### Production Deployment

Prepare the application for production environments with secure release configuration, production API deployment, monitoring, and deployment setup.

---

# Assignment Deliverables

This repository contains the Flutter source code for the PhysioGhar Therapist App.

The project demonstrates:

* Flutter application development
* `flutter_riverpod` state management
* REST API integration
* JWT authentication
* Secure token storage
* Schedule and availability management
* Session lifecycle management
* Patient record management
* Persistent patient notes
* Profile and account management
* Complaint management
* Layered application architecture
* Responsive and reusable UI components
* Runtime API configuration using Flutter `--dart-define`

---

# License

This project was developed as part of the PhysioGhar Flutter Developer technical assignment.
