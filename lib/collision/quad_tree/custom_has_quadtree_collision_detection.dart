import 'package:bonfire/collision/quad_tree/custom_collision_detection.dart';
import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';

/// QuadTree 충돌 지원을 사용하려면 [FlameGame]에 이 mixin을 적용해야 합니다.
///
/// 게임 내에 충돌 가능한 엔티티가 많지만 그중 대부분이 정적(예: 플랫폼, 벽, 나무, 건물)이라면
/// [HasQuadTreeCollisionDetection]을 사용하세요.
///
/// 어떤 충돌 감지 방식을 사용할지는 항상 실험으로 결정하세요. 기본
/// [HasCollisionDetection] mixin이 더 나은 성능을 보이는 경우도 흔합니다.
///
/// [initializeCollisionDetection]은 게임의 [onLoad] 메서드 안에서 호출되어야 합니다.
mixin CustomHasQuadTreeCollisionDetection<W extends World> on FlameGame<W>
    implements HasCollisionDetection<QuadTreeBroadphase> {
  late CustomQuadTreeCollisionDetection _collisionDetection;

  @override
  CustomQuadTreeCollisionDetection get collisionDetection =>
      _collisionDetection;

  @override
  set collisionDetection(
    CollisionDetection<ShapeHitbox, QuadTreeBroadphase> cd,
  ) {
    if (cd is! CustomQuadTreeCollisionDetection) {
      throw 'Must be CustomQuadTreeCollisionDetection!';
    }
    _collisionDetection = cd;
  }

  /// QuadTree를 초기화합니다.
  ///
  /// - [mapDimensions]은 충돌 영역의 좌표와 크기를 나타냅니다.
  /// 게임 맵의 위치와 크기와 일치해야 합니다.
  /// - [maxObjects] (선택) - 한 사분면(quadrant)이 가질 수 있는 최대 객체 수입니다.
  /// - [maxLevels] (선택) - 중첩 가능한 사분면의 최대 깊이입니다.
  /// - [minimumDistance] (선택) - 충돌 가능성을 판단하기 위한 객체 간 최소 거리입니다.
  /// 커스텀 동작이 필요하면 [minimumDistanceCheck]를 직접 구현할 수도 있습니다.
  ///
  /// [onComponentTypeCheck]는 서로 다른 타입의 객체가 충돌해야 하는지 확인합니다.
  /// 계산 결과는 캐시되므로 여기에서는 동적인 파라미터를 검사하지 마세요.
  /// 이 함수는 순수한 타입 검사 용도로 사용됩니다.
  /// 일반적으로 오버라이드할 필요는 없으며, 대신
  /// [CollisionCallbacks.onComponentTypeCheck]를 참고하세요.
  void initializeCollisionDetection({
    required Rect mapDimensions,
    double? minimumDistance,
    int maxObjects = 25,
    int maxLevels = 10,
  }) {
    _collisionDetection = CustomQuadTreeCollisionDetection(
      mapDimensions: mapDimensions,
      maxDepth: maxLevels,
      maxObjects: maxObjects,
      onComponentTypeCheck: onComponentTypeCheck,
      minimumDistanceCheck: minimumDistanceCheck,
    );
    this.minimumDistance = minimumDistance;
  }

  double? minimumDistance;

  bool minimumDistanceCheck(Vector2 activeItemCenter, Vector2 potentialCenter) {
    return minimumDistance == null ||
        !((activeItemCenter.x - potentialCenter.x).abs() > minimumDistance! ||
            (activeItemCenter.y - potentialCenter.y).abs() > minimumDistance!);
  }

  bool onComponentTypeCheck(ShapeHitbox first, ShapeHitbox second) {
    return first.onComponentTypeCheck(second) &&
        second.onComponentTypeCheck(first);
  }

  @override
  void update(double dt) {
    super.update(dt);
    collisionDetection.run();
  }
}
