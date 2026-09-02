import 'package:bonfire/mixins/direction_animation.dart';
import 'package:bonfire/npc/npc.dart';
import 'package:bonfire/util/direction.dart';
import 'package:bonfire/util/direction_animations/simple_direction_animation.dart';

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

/// 모든 방향 애니메이션을 가진 NPC입니다.
class SimpleNpc extends Npc with DirectionAnimation {
  SimpleNpc({
    required super.position,
    required super.size,
    SimpleDirectionAnimation? animation,
    super.speed,
    Direction initDirection = Direction.right,
  }) {
    this.animation = animation;
    lastDirection = initDirection;
    lastDirectionHorizontal =
        initDirection == Direction.left ? Direction.left : Direction.right;
  }
}
