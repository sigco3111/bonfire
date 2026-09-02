// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bonfire/base/base_game.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/camera/bonfire_camera.dart';
import 'package:bonfire/color_filter/color_filter_component.dart';
import 'package:bonfire/joystick/joystick_map_explorer.dart';
import 'package:bonfire/lighting/lighting_component.dart';
import 'package:flame/camera.dart';
// ignore: implementation_imports
import 'package:flutter/widgets.dart' hide Viewport;

/// Bonfire의 모든 마법이 일어나는 커스텀 게임입니다.
abstract class BonfireGame extends BaseGame implements BonfireGameInterface {
  static const INTERVAL_UPDATE_ORDER = 500;

  /// 게임에서 Flutter의 모든 기능을 사용하기 위한 컨텍스트(context)입니다.
  @override
  final BuildContext context;

  /// 게임에서 사용자가 조작하는 캐릭터를 나타냅니다.
  /// 이 클래스의 인스턴스는 바로 사용할 수 있도록 미리 준비된 동작(actions)과 이동(movements)을 가지고 있습니다.
  @override
  final Player? player;

  /// 체력바, 스테미나, 설정 등 게임 인터페이스에 추가할 요소들을 그리는 방식을 정의합니다.
  /// 즉, 게임 인터페이스에 추가될 수 있는 모든 것을 의미합니다.
  @override
  final GameInterface? interface;

  /// 게임이 진행되는 맵(또는 월드)을 나타냅니다.
  @override
  final GameMap map;

  /// 플레이어를 조작하는 컴포넌트입니다.
  @override
  final List<PlayerController>? playerControllers;

  /// 게임의 배경입니다. 색상 또는 커스텀 컴포넌트가 될 수 있습니다.
  final GameBackground? background;

  /// 타입별 가시(visible) 컴포넌트의 캐시입니다.
  final Map<Type, List<GameComponent>> _visibleComponentsCache = {};

  /// 오브젝트의 충돌 영역(area collision)을 그리는 데 사용됩니다.
  @override
  final bool showCollisionArea;

  /// `showCollisionArea`가 true일 때 충돌 영역의 색상입니다.
  @override
  final Color? collisionAreaColor;

  /// 게임의 조명(lighting) 설정에 사용됩니다.
  final Color? lightingColorGame;

  @override
  final List<Force2D> globalForces;

  @override
  SceneBuilderStatus sceneBuilderStatus = SceneBuilderStatus();

  // final List<GameComponent> _visibleComponents = List.empty(growable: true);
  // final List<ShapeHitbox> _visibleCollisions = List.empty(growable: true);
  late IntervalTick _intervalUpdateOder;

  ValueChanged<BonfireGame>? onReady;

  @override
  LightingInterface get lighting =>
      camera.viewport.children.whereType<LightingInterface>().first;

  @override
  ColorFilterInterface get colorFilter =>
      camera.viewport.children.whereType<ColorFilterInterface>().first;

  @override
  Color backgroundColor() => _bgColor ?? super.backgroundColor();

  Color? _bgColor;

  bool _shouldUpdatePriority = false;

  @override
  BonfireCamera get camera => super.camera as BonfireCamera;

  @override
  set camera(CameraComponent newCameraComponent) {
    throw Exception('Is forbiden updade camera');
  }

  /// 프레임당 가장 높은 렌더링 우선순위를 유지하는 변수입니다.
  /// `interface`, `lighting`, `joystick`의 렌더링 순서를 결정하는 데 사용됩니다.
  int _highestPriority = 1000000;

  /// `_highestPriority`의 게터(getter)입니다.
  @override
  int get highestPriority => _highestPriority;

