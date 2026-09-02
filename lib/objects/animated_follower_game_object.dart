import 'package:bonfire/bonfire.dart';

/// 다른 `GameComponent`를 따라가는 애니메이션 컴포넌트입니다.
class AnimatedFollowerGameObject extends AnimatedGameObject with Follower {
  AnimatedFollowerGameObject({
    required super.animation,
    required super.size,
    required GameComponent target,
    super.lightingConfig,
    super.loop = true,
    super.onFinish,
    super.onStart,
    super.angle,
    super.removeOnFinish = true,
    Vector2? offset,
    super.objectPriority,
    super.renderAboveComponents,
  }) : super(
          position: target.position + (offset ?? Vector2.zero()),
        ) {
    setupFollower(target: target, offset: offset);
  }

  @override
  int get priority {
    return objectPriority ?? super.priority;
  }
}
