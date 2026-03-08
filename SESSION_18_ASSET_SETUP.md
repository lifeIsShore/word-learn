# Session 18 — Asset Copy Instructions

Run these commands from the `word_learn` project root to copy all generated assets into place.

## Step 1 — Copy Flutter asset files

Copy from the downloaded `wordlearn_assets` folder:

```
assets/icon/icon_1024.png             → word_learn/assets/icon/icon_1024.png
assets/icon/icon_foreground_1024.png  → word_learn/assets/icon/icon_foreground_1024.png
assets/splash/wordlearn.png           → word_learn/assets/splash/wordlearn.png
assets/splash/wordlearn@2x.png        → word_learn/assets/splash/wordlearn@2x.png
assets/splash/wordlearn@3x.png        → word_learn/assets/splash/wordlearn@3x.png
assets/splash/wordlearn_dark.png      → word_learn/assets/splash/wordlearn_dark.png
assets/splash/wordlearn_dark@2x.png   → word_learn/assets/splash/wordlearn_dark@2x.png
assets/splash/wordlearn_dark@3x.png   → word_learn/assets/splash/wordlearn_dark@3x.png
```

## Step 2 — Copy Android mipmap icons

```
android/mipmap-mdpi/ic_launcher.png              → android/app/src/main/res/mipmap-mdpi/ic_launcher.png
android/mipmap-mdpi/ic_launcher_foreground.png   → android/app/src/main/res/mipmap-mdpi/ic_launcher_foreground.png
android/mipmap-hdpi/ic_launcher.png              → android/app/src/main/res/mipmap-hdpi/ic_launcher.png
android/mipmap-hdpi/ic_launcher_foreground.png   → android/app/src/main/res/mipmap-hdpi/ic_launcher_foreground.png
android/mipmap-xhdpi/ic_launcher.png             → android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
android/mipmap-xhdpi/ic_launcher_foreground.png  → android/app/src/main/res/mipmap-xhdpi/ic_launcher_foreground.png
android/mipmap-xxhdpi/ic_launcher.png            → android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
android/mipmap-xxhdpi/ic_launcher_foreground.png → android/app/src/main/res/mipmap-xxhdpi/ic_launcher_foreground.png
android/mipmap-xxxhdpi/ic_launcher.png            → android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
android/mipmap-xxxhdpi/ic_launcher_foreground.png → android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png
```

## Step 3 — Copy iOS icons

Copy all files from `ios/` into:
`ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Each file maps by name (e.g. `Icon-App-1024x1024@1x.png` → same filename).

## Step 4 — Run the generators

```bash
cd word_learn
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Step 5 — Verify

```bash
flutter run
```

The app should launch with:
- ✅ Teal W icon on home screen
- ✅ paperWhite splash (light) / deepNavy splash (dark)  
- ✅ App name "WordLearn" (not "word_learn") under the icon