  BonfireGame({
    required this.context,
    required this.map,
    this.playerControllers,
    this.player,
    this.interface,
    List<GameComponent>? components,
    List<GameComponent>? hudComponents,
    this.background,
    bool debugMode = false,
    this.showCollisionArea = false,
    this.collisionAreaColor,
    this.lightingColorGame,
    this.onReady,
    Color? backgroundColor,
    GameColorFilter? colorFilter,
    CameraConfig? cameraConfig,
    List<Force2D>? globalForces,
  })  : globalForces = globalForces ?? [],
        super(
          camera: BonfireCamera(
            config: cameraConfig,
            viewport: _getViewPort(cameraConfig),
            backdrop: background,
            hudComponents: [
              LightingComponent(
                color: lightingColorGame ?? const Color(0x00000000),
              ),
              ColorFilterComponent(
                colorFilter ?? GameColorFilter(),
              ),
              ...playerControllers ?? [],
              if (interface != null) interface,
              ...hudComponents ?? [],
            ],
          ),
          world: World(
            children: [
              map,
              if (player != null) player,
              ...components ?? [],
            ],
          ),
        ) {
    this.debugMode = debugMode;
    _bgColor = backgroundColor;

    _intervalUpdateOder = IntervalTick(
      INTERVAL_UPDATE_ORDER,
      onTick: _updateOrderPriorityMicrotask,
    );
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    camera.viewport.children.query<PlayerController>().forEach((element) {
      if (!element.containObservers) {
        element.addObserver(
          player ?? JoystickMapExplorer(camera),
        );
      }
    });

    if (camera.config.target != null) {
      camera.follow(
        camera.config.target!,
        snap: true,
      );
    } else if (player != null && camera.config.startFollowPlayer) {
      camera.moveToPlayer();
    }
  }

  bool _gameMounted = false;
  // Frame counter used to keep per-frame caches valid only for the current
  // frame. Incremented every update() call.
  int _frameCounter = 0;
  // Tracks the frame when a given Type cache was last updated.
  final Map<Type, int> _visibleComponentsCacheFrame = {};

  @override
  void update(double dt) {
    super.update(dt);
    _intervalUpdateOder.update(dt);
    // Increment frame counter so per-frame caches are invalidated on the
    // next frame. This keeps cache valid for the entire frame and avoids
    // repeated recomputation when multiple queries happen in the same frame.
    _frameCounter = _frameCounter + 1;
    final containsChildren = camera.world?.children.isNotEmpty == true;
    if (!_gameMounted && containsChildren) {
      _gameMounted = true;
      Future.delayed(Duration.zero, _notifyGameMounted);
    }
  }

  @override
  Iterable<T> visibles<T extends GameComponent>() {
    final cached = _visibleComponentsCache[T];
    final cachedFrame = _visibleComponentsCacheFrame[T];
    if (cached != null && cachedFrame == _frameCounter) {
      return cached.cast<T>();
    }

    // Rebuild cache for this type for the current frame.
    final rebuilt = world.children
        .whereType<T>()
        .where((e) => e.isVisible)
        .toList(growable: false);
    _visibleComponentsCache[T] = rebuilt.cast<GameComponent>();
    _visibleComponentsCacheFrame[T] = _frameCounter;
    return rebuilt;
  }

  @override
  Iterable<Enemy> livingEnemies({bool onlyVisible = false}) {
    return enemies(onlyVisible: onlyVisible)
        .where((element) => !element.isDead);
  }

  @override
  Iterable<Enemy> enemies({bool onlyVisible = false}) {
    return query<Enemy>(onlyVisible: onlyVisible);
  }

  @override
  Iterable<GameDecoration> decorations({bool onlyVisible = false}) {
    return query<GameDecoration>(onlyVisible: onlyVisible);
  }

  @override
  Iterable<Attackable> attackables({bool onlyVisible = false}) {
    return query<Attackable>(onlyVisible: onlyVisible);
  }

  @override
  Iterable<T> query<T extends GameComponent>({bool onlyVisible = false}) {
    if (onlyVisible) {
      return visibles<T>();
    }
    return world.children.query<T>();
  }

  @override
  Vector2 worldToScreen(Vector2 position) {
    final worldPosition = camera.worldToScreen(position);
    return viewportPositionToGlobal(
      worldPosition,
    );
  }

  @override
  Vector2 screenToWorld(Vector2 position) {
    final viewportPosition = globalToViewportPosition(
      position,
    );
    return camera.screenToWorld(viewportPosition);
  }

