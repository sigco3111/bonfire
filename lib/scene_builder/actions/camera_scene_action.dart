import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart' as widget;

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
/// on 04/03/22

/// 카메라를 특정 위치로 이동시키거나 게임 내 컴포넌트를 따라가도록 하는 SceneAction입니다.
class CameraSceneAction extends SceneAction {
  final Vector2? position;
  final GameComponent? target;
  final Duration duration;
  final double? zoom;
  final double? angle;
  final widget.Curve curve;

  bool _running = false;
  bool _done = false;

  CameraSceneAction({
    required this.duration,
    dynamic id,
    this.position,
    this.target,
    this.zoom,
    this.angle,
    this.curve = widget.Curves.decelerate,
  }) : super(id);
  CameraSceneAction.position(
    this.position, {
    dynamic id,
    this.duration = const Duration(seconds: 1),
    this.zoom,
    this.angle,
    this.curve = widget.Curves.decelerate,
  })  : target = null,
        super(id);

  CameraSceneAction.target(
    this.target, {
    dynamic id,
    this.duration = const Duration(seconds: 1),
    this.zoom,
    this.angle,
    this.curve = widget.Curves.decelerate,
  })  : position = null,
        super(id);

  @override
  bool runAction(double dt, BonfireGameInterface game) {
    if (!_running) {
      _running = true;
      if (position != null) {
        game.camera.moveToPositionAnimated(
          position: position!,
          effectController: EffectController(
            duration: duration.inSeconds.toDouble(),
            curve: curve,
          ),
          onComplete: _actionDone,
          angle: angle,
          zoom: zoom,
        );
      } else if (target != null) {
        game.camera.moveToTargetAnimated(
          target: target!,
          effectController: EffectController(
            duration: duration.inSeconds.toDouble(),
            curve: curve,
          ),
          onComplete: () {
            _actionDone.call();
            game.camera.follow(target!);
          },
          angle: angle,
          zoom: zoom,
        );
      } else {
        return true;
      }
    }
    if (_done) {
      return true;
    }
    return false;
  }

  void _actionDone() {
    _done = true;
  }
}
