# 🔥 Bonfire (한글화 포크)

> **Flutter + Flame** 으로 RPG 게임을 더 쉽고, 객관적이며, 빠르게 만들어 보세요.

[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)
[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue.svg)](https://flutter.dev/)
[![MIT Licence](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![pub package](https://img.shields.io/pub/v/bonfire.svg)](https://pub.dev/packages/bonfire)
[![GitHub stars](https://img.shields.io/github/stars/sigco3111/bonfire?style=social)](https://github.com/sigco3111/bonfire)
[![GitHub Pages](https://img.shields.io/badge/%EB%9D%BC%EC%9D%B4%EB%B8%8C-live-blueviolet)](https://sigco3111.github.io/bonfire/)

<p align="center">
  <img src="media/bonfire.gif" alt="Bonfire 메인 배너" width="60%" />
</p>

<p align="center">
  <b>🎮 라이브 데모: <a href="https://sigco3111.github.io/bonfire/">sigco3111.github.io/bonfire</a> 🎮</b>
</p>

---

## 🎮 Bonfire란?

Bonfire는 **Flutter** 위에 구축된 2D RPG 게임 엔진 라이브러리예요. [FlameEngine](https://flame-engine.org/)의 모든 리소스와 클래스를 그대로 활용하면서, RPG에 자주 쓰이는 다음 기능들을 **쉽게** 쓸 수 있도록 도와줘요.

- 🗺️ **다양한 맵 방식**: Tiled, Spritefusion, 매트릭스/노이즈, 무작위 생성
- 🧙 **플레이어 / NPC / 적**을 상속 한 줄로 추가
- 💬 **대화 시스템** (TalkDialog + Say 블록)
- 🕹️ **다양한 입력**: 키보드 / 마우스 / 터치 / 조이스틱
- ⚔️ **물리 / 힘 / 콜백** 시스템
- 💡 **조명 / 셰이더** 엔진 통합
- 🤖 **AI 행동** (Behavior 시스템)
- 📦 **저장 / 직렬화** 기본 내장

### 한눈에 보기 — Bonfire로 만든 게임 4종

<p align="center">
  <img src="media/video.gif" alt="Bonfire 비디오 데모" width="48%" />
  <img src="media/sunnyplace.gif" alt="Sunny Place 데모" width="48%" />
</p>

<p align="center">
  <img src="media/multi_biome.gif" alt="다중 바이오" width="48%" />
  <img src="media/defector.gif" alt="Defector 게임" width="48%" />
</p>

---

## 📦 설치

`pubspec.yaml`의 `dependencies`에 추가하세요.

```yaml
dependencies:
  flutter:
    sdk: flutter
  bonfire: ^3.17.2
```

그 다음:

```bash
flutter pub get
```

> **최소 사양**: Flutter 3.22 이상 / Dart SDK 3.4 이상

---

## 🚀 빠른 시작 (5분 튜토리얼)

가장 간단한 Bonfire 게임은 **세 가지 핵심 개념** 만 알면 됩니다.

```dart
import 'package:bonfire/bonfire.dart';

class MyGame extends BonfireGame {
  MyGame() : super(
    mapPath: 'maps/my_map.json',       // Tiled 맵 (.json)
    player: KnightPlayer(                // 내 플레이어
      position: Vector2(64, 64),        // 시작 좌표 (픽셀)
      size: Vector2(32, 32),
    ),
    decorations: [],                     // 배경 장식
    enemies: [],                         // 적 캐릭터
    interface: [],                       // HP 바 등 UI
    cameraConfig: CameraConfig(zoom: 1.0),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(game: MyGame()));
}
```

<details>
<summary>📋 단계별 가이드 펼쳐보기</summary>

1. `flutter create my_rpg` — 새 프로젝트 생성
2. `pubspec.yaml`에 `bonfire` 추가
3. **[Tiled](https://www.mapeditor.org/)** 로 맵을 그리고 JSON으로 저장
4. `SimplePlayer` / `SimpleEnemy` / `SimpleNpc` 상속해서 캐릭터 배치
5. `BarLifeComponent` 같은 내장 위젯으로 HUD 구성
6. `onTap` / `onContact` 콜백으로 게임 로직 연결

</details>

---

## 🧩 핵심 컴포넌트 한눈에

| 카테고리 | 핵심 클래스 |
| --- | --- |
| **게임 루프** | `BonfireGame`, `BonfireGameWidget`, `ListenerGameWidget` |
| **맵** | `TiledWorldMap`, `SpritefusionWorldMap`, `TerrainBuilderWorldMap` |
| **플레이어 / NPC / 적** | `SimplePlayer`, `PlatformPlayer`, `RotationPlayer`, `SimpleEnemy`, `SimpleNpc`, `FollowerPlayer` |
| **장식 / 오브젝트** | `GameDecoration`, `FlyingAttackGameObject`, `BarLifeComponent`, `Sensor` |
| **충돌** | `BonfireCollisionConfig`, `QuadTreeCollision`, `RectangleHitbox`, `PolygonHitbox` |
| **조명** | `Lighting`, `LightingComponent`, `LightCircle`, `LightCone` |
| **이동 / 경로 탐색** | `Movement` mixin, `PathFinding`, `AStar` |
| **이펙트 / 셰이더** | `ShaderConfig`, `LightingShader`, `EffectController` |
| **UI / HUD** | `BarLifeWidget`, `KnightInterface`, `TalkDialog`, `Say` |
| **카메라** | `CameraConfig`, `moveToTargetAnimated`, `moveToPlayerAnimated` |
| **입력** | `KeyboardConfig`, `MouseConfig`, `TapGesture`, `DragGesture` |
| **타일드 맵** | `TiledReader`, `TiledWorldMapBuilder`, `Tile`, `MapSensor` |
| **저장** | `BonfireStorage`, `GameComponentStorage`, `PositionStorage` |

> **Tip** — 모든 클래스에 한국어 doc-comment가 박혀 있어요. IDE 자동완성에서 `/**` 라인을 펼치면 한국어 설명이 나옵니다.

---

## 🖥️ 플랫폼 빌드

### 🌐 Web (Flutter Web + GitHub Pages)

```bash
flutter build web --release --base-href "/bonfire/"
```

이 저장소는 **GitHub Actions로 자동 배포**되도록 설정되어 있어요. `master` 브랜치에 push만 하면 [https://sigco3111.github.io/bonfire/](https://sigco3111.github.io/bonfire/)에 자동으로 반영됩니다.

### 📱 Android

`android/app/src/main/AndroidManifest.xml`의 `<application>` 태그 안에 추가:

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="false" />
```

> Impeller 비활성화 권장 — 일부 셰이더와 호환 이슈가 있어요.

### 🍎 iOS · 🖥️ Desktop

추가 설정 없이 빌드됩니다.

---

## 📚 예제 (Examples)

이 저장소는 **80개 이상의 동작 가능한 데모**를 포함합니다.

<p align="center">
  <img src="media/multi_biome.gif" alt="다중 바이오 데모" width="80%" />
</p>

| 영역 | 데모 예시 |
| --- | --- |
| **맵** | Tiled 사용, Spritefusion 사용, 매트릭스 사용 |
| **입력** | 탭, 드래그, 카메라 이동, 마우스, 키보드, 플레이어 컨트롤러 |
| **플레이어** | 단순, 회전, 플랫폼 |
| **적 / NPC** | Enemy (근접/원거리), Forces, 이동 차단 충돌 |
| **조명** | Lighting, Shader |
| **시차** | Parallax, Camera Parallax |
| **미니 게임** | Tiled 맵, 탑다운, 플랫폼, 다중 시나리오, 무작위 맵, 수동 맵, 단순 예제 |

**온라인에서 바로 둘러보기**:
🔗 [https://sigco3111.github.io/bonfire/](https://sigco3111.github.io/bonfire/)

> 페이지 입장 시 좌측 버거 메뉴가 자동으로 펼쳐져 있어요. 메뉴에서 예제 선택 → 우측 상단 **"소스 코드"** 버튼으로 GitHub 코드 즉시 확인.

---

## 🛠️ 유용한 동반 패키지

| 패키지 | 용도 |
| --- | --- |
| `bonfire_bloc` | 게임 상태를 BLoC 패턴으로 관리 |
| `bonfire_spine` | Spine 스켈레탈 애니메이션 |
| `a_star_algorithm` | A* 경로 탐색 (이미 의존성) |
| `flame` | 저수준 게임 엔진 (이미 의존성) |

---

## 🤝 기여

이 저장소는 **원본 [RafaelBarbosatec/bonfire](https://github.com/RafaelBarbosatec/bonfire)의 한글화 포크**입니다. 다음과 같은 기여를 환영해요.

- 🐛 **버그 리포트** — 한글화 후 깨진 게임 동작 발견 시
- 🌏 **번역 개선** — 자연스럽지 않은 한국어 발견 시 PR
- ✨ **문서 보강** — doc-comment 보강, 한국어 튜토리얼 작성
- 🔧 **예제 추가** — 한글로 된 새 NPC 대화 / 미니 게임

**PR 보내실 때 참고**:
- 모든 사용자 대면 텍스트는 한글로 (한영 혼용 금지)
- 식별자 (클래스명 / 메서드명 / 필드명) 절대 한글화 금지
- `flutter analyze` + `flutter test` 통과가 머지 최소 요건

---

## ⚖️ 라이선스

**MIT License** — 자세한 내용은 [LICENSE](LICENSE)를 확인하세요.

> 원본 저작자: **Rafael Barbosa** ([@rafaelbarbosatec](https://github.com/RafaelBarbosatec)) — 2018~현재
> 본 저장소는 원본의 **코드, 빌드 시스템, 자산 구조를 그대로 보존**하면서 **예제 앱의 사용자 대면 텍스트와 라이브러리 dart doc-comment를 한국어로 번역**한 포크입니다. MIT 라이선스와 저작권 표시가 그대로 유지됩니다.

---

## ✨ Credits

* The entire [FlameEngine](https://flame-engine.org/) team
* 모든 기여자와 [Bonfire Telegram](https://t.me/bonfire_engine) 커뮤니티

---

## 🔗 관련 링크

| 항목 | 링크 |
| --- | --- |
| 📖 원본 저장소 | https://github.com/RafaelBarbosatec/bonfire |
| 🌐 한글화 라이브 데모 | https://sigco3111.github.io/bonfire/ |
| 📦 pub.dev 패키지 | https://pub.dev/packages/bonfire |
| 💬 Telegram 채널 | https://t.me/bonfire_engine |
| 🐛 이슈 트래커 | https://github.com/sigco3111/bonfire/issues |
| 📜 원본 사이트 | https://bonfire-engine.github.io |
| 💖 스폰서 | https://github.com/sponsors/rafaelbarbosatec |

---

> 💡 **Tip** — 이 README가 도움이 됐다면 ⭐️ 스타를 눌러주세요. 한 줄짜리 한글화도 큰 기여예요.
