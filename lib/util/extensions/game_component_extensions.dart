import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';

extension GameComponentExtensions on GameComponent {
  /// 받은 데미지를 애니메이션과 함께 텍스트로 표시하여 게임에 추가합니다.
  void showDamage(
    double damage, {
    TextStyle? config,
    double initVelocityVertical = -5,
    double initVelocityHorizontal = 1,
    double gravity = 0.5,
    double maxDownSize = 20,
    DirectionTextDamage direction = DirectionTextDamage.RANDOM,
    bool onlyUp = false,
  }) {
    if (!hasGameRef) {
      return;
    }
    gameRef.add(
      TextDamageComponent(
        damage.toInt().toString(),
        Vector2(rectCollision.center.dx, rectCollision.top),
        config: config ??
            const TextStyle(
              fontSize: 14,
              color: Color(0xFFFFFFFF),
            ),
        initVelocityVertical: initVelocityVertical,
        initVelocityHorizontal: initVelocityHorizontal,
        gravity: gravity,
        direction: direction,
        onlyUp: onlyUp,
        maxDownSize: maxDownSize,
      ),
    );
  }

  /// 애니메이션이 있는 컴포넌트를 사용해 원거리 공격을 실행합니다.
  void simpleAttackRangeByAngle({
    /// 오른쪽을 향한 애니메이션을 사용합니다.
    required Future<SpriteAnimation> animation,
    required Vector2 size,

    /// 라디안(radians) 각도를 사용합니다.
    required double angle,
    required double damage,
    required AttackOriginEnum attackFrom,
    Vector2? destroySize,
    Future<SpriteAnimation>? animationDestroy,
    dynamic id,
    double speed = 150,
    bool withDecorationCollision = true,
    VoidCallback? onDestroy,
    ShapeHitbox? collision,
    LightingConfig? lightingConfig,
    double marginFromOrigin = 16,
    Vector2? centerOffset,
  }) {
    final initPosition = rectCollision;

    var startPosition =
        initPosition.center.toVector2() + (centerOffset ?? Vector2.zero());

    final displacement =
        max(initPosition.width, initPosition.height) / 2 + marginFromOrigin;

    startPosition = BonfireUtil.movePointByAngle(
      startPosition,
      displacement,
      angle,
    );

    gameRef.add(
      FlyingAttackGameObject.byAngle(
        id: id,
        position: startPosition,
        size: size,
        angle: angle,
        damage: damage,
        speed: speed,
        attackFrom: attackFrom,
        collision: collision,
        withDecorationCollision: withDecorationCollision,
        onDestroy: onDestroy,
        destroySize: destroySize,
        animation: animation,
        animationDestroy: animationDestroy,
        lightingConfig: lightingConfig,
      ),
    );
  }

  /// 애니메이션이 있는 컴포넌트를 사용해 원거리 공격을 실행합니다.
  void simpleAttackRangeByDirection({
    required Future<SpriteAnimation> animationRight,
    required Vector2 size,
    required Direction direction,
    required AttackOriginEnum attackFrom,
    Vector2? destroySize,
    dynamic id,
    double speed = 150,
    double damage = 1,
    bool withCollision = true,
    VoidCallback? onDestroy,
    ShapeHitbox? collision,
    LightingConfig? lightingConfig,
    Future<SpriteAnimation>? animationDestroy,
    double marginFromOrigin = 16,
    Vector2? centerOffset,
  }) {
    simpleAttackRangeByAngle(
      angle: direction.toRadians(),
      animation: animationRight,
      attackFrom: attackFrom,
      damage: damage,
      size: size,
      animationDestroy: animationDestroy,
      centerOffset: centerOffset,
      marginFromOrigin: marginFromOrigin,
      collision: collision,
      destroySize: destroySize,
      id: id,
      lightingConfig: lightingConfig,
      onDestroy: onDestroy,
      speed: speed,
      withDecorationCollision: withCollision,
    );
  }

  /// 애니메이션을 사용해 단순 근접 공격을 실행합니다.
  void simpleAttackMeleeByDirection({
    required double damage,
    required Direction direction,
    required Vector2 size,
    required AttackOriginEnum attackFrom,
    Future<SpriteAnimation>? animationRight,
    dynamic id,
    bool withPush = true,
    double? sizePush,
    double? marginFromCenter,
    Vector2? centerOffset,
    void Function(Attackable attackable)? onDamage,
  }) {
    final rect = rectCollision;
    simpleAttackMeleeByAngle(
      angle: direction.toRadians(),
      animation: animationRight,
      attackFrom: attackFrom,
      damage: damage,
      size: size,
      centerOffset: centerOffset,
      marginFromCenter: marginFromCenter ?? max(rect.width, rect.height) / 2,
      id: id,
      withPush: withPush,
      onDamage: onDamage,
    );
  }

