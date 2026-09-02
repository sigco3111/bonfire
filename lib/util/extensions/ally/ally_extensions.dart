import 'dart:ui';

import 'package:bonfire/bonfire.dart';

///
/// 작성자 (Created by)
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 24/03/22
extension AllyExtensions on Ally {
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

    final direct = direction ?? lastDirection;

    simpleAttackMeleeByDirection(
      damage: damage,
      direction: direct,
      size: size,
      id: id,
      withPush: withPush,
      sizePush: sizePush,
      animationRight: animationRight,
      attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
      centerOffset: centerOffset,
    );

    execute?.call();
  }

  /// 애니메이션이 있는 컴포넌트를 사용해 원거리 공격을 실행합니다.
  void simpleAttackRange({
    required Future<SpriteAnimation> animationRight,
    required Future<SpriteAnimation> animationDestroy,
    required Vector2 size,
    Vector2? destroySize,
    int? id,
    double speed = 150,
    double damage = 1,
    Direction? direction,
    int interval = 1000,
    bool withCollision = true,
    ShapeHitbox? collision,
    VoidCallback? onDestroy,
    VoidCallback? execute,
    LightingConfig? lightingConfig,
  }) {
    if (!checkInterval('attackRange', interval, lastDt) || isDead) {
      return;
    }

    final direct = direction ?? lastDirection;

    simpleAttackRangeByDirection(
      animationRight: animationRight,
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
      attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
    );

    execute?.call();
  }

  /// 적이 범위 안에 있는지 확인하고, 범위 안에 있으면 적 쪽으로 이동합니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위이며, 별도로 지정하지 않으면 컴포넌트의 방향을 자동으로 사용합니다.
  void seeAndMoveToAttackRange({
    Function(Enemy)? positioned,
    // return true to stop move.
    BoolCallback? notObserved,
    Function(Enemy)? observed,
    double radiusVision = 32,
    double? visionAngle,
    double? angle,
    double? minDistanceFromPlayer,
    bool runOnlyVisibleInScreen = true,
  }) {
    if (isDead) {
      return;
    }

    seeComponentType<Enemy>(
      radiusVision: radiusVision,
      angle: angle ?? lastDirection.toRadians(),
      visionAngle: visionAngle,
      observed: (enemy) {
        final e = enemy.first;
        observed?.call(e);
        final inDistance = keepDistance(
          e,
          minDistanceFromPlayer ?? (radiusVision - 5),
        );
        if (inDistance) {
          final playerDirection = getDirectionToTarget(e);
          lastDirection = playerDirection;
          if (lastDirection == Direction.left ||
              lastDirection == Direction.right) {
            lastDirectionHorizontal = lastDirection;
          }

          if (checkInterval('seeAndMoveToAttackRange', 500, lastDt)) {
            stopMove();
          }
          positioned?.call(e);
        }
      },
      notObserved: () {
        final stop = notObserved?.call() ?? true;
        if (stop) {
          stopMove();
        }
      },
    );
  }
}
