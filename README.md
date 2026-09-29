# SanctumIQ

SanctumIQ is a Flutter application configured for static Flutter Web deployment on Vercel.

## Deploy to Vercel

Import this repository in Vercel and use these project settings:

| Setting | Value |
|---|---|
| Framework Preset | Other |
| Root Directory | `./` (repository root) |
| Build Command | `bash scripts/vercel-build.sh` |
| Output Directory | `build/web` |
| Install Command | Leave blank |
| Development Command | Leave blank |

The build script downloads the Linux Flutter SDK version pinned in `.flutter-version`, resolves dependencies from `pubspec.lock`, and runs `flutter build web --release`. Generated output stays in the ignored `build/` directory. `vercel.json` sends client-side routes to the Flutter entry page.

## Build locally

With the pinned Flutter SDK available on `PATH`, run:

```sh
flutter pub get --enforce-lockfile
flutter build web --release --output build/web
```
