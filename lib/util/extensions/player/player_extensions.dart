import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/geometry/polygon.dart';
import 'package:flutter/widgets.dart';

extension PlayerExtensions on Player {
  /// [radiusVision] 설정 범위 내에 적이 들어왔을 때 감지되면 알림을 받는 메서드입니다.
  /// [update] 메서드 안에서 호출되는 메서드입니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위이며, 별도로 지정하지 않으면 컴포넌트의 방향을 자동으로 사용합니다.
  PolygonShape? seeEnemy({
    required Function(List<Enemy>) observed,
    VoidCallback? notObserved,
    double radiusVision = 32,
    double? visionAngle,
    double? angle,
  }) {
    if (isDead) {
      return null;
    }
    return seeComponentType<Enemy>(
      observed: observed,
      notObserved: notObserved,
      radiusVision: radiusVision,
      angle: angle ?? lastDirection.toRadians(),
      visionAngle: visionAngle,
    );
  }

  void simpleAttackMelee({
    required double damage,
    required Vector2 size,
    Future<SpriteAnimation>? animationRight,
    dynamic id,
    Direction? direction,
    bool withPush = true,
    double? sizePush,
    Vector2? centerOffset,
    double? marginFromCenter,
    bool diagonalEnabled = true,
  }) {
    simpleAttackMeleeByDirection(
      direction: direction ?? _getLastDirection(diagonalEnabled),
      animationRight: animationRight,
      damage: damage,
      id: id,
      size: size,
      withPush: withPush,
      sizePush: sizePush,
      attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
      centerOffset: centerOffset,
      marginFromCenter: marginFromCenter,
    );
  }

  void simpleAttackRange({
    required Future<SpriteAnimation> animationRight,
    required Vector2 size,
    Future<SpriteAnimation>? animationDestroy,
    Vector2? destroySize,
    dynamic id,
    double speed = 150,
    double damage = 1,
    Direction? direction,
    bool withCollision = true,
    bool diagonalEnabled = true,
    VoidCallback? onDestroy,
    ShapeHitbox? collision,
    LightingConfig? lightingConfig,
  }) {
    final attackDirection = direction ?? _getLastDirection(diagonalEnabled);
    simpleAttackRangeByDirection(
      direction: attackDirection,
      animationRight: animationRight,
      animationDestroy: animationDestroy,
      size: size,
      id: id,
      speed: speed,
      damage: damage,
      withCollision: withCollision,
      onDestroy: onDestroy,
      destroySize: destroySize,
      collision: collision,
      lightingConfig: lightingConfig,
      attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
    );
  }

  Direction _getLastDirection(bool diagonalEnabled) {
    if (diagonalEnabled) {
      return lastDirection;
    }

    switch (lastDirection) {
      case Direction.left:
      case Direction.right:
      case Direction.up:
      case Direction.down:
        return lastDirection;
      case Direction.upLeft:
      case Direction.upRight:
      case Direction.downLeft:
      case Direction.downRight:
        return lastDirectionHorizontal;
    }
  }
}
