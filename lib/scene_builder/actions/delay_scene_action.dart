import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:bonfire/scene_builder/scene_action.dart';
import 'package:bonfire/util/interval_tick.dart';

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
/// on 18/05/22

/// 씬(scene)에 지연(delay)을 적용하는 SceneAction입니다.
class DelaySceneAction extends SceneAction {
  late IntervalTick _tick;
  final Duration delay;

  DelaySceneAction(this.delay) : super(null) {
    _tick = IntervalTick(delay.inMilliseconds);
  }

  @override
  bool runAction(double dt, BonfireGameInterface game) {
    return _tick.update(dt);
  }
}
