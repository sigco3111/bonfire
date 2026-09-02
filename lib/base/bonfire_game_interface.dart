import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/camera/bonfire_camera.dart';
import 'package:bonfire/color_filter/color_filter_component.dart';
import 'package:bonfire/lighting/lighting_component.dart';
// ignore: implementation_imports
import 'package:flame/src/game/overlay_manager.dart';
import 'package:flutter/widgets.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 19/11/21

abstract class BonfireGameInterface {
  BuildContext get context;
  Player? get player;
  List<PlayerController>? get playerControllers;
  LightingInterface? get lighting;
  ColorFilterInterface? get colorFilter;
  BonfireCamera get camera;
  GameMap get map;
  int get highestPriority;
  Vector2 get size;
  Vector2 get worldsize;
  bool get hasLayout;
  bool get showCollisionArea;
  Color? get collisionAreaColor;
  GameInterface? get interface;
  List<Force2D> get globalForces;
  SceneBuilderStatus sceneBuilderStatus = SceneBuilderStatus();
  double timeScale = 1.0;

  // ignore: invalid_use_of_internal_member
  OverlayManager get overlays;

  /// 엔진(Engine)을 일시 정지할 때 사용됩니다.
  void pauseEngine();

  /// 엔진이 현재 일시 정지 상태인지 실행 중인지 여부를 반환합니다.
  bool get paused;

  /// 엔진(Engine)을 재개할 때 사용됩니다.
  void resumeEngine();

  /// 게임에 컴포넌트를 추가할 때 사용됩니다.
  FutureOr<void> add(Component component);

  /// 게임에 컴포넌트 리스트를 추가할 때 사용됩니다.
  Future<void> addAll(List<Component> components);

  /// 화면에 보이는(visible) "Components"를 가져올 때 사용됩니다.
  Iterable<T> visibles<T extends GameComponent>();

  /// 모든 "Enemies" 또는 보이는 것만 가져올 때 사용됩니다.
  Iterable<Enemy> enemies({bool onlyVisible = false});

  /// 살아있는 "Enemies" 또는 보이는 것만 가져올 때 사용됩니다.
  Iterable<Enemy> livingEnemies({bool onlyVisible = false});

  /// 모든 "Decoration" 또는 보이는 것만 가져올 때 사용됩니다.
  Iterable<GameDecoration> decorations({bool onlyVisible = false});

  /// 모든 "Attackables" 또는 보이는 것만 가져올 때 사용됩니다.
  Iterable<Attackable> attackables({bool onlyVisible = false});

  /// 모든 "ShapeHitbox"를 가져올 때 사용됩니다.
  Iterable<ShapeHitbox> collisions({bool onlyVisible = false});

  /// 타입(type)으로 컴포넌트를 찾을 때 사용됩니다(가시/비가시 모두).
  Iterable<T> query<T extends GameComponent>({bool onlyVisible = false});

  /// 월드 좌표(world position)를 화면 좌표(screen position)로 변환하는 메서드입니다.
  Vector2 worldToScreen(Vector2 worldPosition);

  /// 화면 좌표(screen position)를 월드 좌표(world position)로 변환하는 메서드입니다.
  Vector2 screenToWorld(Vector2 screenPosition);

  /// 뷰포트 좌표(viewport position)를 월드 좌표(world position)로 변환하는 메서드입니다.
  Vector2 globalToViewportPosition(Vector2 position);

  /// 뷰포트 좌표(viewport position)를 화면 좌표(screen position)로 변환하는 메서드입니다.
  Vector2 viewportPositionToGlobal(Vector2 position);

  /// 컴포넌트가 카메라에 보이는지 확인할 때 사용됩니다.
  bool isVisibleInCamera(PositionComponent c);

  /// 조이스틱 리스너를 변경하고, 카메라를 새로운 타겟으로 이동시킬 때 사용됩니다.
  void addJoystickObserver(
    PlayerControllerListener target, {
    bool cleanObservers = false,
    bool moveCameraToTarget = false,
  });

  /// hud 컴포넌트를 가져올 때 사용됩니다.
  Iterable<T> queryHud<T extends Component>();

  /// 게임에 hud 컴포넌트를 추가할 때 사용됩니다.
  FutureOr<void> addHud(Component component);

  RaycastResult<ShapeHitbox>? raycast(
    Ray2 ray, {
    double? maxDistance,
    List<ShapeHitbox>? ignoreHitboxes,
    RaycastResult<ShapeHitbox>? out,
  });

  List<RaycastResult<ShapeHitbox>> raycastAll(
    Vector2 origin, {
    required int numberOfRays,
    double startAngle = 0,
    double sweepAngle = tau,
    double? maxDistance,
    List<Ray2>? rays,
    List<ShapeHitbox>? ignoreHitboxes,
    List<RaycastResult<ShapeHitbox>>? out,
  });

  Iterable<RaycastResult<ShapeHitbox>> raytrace(
    Ray2 ray, {
    int maxDepth = 10,
    List<ShapeHitbox>? ignoreHitboxes,
    List<RaycastResult<ShapeHitbox>>? out,
  });

  /// 애니메이션 등 다양한 용도로 사용할 값을 생성하는 데 사용됩니다.
  ValueGeneratorComponent generateValues(
    Duration duration, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.linear,
    Curve? reverseCurve,
    bool autoStart = true,
    bool infinite = false,
    VoidCallback? onFinish,
    ValueChanged<double>? onChange,
  });

  void startScene(List<SceneAction> actions, {void Function()? onComplete});
  void stopScene();

  void enableGestures(bool enable);
  void enableKeyboard(bool enable);
  bool get enabledGestures;
  bool get enabledKeyboard;

  void configCollisionDetection(Rect mapDimensions);
}