  @override
  Vector2 globalToViewportPosition(Vector2 position) {
    return camera.viewport.globalToLocal(position);
  }

  @override
  Vector2 viewportPositionToGlobal(Vector2 position) {
    return camera.viewport.localToGlobal(position);
  }

  @override
  bool isVisibleInCamera(PositionComponent c) {
    if (!hasLayout) {
      return false;
    }
    if (c.isRemoving) {
      return false;
    }
    return camera.canSee(c);
  }

  /// 조이스틱(joystick) 이벤트의 기본 옵저버(observer)를 변경하려면 이 메서드를 사용하세요.
  @override
  void addJoystickObserver(
    PlayerControllerListener target, {
    bool cleanObservers = false,
    bool moveCameraToTarget = false,
  }) {
    if (cleanObservers) {
      playerControllers?.forEach(
        (c) => c.cleanObservers(),
      );
    }
    playerControllers?.forEach(
      (c) => c.addObserver(target),
    );
    if (moveCameraToTarget && target is GameComponent) {
      camera.follow(target as GameComponent);
    }
  }

  @override
  void startScene(List<SceneAction> actions, {void Function()? onComplete}) {
    if (!sceneBuilderStatus.isRunning) {
      add(SceneBuilderComponent(actions, onComplete: onComplete));
    }
  }

  @override
  void stopScene() {
    world.children
        .whereType<SceneBuilderComponent>()
        .firstOrNull
        ?.removeFromParent();
  }

  @override
  void onDetach() {
    _notifyGameDetach();
    super.onDetach();
  }

  @override
  void enableGestures(bool enable) {
    enabledGestures = enable;
  }

  @override
  void enableKeyboard(bool enable) {
    enabledKeyboard = enable;
  }

  void requestUpdatePriority() {
    _shouldUpdatePriority = true;
  }

  @override
  FutureOr<void> add(Component component) {
    if (component is CameraComponent || component is World) {
      super.add(component);
    } else {
      return world.add(component);
    }
  }

  @override
  Future<void> addAll(Iterable<Component> components) {
    return world.addAll(components);
  }

  /// 우선순위에 따라 컴포넌트 순서를 재정렬합니다.
  void _updateOrderPriority() {
    world.rebalanceChildren();
    _highestPriority = world.children.last.priority;
  }

  /// 애니메이션 등 다양한 용도로 사용할 값을 생성하는 데 사용됩니다.
  @override
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
  }) {
    final valueGenerator = ValueGeneratorComponent(
      duration,
      end: end,
      begin: begin,
      curve: curve,
      reverseCurve: reverseCurve,
      onFinish: onFinish,
      onChange: onChange,
      autoStart: autoStart,
      infinite: infinite,
    );
    add(valueGenerator);
    return valueGenerator;
  }

  void _updateOrderPriorityMicrotask() {
    if (_shouldUpdatePriority) {
      _shouldUpdatePriority = false;
      _updateOrderPriority();
    }
  }

  void _notifyGameMounted() {
    void gameMontedComp(GameComponent c) => c.onGameMounted();
    query<GameComponent>().forEach(gameMontedComp);
    camera.world?.children.query<GameComponent>().forEach(gameMontedComp);
    onReady?.call(this);
  }

  void _notifyGameDetach() {
    FollowerWidget.removeAll();
    void gameDetachComp(GameComponent c) => c.onGameDetach();
    query<GameComponent>().forEach(gameDetachComp);
    for (final child in camera.children) {
      if (child is GameComponent) {
        child.onGameDetach();
      }
      child.children.query<GameComponent>().forEach(gameDetachComp);
    }
  }

  @override
  Vector2 get worldsize => map.size;

  @override
  Iterable<T> queryHud<T extends Component>() {
    return camera.viewport.children.query<T>();
  }

  @override
  FutureOr<void> addHud(Component component) {
    return camera.viewport.add(component);
  }

  static Viewport? _getViewPort(CameraConfig? cameraConfig) {
    if (cameraConfig?.resolution != null) {
      return FixedResolutionViewport(
        resolution: cameraConfig!.resolution!,
      );
    }
    return null;
  }
}
