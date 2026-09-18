# PhysioGhar — Therapist App

PhysioGhar is a Flutter-based mobile application designed for physiotherapists to manage their daily schedules, appointments, patients, availability, profiles, and account activities from a single application.

The application is integrated with a **Django REST API backend** for authentication, therapist management, schedule and availability management, session management, patient records, patient notes, and account-related operations.

---

## Features

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
* Backend-synchronized schedule updates

### Session Management

* View requested, upcoming, completed, and cancelled sessions
* Accept session requests
* Decline session requests with a reason
* View session details
* Reschedule upcoming sessions
* Complete sessions with treatment notes
* Cancel sessions with a reason
* Add a session for testing/demo purposes only
* Session status transitions synchronized with the backend

### Patient Management

* Patient list
* Patient details
* Patient information and conditions
* Treatment history
* Add patient notes
* Edit patient notes
* Delete patient notes
* Persistent patient notes through the backend API

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

## Frontend

* **Flutter:** 3.47.2
* **Dart:** 3.13.2
* **State Management:** `flutter_riverpod`
* **API Communication:** Dio
* **Authentication:** JWT
* **Secure Token Storage:** Flutter Secure Storage
* **UI & Typography:** Google Fonts
* **Image Selection:** Image Picker

## Backend

* **Python:** 3.14.7
* **Django:** 6.1.1
* **Django REST Framework:** 3.18.1
* **JWT Authentication:** djangorestframework-simplejwt 5.5.1
* **Database:** SQLite / PostgreSQL compatible configuration
* **CORS:** django-cors-headers
* **Filtering:** django-filter

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

The application follows a layered architecture to separate UI, state management, data access, API communication, and backend responsibilities.

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
     ↓
Django REST Framework
     ↓
Database
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

* Handle HTTP communication with the Django REST API.

**Dio**

* Handles API requests and responses.

**Django REST API**

* Handles authentication, business logic, validation, persistence, and database operations.

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
* Backend-driven state changes

The application was migrated from the previous controller-based implementation to Riverpod-based state management.

---

# API Integration

The Flutter application communicates with the Django REST API using **Dio**.

The API handles:

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

The application uses real backend API integration rather than static/mock application data.

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

# Backend

The backend is maintained as a separate Django REST API project.

**Backend repository:**

https://github.com/bikashgrg1995-04/physioghar-backend

The backend provides the APIs required by the Flutter therapist application.

---

# Backend Dependencies

The Django backend uses the following packages:

```text
asgiref==3.12.1
Django==6.1.1
django-cors-headers==4.9.0
django-filter==26.1
djangorestframework==3.18.1
djangorestframework-simplejwt==5.5.1
pillow==12.3.0
psycopg==3.3.5
psycopg-binary==3.3.5
PyJWT==2.14.0
python-dotenv==1.2.3
sqlparse==0.6.0
tzdata==2026.4
```

---

# Getting Started

## Prerequisites

Make sure the following are installed:

* Flutter SDK 3.47.2
* Dart SDK 3.13.2
* Android Studio
* Android SDK
* Python 3.12+
* Git

---

# Running the Flutter Application

Clone the repository:

```bash
git clone https://github.com/bikashgrg1995-04/physioghar.git
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

Run the application:

```bash
flutter run
```

---

# Running the Django Backend

Clone the backend repository:

```bash
git clone https://github.com/bikashgrg1995-04/physioghar-backend.git
```

Navigate to the backend project:

```bash
cd physioghar-backend
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate the virtual environment on Windows:

```powershell
venv\Scripts\activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Apply database migrations:

```bash
python manage.py migrate
```

Start the development server:

```bash
python manage.py runserver
```

---

# Physical Android Device Setup

When testing the Flutter application on a physical Android device, the phone and the computer running the Django server must be connected to the **same local network**.

## 1. Find the Computer's IPv4 Address

On Windows, run:

```powershell
ipconfig
```

Find the active network adapter and locate:

```text
IPv4 Address
```

For example:

```text
192.168.1.100
```

The IP address above is only an example.

---

## 2. Configure the Flutter API URL

Open the Flutter project's API/environment configuration and replace the local host address with the computer's IPv4 address.

Example:

```text
http://192.168.1.100:8000/api/v1/
```

Replace `192.168.1.100` with the IPv4 address of the computer running the Django server.

---

## 3. Start Django for Network Access

Instead of running the default local-only server, use:

```bash
python manage.py runserver 0.0.0.0:8000
```

This allows devices on the same local network to connect to the Django development server.

---

## 4. Configure Django Allowed Hosts

Add the development computer's local IP address to the appropriate Django settings.

Example:

```python
ALLOWED_HOSTS = [
    "127.0.0.1",
    "localhost",
    "192.168.1.100",
]
```

Replace the example IP with the actual IPv4 address of the development computer.

If CORS restrictions are enabled, configure the required development origins according to the environment.

---

## 5. Network Requirements

* The physical Android device and development computer must be connected to the same Wi-Fi/network.
* The Django server must listen on `0.0.0.0`.
* Port `8000` must be accessible through the computer's firewall.
* The computer's IPv4 address may change when connecting to another network.
* For production deployment, use a deployed API URL instead of a local IPv4 address.

---

# Development Notes

* The application uses a real Django REST API rather than static/mock application data.
* JWT authentication is used for protected API requests.
* Riverpod manages application state and API-driven state changes.
* Loading, updating, error, and empty states are handled throughout the application.
* Schedule changes are synchronized with the backend.
* Session lifecycle changes are synchronized with the backend.
* Patient notes are persisted through the backend API.
* The Add Session functionality is included for testing/demo purposes.
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
* Backend API tests

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

### Production Infrastructure

Deploy the Django REST API using production-ready infrastructure, database configuration, security settings, logging, monitoring, and environment-based configuration.

---

# Assignment Deliverables

This repository contains the Flutter source code for the PhysioGhar Therapist App.

The project demonstrates:

* Flutter application development
* `flutter_riverpod` state management
* REST API integration
* Django REST API backend integration
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

---

# License

This project was developed as part of the PhysioGhar Flutter Developer technical assignment.
