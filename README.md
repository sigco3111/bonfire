# 🟢 [원작/한글화] (라이브러리) (RPG) · Dart/Flutter로 RPG 게임을 더 쉽게 만드는 엔진 — Flutter + Flame

[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)
[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue.svg)](https://flutter.dev/)
[![MIT Licence](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![pub package](https://img.shields.io/pub/v/bonfire.svg)](https://pub.dev/packages/bonfire)
[![GitHub stars](https://img.shields.io/github/stars/sigco3111/bonfire?style=social)](https://github.com/sigco3111/bonfire)

> **FlameEngine**의 힘으로 RPG 게임 등을 더 쉽고, 객관적이고, 빠르게 만들어 보세요!

---

## 🎮 Bonfire란?

Bonfire는 Flutter로 RPG 스타일의 게임(또는 그와 유사한 장르)을 **더 쉽고, 객관적이며, 빠르게** 만들 수 있도록 설계된 **2D 게임 엔진 라이브러리**입니다.

이 라이브러리는 [FlameEngine](https://flame-engine.org/) 위에 구축되었으며, Flame의 모든 리소스와 클래스를 Bonfire와 함께 자유롭게 사용할 수 있습니다. Bonfire로 작업을 시작하기 전에 [FlameEngine 문서](https://docs.flame-engine.org/)를 가볍게 살펴 보는 것을 권장합니다.

### ✨ Bonfire가 잘 맞는 게임 관점

| 2D 탑다운 (Top-down)    | 2D 횡스크롤 (Side-view)  | 시점 고정 1인칭 등 |
|-------------------------|--------------------------|--------------------|
| ![topdown](../media/perspectiva.png) | ![sideview](../media/perspectiva.png) | ![isfixed](../media/perspectiva.png) |

---

## 📦 설치

`pubspec.yaml`의 `dependencies`에 추가하세요.

```yaml
dependencies:
  flutter:
    sdk: flutter
  bonfire: ^3.17.2
```

그리고 다음 명령으로 패키지를 가져옵니다.

```bash
flutter pub get
```

> 최소 요구 사양: Flutter 3.22 이상, Dart SDK 3.4 이상

---

## 🚀 빠른 시작 (5분 튜토리얼)

Bonfire로 최소한의 RPG 화면을 띄우려면 세 가지 핵심 개념만 알면 됩니다.

```dart
import 'package:bonfire/bonfire.dart';

class MyGame extends BonfireGame {
  MyGame() : super(
    mapPath: 'maps/my_map.json',   // Tiled 맵 파일 (.json)
    player: KnightPlayer(
      position: Vector2(64, 64),    // 시작 좌표 (픽셀)
      size: Vector2(32, 32),
    ),
    decorations: [],               // 배경 장식들
    enemies: [],                    // 적 캐릭터들
    interface: [],                  // HP 바, 인벤토리 등 UI
    cameraConfig: CameraConfig(
      zoom: 1.0,
      smoothCameraEnabled: true,
    ),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(
    GameWidget(game: MyGame()),
  );
}
```

<details>
<summary>🧭 좀 더 자세한 단계별 가이드 보기</summary>

1. **프로젝트 생성** — `flutter create my_rpg` → `pubspec.yaml`에 `bonfire` 추가
2. **맵 작성** — [Tiled](https://www.mapeditor.org/) 맵 에디터로 맵을 그리고 JSON으로 내보내기
3. **플레이어 정의** — `SimplePlayer` 또는 `PlatformPlayer` 상속해서 키보드/마우스/터치 입력 처리
4. **NPC / 적 배치** — `SimpleEnemy`, `SimpleNpc` 클래스로 맵 위에 배치
5. **인터페이스 (HUD)** — `BarLifeComponent`, `BarManaComponent` 같은 내장 위젯 사용
6. **콜백 추가** — `onTap`, `onContact`, `onMove` 등으로 게임 로직 연결

</details>

---

## 🧩 Bonfire의 핵심 컴포넌트

| 카테고리                | 핵심 클래스                                                                                  |
|------------------------|----------------------------------------------------------------------------------------------|
| **게임 루프**          | `BonfireGame`, `BonfireGameWidget`, `ListenerGameWidget`                                     |
| **맵**                 | `TiledWorldMap`, `SpritefusionWorldMap`, `TerrainBuilderWorldMap`                            |
| **플레이어 / NPC / 적** | `SimplePlayer`, `PlatformPlayer`, `RotationPlayer`, `SimpleEnemy`, `SimpleNpc`, `FollowerPlayer` |
| **컴포넌트 / 장식**    | `GameDecoration`, `FlyingAttackGameObject`, `BarLifeComponent`, `Sensor`                     |
| **충돌 감지**          | `BonfireCollisionConfig`, `QuadTreeCollision`, `RectangleHitbox`, `PolygonHitbox`            |
| **조명**               | `Lighting`, `LightingComponent`, `LightCircle`, `LightCone`                                  |
| **이동 / 경로 탐색**   | `Movement` mixin, `PathFinding`, `AStar` (별도 패키지 `a_star_algorithm`)                     |
| **이펙트 / 셰이더**    | `ShaderConfig`, `LightingShader`, `EffectController`                                         |
| **UI / HUD**           | `BarLifeWidget`, `BarLifeController`, `KnightInterface`, `TalkDialog`, `Say`                 |
| **카메라**             | `CameraConfig`, `moveToTargetAnimated`, `moveToPlayerAnimated`, `zoom`                       |
| **입력**               | `KeyboardConfig`, `MouseConfig`, `TapGesture`, `DragGesture`, `MoveCameraMouse`              |
| **타일드 맵**          | `TiledReader`, `TiledWorldMapBuilder`, `Tile`, `MapSensor`                                    |
| **직렬화 / 저장**      | `BonfireStorage`, `GameComponentStorage`, `PositionStorage`                                  |

> **Tip** — 코드에서 모든 메서드에 한국어 doc-comment가 박혀 있습니다. IDE 자동완성에서 `/**`로 시작하는 라인을 펼쳐 보세요.

---

## 🖥️ 플랫폼 빌드 가이드

Bonfire는 Android, iOS, Web(Flutter Web), Windows, macOS, Linux에서 모두 동작합니다. 각 플랫폼별 핵심 설정은 다음과 같습니다.

### 🌐 Web (Flutter Web + GitHub Pages)

```bash
flutter build web --web-renderer=canvaskit --release
```

- `--web-renderer=canvaskit` — 더 부드러운 그래픽 (권장)
- 빌드 결과물은 `build/web/` 디렉토리에 생성됩니다
- **이 저장소에는 GitHub Actions 자동 배포 워크플로우가 포함**되어 있어, `main` 브랜치에 push만 하면 GitHub Pages에 자동 배포됩니다
- Pages URL: `https://sigco3111.github.io/bonfire/` (배포 후 노출)

> 자세한 배포 가이드는 `.github/workflows/pages.yml`을 참고하세요.

### 📱 Android

`android/app/src/main/AndroidManifest.xml`의 `<application>` 태그 안에 다음을 추가합니다.

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="false" />
```

> Impeller 비활성화 권장 — Flutter의 신규 렌더러가 Bonfire 일부 셰이더와 호환되지 않을 수 있습니다.

### 🍎 iOS

기본 Flutter 설정 그대로 사용하면 됩니다. iOS 12 이상 권장.

### 🖥️ Desktop (Windows / macOS / Linux)

추가 설정 없이 그대로 빌드됩니다. 단, CanvasKit이 가장 안정적인 렌더러이므로 web 외에는 `CanvasKit` 모드를 권장합니다.

---

## 📚 예제 (Examples)

이 저장소에는 **80개 이상의 데모 앱**이 들어있습니다.

각 데모는 게임 엔진의 한 가지 기능을 보여주며, 좌측 드로어 메뉴(또는 GitHub README)에서 자유롭게 선택할 수 있습니다.

| 영역              | 데모 예시                                                                                          |
|-------------------|---------------------------------------------------------------------------------------------------|
| **맵**            | Tiled 사용, Tiled URL, Spritefusion 사용, 매트릭스 사용                                            |
| **입력**          | 탭 동작, 드래그 동작, 카메라 이동, 마우스, 키보드, 플레이어 컨트롤러                              |
| **플레이어**      | 단순 플레이어, 회전 플레이어, 플랫폼 플레이어                                                      |
| **적 / NPC**      | Enemy (근접 + 원거리), Forces, BlockMovementCollision, PathFinding                                  |
| **조명**          | Lighting                                                                                           |
| **셰이더**        | Shader                                                                                             |
| **시차**          | Parallax, CameraParallax                                                                            |
| **미니 게임**     | Tiled 맵, 탑다운 게임, 플랫폼 게임, 다중 시나리오, 무작위 맵, 수동 맵, 단순 예제                  |
| **성능**          | Performance (다수 객체 스트레스 테스트)                                                             |

> Tip — 데모의 좌측 메뉴는 **모두 한국어로 번역**되어 있습니다. 메뉴에서 예제를 고른 뒤 우측 상단의 "소스 코드" 버튼을 누르면 해당 데모의 소스 코드를 GitHub에서 바로 볼 수 있습니다.

---

## 🧪 플레이 가능한 데모

### 🍎 macOS / iOS / Android

공식 데모 빌드는 [bonfire-engine/bonfire-engine.github.io](https://github.com/bonfire-engine/bonfire-engine.github.io)의 `examples/bonfire-v3/` 빌드를 다운받아 실행할 수 있습니다.

```bash
# 빌드만 직접 해보고 싶다면
cd example
flutter pub get
flutter run -d chrome    # 또는 -d macos / -d <device>
```

### 🕹️ 라이브 데모 (Web)

원본 사이트의 라이브 데모는 다음 위치에서 만나볼 수 있습니다.

- 🔗 [bonfire-engine.github.io/examples/bonfire-v3/](https://bonfire-engine.github.io/examples/bonfire-v3/) — 가장 대표적인 예제

> 이 포크는 원본 엔진의 코드 베이스를 그대로 가져와 **문서와 예제 앱의 UI를 한국어로 번역**한 버전입니다. 빌드 산출물(빌드 방법)은 동일합니다.

---

## 📂 프로젝트 구조

```
sigco3111-bonfire/
├── lib/                     # Bonfire 엔진 라이브러리 (Dart)
│   ├── bonfire.dart         # 진입점 (모든 클래스 export)
│   ├── base/                # 게임 루프, 인터페이스
│   ├── player/              # SimplePlayer, PlatformPlayer ...
│   ├── enemy/               # SimpleEnemy, ranged, melee ...
│   ├── npc/                 # SimpleNpc, FollowerPlayer ...
│   ├── decoration/          # GameDecoration, Torch, Chest ...
│   ├── objects/             # FlyingAttackGameObject, Sensor ...
│   ├── map/                 # Tiled, Spritefusion, TerrainBuilder ...
│   ├── collision/           # Hitbox, QuadTree ...
│   ├── lighting/            # Lighting, LightCircle ...
│   ├── camera/              # CameraConfig, Camera ...
│   ├── input/               # Keyboard, Mouse, Touch
│   ├── joystick/            # JoystickDirectional
│   ├── mixins/              # Movement, PathFinding, HasGameRef ...
│   ├── behavior/            # Behaviors (AI)
│   ├── parallax/            # ParallaxBackground
│   ├── color_filter/        # ColorFilter (셰이더)
│   ├── forces/              # 힘 / 물리 컴포넌트
│   ├── scene_builder/       # SceneBuilder / Scene
│   ├── util/                # 확장, enum, helper
│   └── widgets/             # BonfireWidget, BarLifeWidget ...
│
├── example/                 # 80+ Flutter 데모 앱
│   ├── lib/
│   │   ├── main.dart
│   │   ├── pages/           # home, input, player, enemy, mini_games ...
│   │   ├── shared/          # NPC, 플레이어, enemy, interface, util
│   │   └── core/            # 라우트, 테마, 위젯
│   ├── assets/              # 스프라이트, 사운드, Tiled 맵
│   ├── shaders/             # GLSL 셰이더
│   └── test/
│
├── media/                   # README / 문서용 미디어 (gif, png)
├── pubspec.yaml             # 라이브러리 메타데이터
├── LICENSE                  # MIT
└── .github/workflows/pages.yml  # GitHub Pages 자동 배포
```

---

## 🛠️ 유용한 동반 패키지

| 패키지              | 용도                                                  | 설치 |
|---------------------|------------------------------------------------------|------|
| `bonfire_bloc`      | Bonfire 게임 상태를 BLoC 패턴으로 관리               | [`pub.dev/packages/bonfire_bloc`](https://pub.dev/packages/bonfire_bloc) |
| `bonfire_spine`     | Spine 스켈레탈 애니메이션 통합                       | [`pub.dev/packages/bonfire_spine`](https://pub.dev/packages/bonfire_spine) |
| `a_star_algorithm`  | A* 경로 탐색 (Bonfire가 의존)                         | 이미 의존성에 포함 |
| `flame`             | 저수준 게임 엔진 (Bonfire 기반)                       | 이미 의존성에 포함 |

---

## 🤝 기여 (Contribution)

이 저장소는 **원본 `RafaelBarbosatec/bonfire`의 한글화 포크**입니다. 다음과 같은 기여를 환영합니다.

- 🐛 **버그 리포트** — 한글화 후 깨진 게임 동작 발견 시 [Issue](https://github.com/sigco3111/bonfire/issues) 등록
- 🌏 **번역 개선** — 자연스럽지 않은 한국어 번역 발견 시 PR (예: "탑다운 게임" → "쿨뷰 게임" 같은 표현)
- ✨ **문서 보강** — `lib/`의 dart doc-comment 보강, README 다듬기, 한국어 튜토리얼 작성
- 🔧 **예제 추가** — 한글로 된 새로운 미니 게임 / NPC 대화 시나리오 추가

**PR 보내실 때 참고하세요.**

- 모든 대화/메뉴는 한글로 작성 (한영 혼용 금지)
- 식별자(클래스명, 메서드명, 필드명)는 절대 한글화 금지
- `flutter analyze` 통과 + `flutter test` 통과가 PR 머지의 최소 요건
- 큰 변경은 이슈 먼저 → 디스커션 후 작업

---

## ⚖️ 라이선스

이 프로젝트는 **MIT License** 하에 배포됩니다 — 자세한 내용은 [`LICENSE`](LICENSE) 파일을 확인하세요.

원본 저작자: **Rafael Barbosa** ([@rafaelbarbosatec](https://github.com/RafaelBarbosatec)) — 2018~ 현재

> ⚠️ 본 저장소는 원본의 **코드, 빌드 시스템, 자산 구조를 그대로 보존**하면서 **예제 앱의 사용자 대면 텍스트와 라이브러리 dart doc-comment를 한국어로 번역**한 포크입니다. 원본의 라이선스( MIT )와 저작권 표시가 그대로 유지됩니다.

---

## ✨ Credits

* The entire [FlameEngine](https://flame-engine.org/) team.
* 모든 기여자와 [Bonfire Discord/Telegram 채널](https://t.me/bonfire_engine)의 도움.

---

## 🔗 관련 링크

- 📖 원본 저장소: <https://github.com/RafaelBarbosatec/bonfire>
- 🌐 Bonfire 공식 문서 사이트: <https://bonfire-engine.github.io>
- 📦 pub.dev 패키지: <https://pub.dev/packages/bonfire>
- 💬 Telegram 채널: <https://t.me/bonfire_engine>
- 🐛 이슈 트래커: <https://github.com/sigco3111/bonfire/issues>
- 💖 스폰서: <https://github.com/sponsors/rafaelbarbosatec>

---

> 💡 **Tip** — 이 README가 도움이 됐다면 ⭐️ 스타를 눌러주세요! 한 줄짜리 한글화도 큰 기여입니다.
