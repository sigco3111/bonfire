import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';

/// [Enemy]에서 사용할 수 있는 유틸 함수들입니다.
extension EnemyExtensions on Enemy {
  /// 애니메이션을 사용해 단순 근접 공격을 실행합니다.
  void simpleAttackMelee({
    required double damage,
    required Vector2 size,
    int? id,
    int interval = 1000,
    bool withPush = false,
    double? sizePush,
    Direction? direction,
    Future<SpriteAnimation>? animationRight,
    VoidCallback? execute,
    Vector2? centerOffset,
  }) {
    if (!checkInterval('attackMelee', interval, lastDt) || isDead) {
      return;
    }

    final direct = direction ??
        (gameRef.player != null
            ? getDirectionToTarget(gameRef.player!)
            : lastDirection);

    simpleAttackMeleeByDirection(
      damage: damage,
      direction: direct,
      size: size,
      id: id,
      withPush: withPush,
      sizePush: sizePush,
      animationRight: animationRight,
      attackFrom: AttackOriginEnum.ENEMY,
      centerOffset: centerOffset,
    );

    execute?.call();
  }

  /// 애니메이션이 있는 컴포넌트를 사용해 원거리 공격을 실행합니다.
  void simpleAttackRange({
    required Future<SpriteAnimation> animation,
    required Future<SpriteAnimation> animationDestroy,
    required Vector2 size,
    Vector2? destroySize,
    int? id,
    double speed = 150,
    double damage = 1,
    int interval = 1000,
    bool withCollision = true,
    bool useAngle = false,
    ShapeHitbox? collision,
    VoidCallback? onDestroy,
    VoidCallback? execute,
    LightingConfig? lightingConfig,
  }) {
    if (!checkInterval('attackRange', interval, lastDt) || isDead) {
      return;
    }

    if (useAngle) {
      simpleAttackRangeByAngle(
        animation: animation,
        animationDestroy: animationDestroy,
        size: size,
        angle: getAngleToPlayer(),
        id: id,
        speed: speed,
        damage: damage,
        withDecorationCollision: withCollision,
        collision: collision,
        onDestroy: onDestroy,
        destroySize: destroySize,
        lightingConfig: lightingConfig,
        attackFrom: AttackOriginEnum.ENEMY,
      );
    } else {
      final direct = gameRef.player != null
          ? getDirectionToTarget(gameRef.player!)
          : lastDirection;
      simpleAttackRangeByDirection(
        animationRight: animation,
        animationDestroy: animationDestroy,
        size: size,
        direction: direct,
        id: id,
        speed: speed,
        damage: damage,
        withCollision: withCollision,
        collision: collision,
        onDestroy: onDestroy,
        destroySize: destroySize,
        lightingConfig: lightingConfig,
        attackFrom: AttackOriginEnum.ENEMY,
      );
    }

    execute?.call();
  }

  /// 플레이어가 범위 안에 있는지 확인하고, 범위 안에 있으면 플레이어 쪽으로 이동합니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위이며, 별도로 지정하지 않으면 컴포넌트의 방향을 자동으로 사용합니다.
  void seeAndMoveToAttackRange({
    Function(Player)? positioned,
    // return true to stop move.
    BoolCallback? notObserved,
    Function(Player)? observed,
    double radiusVision = 32,
    double? visionAngle,
    double? angle,
    double? minDistanceFromPlayer,
    bool useDiagonal = true,
    // bool useDiagonal = true,
  }) {
    if (minDistanceFromPlayer != null) {
      assert(minDistanceFromPlayer < radiusVision);
    }

    if (isDead) {
      return;
    }

    seePlayer(
      radiusVision: radiusVision,
      visionAngle: visionAngle,
      angle: angle,
      observed: (player) {
        observed?.call(player);
        final minD = minDistanceFromPlayer ?? (radiusVision - 5);
        if (useDiagonal) {
          final inDistance = keepDistance(
            player,
            minD,
          );
          if (inDistance) {
            final playerDirection = getDirectionToTarget(player);
            lastDirection = playerDirection;
            if (lastDirection == Direction.left ||
                lastDirection == Direction.right) {
              lastDirectionHorizontal = lastDirection;
            }

            if (checkInterval('seeAndMoveToAttackRange', 500, lastDt)) {
              stopMove();
            }
            positioned?.call(player);
          }
        } else {
          positionsItselfAndKeepDistance(
            player,
            minDistanceFromPlayer: minD,
            radiusVision: radiusVision,
            positioned: (player) {
              final playerDirection = getDirectionToTarget(player);
              lastDirection = playerDirection;
              if (lastDirection == Direction.left ||
                  lastDirection == Direction.right) {
                lastDirectionHorizontal = lastDirection;
              }

              if (checkInterval('seeAndMoveToAttackRange', 500, lastDt)) {
                stopMove();
              }
              positioned?.call(player);
            },
          );
        }
      },
      notObserved: () {
        final stop = notObserved?.call() ?? true;
        if (stop) {
          stopMove(forceIdle: true);
        }
      },
    );
  }
}
