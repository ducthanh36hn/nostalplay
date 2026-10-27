# NostalPlay

Retro 4-button handheld mini-games (Snake first) built with Flutter. iOS + Android, portrait.

- Docs: [`docs/development-plan.md`](docs/development-plan.md), spec/design/plan in [`docs/platform-snake/`](docs/platform-snake/)
- App id: `com.nostalplay.app`
- Fonts: Space Mono, Inter (SIL OFL, in `assets/fonts/`)

## Develop

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Note: on newer iOS simulators a debug build cannot be launched standalone; use `flutter run`.