  /// 애니메이션을 사용해 단순 근접 공격을 실행합니다.
  void simpleAttackMeleeByAngle({
    required double damage,

    /// 라디안(radians) 각도를 사용합니다.
    required double angle,
    required AttackOriginEnum attackFrom,
    required Vector2 size,
    dynamic id,

    /// 오른쪽을 향한 애니메이션을 사용합니다.
    Future<SpriteAnimation>? animation,
    bool withPush = true,
    double marginFromCenter = 0,
    Vector2? centerOffset,
    void Function(Attackable attackable)? onDamage,
  }) {
    final initPosition = rectCollision;

    final startPosition =
        initPosition.center.toVector2() + (centerOffset ?? Vector2.zero());

    final displacement = max(
              initPosition.width,
              initPosition.height,
            ) /
            2 +
        marginFromCenter;

    final diffBase = BonfireUtil.diffMovePointByAngle(
      startPosition,
      displacement,
      angle,
    );

    startPosition.add(diffBase);

    if (animation != null) {
      gameRef.add(
        AnimatedGameObject(
          animation: animation,
          position: startPosition,
          size: size,
          angle: angle,
          anchor: Anchor.center,
          loop: false,
          renderAboveComponents: true,
        ),
      );
    }

    gameRef.add(
      DamageHitbox(
        position: startPosition,
        damage: damage,
        origin: attackFrom,
        size: size,
        angle: angle,
        id: id,
        onDamage: (attackable) {
          onDamage?.call(attackable);
          if (withPush && attackable is Movement) {
            _doPush(
              attackable as Movement,
              BonfireUtil.getDirectionFromAngle(angle),
              diffBase,
            );
          }
        },
      ),
    );
  }

  double get top => position.y;
  double get bottom => absolutePositionOfAnchor(Anchor.bottomRight).y;
  double get left => position.x;
  double get right => absolutePositionOfAnchor(Anchor.bottomRight).x;

  bool overlaps(Rect other) {
    if (right <= other.left || other.right <= left) {
      return false;
    }
    if (bottom <= other.top || other.bottom <= top) {
      return false;
    }
    return true;
  }

  Direction? directionThePlayerIsIn() {
    final player = gameRef.player;
    if (player == null) {
      return null;
    }
    var diffX = center.x - player.center.x;
    final diffPositiveX = diffX < 0 ? diffX *= -1 : diffX;
    var diffY = center.y - player.center.y;
    final diffPositiveY = diffY < 0 ? diffY *= -1 : diffY;

    if (diffPositiveX > diffPositiveY) {
      if (player.center.x > center.x) {
        return Direction.right;
      } else if (player.center.x < center.x) {
        return Direction.left;
      }
    } else {
      if (player.center.y > center.y) {
        return Direction.down;
      } else if (player.center.y < center.y) {
        return Direction.up;
      }
    }

    return null;
  }

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

  /// 컴포넌트에 파티클을 추가할 때 사용됩니다.
  void addParticle(
    Particle particle, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
    ComponentKey? key,
  }) {
    add(
      ParticleSystemComponent(
        particle: particle,
        position: position,
        size: size,
        scale: scale,
        angle: angle,
        anchor: anchor,
        priority: priority,
        key: key,
      ),
    );
  }

  /// 이 컴포넌트에서 타겟으로 향하는 각도를 구합니다.
  double getAngleToTarget(GameComponent target) {
    return BonfireUtil.angleBetweenPointsOffset(
      rectCollision.center,
      target.rectCollision.center,
    );
  }

  Direction getDirectionToTarget(
    GameComponent target, {
    bool withDiagonal = true,
  }) {
    return BonfireUtil.getDirectionFromAngle(
      getAngleToTarget(target),
      directionSpace: withDiagonal ? 2.5 : 45,
    );
  }

  Future<ParallaxComponent> loadParallaxComponent(
    Iterable<ParallaxData> dataList, {
    Vector2? baseVelocity,
    Vector2? velocityMultiplierDelta,
    ImageRepeat repeat = ImageRepeat.repeatX,
    Alignment alignment = Alignment.bottomLeft,
    LayerFill fill = LayerFill.height,
    Images? images,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
    FilterQuality? filterQuality,
    ComponentKey? key,
  }) {
    return ParallaxComponent.load(
      dataList,
      baseVelocity: baseVelocity,
      velocityMultiplierDelta: velocityMultiplierDelta,
      repeat: repeat,
      alignment: alignment,
      fill: fill,
      images: images,
      position: position,
      size: size ?? gameRef.camera.canvasSize,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority,
      filterQuality: filterQuality,
      key: key,
    );
  }

  Future<ParallaxComponent> loadCameraParallaxComponent(
    Iterable<ParallaxData> dataList, {
    Vector2? baseVelocity,
    Vector2? velocityMultiplierDelta,
    ImageRepeat repeat = ImageRepeat.repeatX,
    Alignment alignment = Alignment.bottomLeft,
    LayerFill fill = LayerFill.height,
    Images? images,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
    FilterQuality? filterQuality,
    ComponentKey? key,
  }) {
    return CameraParallaxComponent.load(
      dataList,
      baseVelocity: baseVelocity,
      velocityMultiplierDelta: velocityMultiplierDelta,
      repeat: repeat,
      alignment: alignment,
      fill: fill,
      images: images,
      position: position,
      size: size ?? gameRef.camera.canvasSize,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority,
      filterQuality: filterQuality,
      key: key,
    );
  }

  void _doPush(
    Movement comp,
    Direction directionFromAngle,
    Vector2 displacement,
  ) {
    if (comp.canMove(
      directionFromAngle,
      displacement: displacement.maxValue(),
    )) {
      comp.translate(displacement);
    }
  }

  Offset globalToViewportPosition(Offset position) {
    if (!hasGameRef) {
      return position;
    }
    return gameRef.globalToViewportPosition(position.toVector2()).toOffset();
  }

  Offset viewportPositionToGlobal(Offset position) {
    if (!hasGameRef) {
      return position;
    }
    return gameRef.viewportPositionToGlobal(position.toVector2()).toOffset();
  }

  bool isCloseTo(GameComponent target, {double distance = 5}) {
    final rectPlayerCollision = target.rectCollision.inflate(distance);
    return rectCollision.overlaps(rectPlayerCollision);
  }
}
