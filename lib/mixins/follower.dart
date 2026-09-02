import 'package:bonfire/base/game_component.dart';
import 'package:flame/components.dart';

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
/// 작성일: 04/02/22
/// 컴포넌트가 대상을 따라가도록 하는 mixin입니다.
/// 대상이 null이면 부모를 따라갑니다.
mixin Follower on GameComponent {
  GameComponent? followerTarget;
  Vector2? followerOffset;
  Vector2? _lastFollowerPosition;
  final Vector2 _zero = Vector2.zero();

  void setupFollower({
    GameComponent? target,
    Vector2? offset,
  }) {
    followerTarget = target ?? followerTarget;
    followerOffset = offset ?? followerOffset;
  }

  void removeFollowerTarget() {
    followerTarget = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (followerTarget != null &&
        _lastFollowerPosition != followerTarget?.absolutePosition) {
      _lastFollowerPosition = followerTarget!.absolutePosition.clone();
      position = _lastFollowerPosition! + (followerOffset ?? _zero);
    }
  }

  @override
  int get priority => followerTarget?.priority ?? super.priority;
}
