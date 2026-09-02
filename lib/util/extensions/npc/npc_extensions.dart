import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/geometry/shape.dart';

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
/// on 22/03/22

extension NpcExtensions on Npc {
  /// [radiusVision] 설정 범위 내에 플레이어가 들어왔을 때 감지되면 알림을 받는 메서드입니다.
  /// [update] 메서드 안에서 사용해야 하는 메서드입니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위이며, 별도로 지정하지 않으면 컴포넌트의 방향을 자동으로 사용합니다.
  Shape? seePlayer({
    required Function(Player) observed,
    VoidCallback? notObserved,
    double radiusVision = 32,
    double? visionAngle,
    double? angle,
  }) {
    final player = gameRef.player;
    if (player == null || player.isDead) {
      notObserved?.call();
      return null;
    }
    return seeComponent(
      player,
      observed: (c) => observed(c as Player),
      notObserved: notObserved,
      radiusVision: radiusVision,
      visionAngle: visionAngle,
      angle: angle ?? lastDirection.toRadians(),
    );
  }

  /// 플레이어가 범위 안에 있는지 확인하고, 범위 안에 있으면 플레이어 쪽으로 이동합니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위이며, 별도로 지정하지 않으면 컴포넌트의 방향을 자동으로 사용합니다.
  Shape? seeAndMoveToPlayer({
    Function(Player)? closePlayer,
    // return true to stop move.
    BoolCallback? notObserved,
    VoidCallback? observed,
    VoidCallback? notCanMove,
    double radiusVision = 32,
    double margin = 2,
    double? visionAngle,
    double? angle,
    bool runOnlyVisibleInScreen = true,
    MovementAxis movementAxis = MovementAxis.all,
  }) {
    if (runOnlyVisibleInScreen && !isVisible) {
      return null;
    }

    return seePlayer(
      radiusVision: radiusVision,
      visionAngle: visionAngle,
      angle: angle,
      observed: (player) {
        observed?.call();
        final move = moveTowardsTarget(
          target: player,
          close: () => closePlayer?.call(player),
          margin: margin,
          movementAxis: movementAxis,
        );
        if (!move) {
          notCanMove?.call();
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

  /// 적이 범위 안에 있는지 확인하고, 범위 안에 있으면 적 쪽으로 이동합니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위이며, 별도로 지정하지 않으면 컴포넌트의 방향을 자동으로 사용합니다.
  void seeAndMoveToEnemy({
    required Function(Enemy) closeEnemy,
    // return true to stop move.
    BoolCallback? notObserved,
    VoidCallback? observed,
    VoidCallback? notCanMove,
    double radiusVision = 32,
    double? visionAngle,
    double? angle,
    double margin = 10,
    bool runOnlyVisibleInScreen = true,
    MovementAxis movementAxis = MovementAxis.all,
  }) {
    if (runOnlyVisibleInScreen && !isVisible) {
      return;
    }

    seeComponentType<Enemy>(
      radiusVision: radiusVision,
      visionAngle: visionAngle,
      angle: angle ?? lastDirection.toRadians(),
      observed: (enemy) {
        observed?.call();
        final move = moveTowardsTarget(
          target: enemy.first,
          close: () {
            closeEnemy(enemy.first);
          },
          margin: margin,
          movementAxis: movementAxis,
        );
        if (!move) {
          notCanMove?.call();
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

  /// 아군(ally)이 범위 안에 있는지 확인하고, 범위 안에 있으면 아군 쪽으로 이동합니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위이며, 별도로 지정하지 않으면 컴포넌트의 방향을 자동으로 사용합니다.
  void seeAndMoveToAlly({
    required Function(Ally) closeAlly,
    // return true to stop move.
    BoolCallback? notObserved,
    VoidCallback? observed,
    VoidCallback? notCanMove,
    double radiusVision = 32,
    double? visionAngle,
    double? angle,
    double margin = 10,
    bool runOnlyVisibleInScreen = true,
    MovementAxis movementAxis = MovementAxis.all,
  }) {
    if (runOnlyVisibleInScreen && !isVisible) {
      return;
    }

    seeComponentType<Ally>(
      radiusVision: radiusVision,
      visionAngle: visionAngle,
      angle: angle ?? lastDirection.toRadians(),
      observed: (ally) {
        observed?.call();
        final move = moveTowardsTarget(
          target: ally.first,
          close: () {
            closeAlly(ally.first);
          },
          movementAxis: movementAxis,
          margin: margin,
        );
        if (!move) {
          notCanMove?.call();
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

  /// 이 컴포넌트 기준 플레이어가 있는 방향을 반환합니다.
  Direction? getDirectionToPlayer() {
    final player = gameRef.player;
    if (player == null) {
      return null;
    }
    return getDirectionToTarget(player);
  }

  /// 적과 플레이어 사이의 각도를 구합니다.
  /// 플레이어를 기준으로 합니다.
  double getAngleToPlayer() {
    final player = gameRef.player;
    if (player == null) {
      return 0.0;
    }
    return getAngleToTarget(player);
  }

  /// 적과 플레이어 사이의 각도를 구합니다.
  /// 적 위치를 기준으로 합니다.
  double getInverseAngleToPlayer() {
    final player = gameRef.player;
    if (player == null) {
      return 0.0;
    }
    return BonfireUtil.angleBetweenPoints(
      playerRect.center.toVector2(),
      rectCollision.centerVector2,
    );
  }

  /// 계산에서 기준으로 사용되는 플레이어의 위치(Rect)를 가져옵니다.
  Rect get playerRect {
    return gameRef.player?.rectCollision ?? Rect.zero;
  }
}
