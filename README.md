# 🛡️ Check It

<div align="center">
  <img src="assets/images/app_logo.png" alt="LabelGuard Logo" width="150"/>
  <br/>
  <strong>An AI-powered application for automated product label compliance inspection.</strong>
</div>

<br/>

## 📖 Overview
LabelGuard is an intelligent mobile application designed to simplify and automate the inspection of product labels. Leveraging machine learning (Google ML Kit OCR), it scans product labels in real-time, extracts text, and evaluates it against predefined regulatory rules (e.g., MRP, manufacturing dates, net quantity) to detect violations and compute compliance risk levels.

### 🎥 Watch Demo Video
[**Click here to view the LabelGuard Demo Video**](https://drive.google.com/file/d/1aZXJpXRkfbnaErOioOgyrcFo-vk2wwPI/view?usp=sharing)

---

## ✨ Key Features
* **📷 Smart Scanning:** Uses the device camera and Google ML Kit for real-time Text Recognition (OCR) on product labels.
* **⚖️ Automated Compliance Check:** Instantly validates extracted data against compliance rules to detect missing or violating information.
* **📊 Risk Assessment:** Calculates a compliance risk score, penalty exposure, and categorizes violations by severity (Critical, Major, Minor).
* **📝 Detailed Reports:** Generates comprehensive PDF reports of the inspection results, complete with geolocated stamps and digital signatures.
* **🖨️ Print & Share:** Easily print reports directly from the app or share them via external apps.
* **💾 Local Storage:** Works offline with Hive database, keeping a secure history of all previous scans.
* **🌍 Multi-language Support:** Localized for better accessibility (i18n).
* **🌗 Dark/Light Mode:** Full dynamic theme support.

---

## 🛠️ Technology Stack
* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Architecture/State:** Provider, GoRouter
* **Machine Learning:** Google ML Kit Text Recognition
* **Database / Storage:** Hive, Shared Preferences
* **Reporting:** PDF, Printing
* **Hardware/Sensors:** Camera, Geolocator

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.13.1)
- Dart SDK
- Android Studio / Xcode

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/label_guard.git
   cd label_guard
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files** (Hive adapters, etc.)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure
* `lib/models/`: Data models for rules, violations, and inspection results.
* `lib/providers/`: State management (Auth, Scans, Theme, Settings).
* `lib/rules/`: Definitions of compliance rules and logic.
* `lib/screens/` & `lib/widgets/`: UI components and pages.
* `lib/services/`: Core services (Local Storage, etc.).
* `lib/config/`: App theming and routing configuration.

---

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! 

## 📜 License
This project is currently unlicensed. Please add a license file if required.
