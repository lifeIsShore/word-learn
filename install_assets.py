"""
WordLearn — Session 18 Asset Installer
---------------------------------------
Run this script ONCE from any directory to copy all generated PNG assets
into the correct locations in the Flutter project.

Usage:
    python install_assets.py

It will:
  1. Extract wordlearn_assets.zip (sitting next to this script)
  2. Copy icon PNGs  → word_learn/assets/icon/
  3. Copy splash PNGs→ word_learn/assets/splash/
  4. Copy Android mipmap PNGs → android/app/src/main/res/mipmap-*/
  5. Copy iOS icon PNGs → ios/Runner/Assets.xcassets/AppIcon.appiconset/

After running:
    cd word_learn
    flutter pub get
    dart run flutter_launcher_icons
    dart run flutter_native_splash:create
    flutter run
"""

import os, shutil, zipfile, sys

# ── Locate the zip ────────────────────────────────────────────────────────────
script_dir = os.path.dirname(os.path.abspath(__file__))
zip_path   = os.path.join(script_dir, 'wordlearn_assets.zip')
project    = os.path.join(script_dir, 'word_learn')

if not os.path.exists(zip_path):
    print(f"ERROR: {zip_path} not found.")
    print("Download wordlearn_assets.zip from the Claude chat and place it next to this script.")
    sys.exit(1)

if not os.path.exists(project):
    print(f"ERROR: Flutter project not found at {project}")
    sys.exit(1)

# ── Extract to a temp dir ─────────────────────────────────────────────────────
import tempfile
tmp = tempfile.mkdtemp()
with zipfile.ZipFile(zip_path) as zf:
    zf.extractall(tmp)

print(f"Extracted to {tmp}")

def cp(src, dst):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.copy2(src, dst)
    print(f"  ✓ {os.path.relpath(dst, project)}")

# ── Flutter asset files ───────────────────────────────────────────────────────
print("\n── Flutter assets ──────────────────────────────────────────────────────")
for fname in ['icon_1024.png', 'icon_foreground_1024.png']:
    cp(os.path.join(tmp, 'icon', fname),
       os.path.join(project, 'assets', 'icon', fname))

splash_files = [
    'wordlearn.png', 'wordlearn@2x.png', 'wordlearn@3x.png',
    'wordlearn_dark.png', 'wordlearn_dark@2x.png', 'wordlearn_dark@3x.png',
]
for fname in splash_files:
    cp(os.path.join(tmp, 'splash', fname),
       os.path.join(project, 'assets', 'splash', fname))

# ── Android mipmap icons ──────────────────────────────────────────────────────
print("\n── Android icons ───────────────────────────────────────────────────────")
res_base = os.path.join(project, 'android', 'app', 'src', 'main', 'res')
for density in ['mipmap-mdpi','mipmap-hdpi','mipmap-xhdpi','mipmap-xxhdpi','mipmap-xxxhdpi']:
    for fname in ['ic_launcher.png', 'ic_launcher_foreground.png']:
        cp(os.path.join(tmp, 'android', density, fname),
           os.path.join(res_base, density, fname))

# ── iOS icons ─────────────────────────────────────────────────────────────────
print("\n── iOS icons ───────────────────────────────────────────────────────────")
ios_icon_dir = os.path.join(project, 'ios', 'Runner', 'Assets.xcassets', 'AppIcon.appiconset')
for fname in os.listdir(os.path.join(tmp, 'ios')):
    if fname.endswith('.png'):
        cp(os.path.join(tmp, 'ios', fname),
           os.path.join(ios_icon_dir, fname))

# ── iOS LaunchImage (for LaunchScreen.storyboard) ────────────────────────────
print("\n── iOS launch images ────────────────────────────────────────────────────")
launch_dir = os.path.join(project, 'ios', 'Runner', 'Assets.xcassets', 'LaunchImage.imageset')
for fname in ['LaunchImage.png','LaunchImage@2x.png','LaunchImage@3x.png']:
    cp(os.path.join(tmp, 'launch', fname),
       os.path.join(launch_dir, fname))

# ── Cleanup ───────────────────────────────────────────────────────────────────
shutil.rmtree(tmp)

print("\n✅ All assets installed!")
print("\nNext steps:")
print("  cd word_learn")
print("  flutter pub get")
print("  dart run flutter_launcher_icons")
print("  dart run flutter_native_splash:create")
print("  flutter run")
