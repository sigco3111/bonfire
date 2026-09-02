import 'package:bonfire/mixins/direction_animation.dart';
import 'package:bonfire/npc/enemy/enemy.dart';
import 'package:bonfire/util/direction.dart';
import 'package:bonfire/util/direction_animations/simple_direction_animation.dart';

/// 모든 방향 애니메이션을 가진 적(enemy)입니다.
class SimpleEnemy extends Enemy with DirectionAnimation {
  SimpleEnemy({
    required super.position,
    required super.size,
    SimpleDirectionAnimation? animation,
    super.life = 100,
    super.speed,
    Direction initDirection = Direction.right,
    super.receivesAttackFrom,
  }) {
    this.animation = animation;
    lastDirection = initDirection;
    lastDirectionHorizontal =
        initDirection == Direction.left ? Direction.left : Direction.right;
  }
}
