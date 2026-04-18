# How to Run Ki-Sun App

## Prerequisites
- Flutter SDK (3.10+)
- Node.js (18+)
- MongoDB (Running locally or URL)

## 1. Setup Assets (Important!)
Before generating the App Icon and Splash Screen, place your assets in the folders:
- `ki_sun/assets/images/icon.png` (Recommended 1024x1024)
- `ki_sun/assets/images/splash.png` (Recommended 1152x1152)

Then run:
```bash
cd ki_sun
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## 2. Run Flutter App
```bash
cd ki_sun
flutter run
```

## 3. Run Backend
1. **Configure Environment**:
   - Create `.env` in `ki_sun/backend/`.
   - Add `MONGO_URI` (your MongoDB Atlas connection string).
   - Add `JWT_SECRET` and `JWT_REFRESH_SECRET` (see `.env.example`).
   
2. **Start Server**:
   Open a new terminal:
   ```bash
   cd ki_sun/backend
   npm install
   npm run dev
   ```

## Project Structure
- `lib/app`: Core logic (Themes, Routes, Bindings).
- `lib/modules`: feature-based modules (Onboarding, Auth, Consent, Customers etc.).
- `lib/shared`: Reusable widgets & constants.
- `backend/src`: Express API source code (Modules: Auth, Users, Customers, KYC, Consent).
