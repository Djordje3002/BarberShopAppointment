# Barbershop Appointments App 💈

A modern **iOS app built with SwiftUI** that allows users to book barbershop appointments, choose a barber, select services, and manage bookings in a clean and intuitive interface.

This project demonstrates real-world app structure, state management, and user flows commonly used in production iOS applications.

---

## ✨ Features

### 🧑‍💼 User Features
- Browse available barbers
- View detailed barber profiles
- Choose services (haircut, beard trim, etc.)
- Select available date & time
- Book appointments
- View upcoming and past appointments
- Cancel appointments

---

### 💈 Barber Profiles
- Profile photo
- Name and specialization
- Years of experience
- Rating / reviews
- Available working hours

---

### 📅 Appointment System
- Time-slot based booking
- Prevents double booking
- Real-time availability updates
- Confirmation after successful booking

---

### 🔐 Authentication (if applicable)
- User sign up / sign in
- Secure session handling
- Persistent login

---

## 🛠 Tech Stack

- **Swift**
- **SwiftUI**
- **MVVM Architecture**
- **Firebase**
  - Authentication
  - Firestore (appointments, users, barbers)
- **Async/Await**
- **Combine** (if used)

---

## 🧱 Architecture

The app follows the **MVVM (Model–View–ViewModel)** pattern:

- **Models** – Data structures (User, Barber, Appointment)
- **Views** – SwiftUI UI components
- **ViewModels** – Business logic & state handling
- **Services** – Firebase / networking layer

This keeps the codebase scalable, testable, and easy to maintain.

---

## 📸 Screenshots

| Home | Barber Profile | Booking |
|------|---------------|---------|
| ![](Screenshots/home.png) | ![](Screenshots/barber.png) | ![](Screenshots/booking.png) |

*(Add real screenshots or GIFs here — very important for portfolio impact)*

---

## 🚀 Getting Started

### Requirements
- iOS 16+
- Xcode 15+
- Firebase project
