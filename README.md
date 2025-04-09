# 🛠️ Automated Package Integration Tool – Flutter (macOS)

This is a Flutter desktop tool built for macOS that automates the integration of the `google_maps_flutter` package into any selected Flutter project.

---

## ✨ Features

- ✅ Pick a Flutter project directory from your system
- ✅ Validate that it's a proper Flutter project (`pubspec.yaml` exists)
- ✅ Inject `google_maps_flutter` into `pubspec.yaml`
- ✅ Prompt the user to enter a **Google Maps API key**
- ✅ Automatically update:
  - `AndroidManifest.xml` with the API key
  - `ios/Runner/Info.plist` with the API key
- ✅ Add a working map widget example (centered on **New Delhi**)
- ✅ Run `flutter pub get` in the selected project

---

## 🧠 Why macOS?

The tool requires access to:
- The local file system (to pick and edit a Flutter project)
- The ability to run subprocesses (e.g. `flutter pub get`)

These are only supported on **desktop platforms** like macOS and Windows — not Android or iOS. Therefore, the tool is designed and built for **macOS**.

> Note: `google_maps_flutter` is not supported on macOS — but this tool prepares everything so the map widget works when the project is run on Android/iOS.

---

## 🚀 How to Run

### 1. Clone the Repo
```bash
git clone https://github.com/accee00/automated_package_integrator.git
cd automated_package_integrator
