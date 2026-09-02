import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:bonfire/scene_builder/scene_action.dart';
import 'package:flutter/material.dart';

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

/// `completed` 콜백(callback)이 호출될 때까지 어떤 작업을 수행하는 SceneAction입니다.
class CallbackSceneAction extends SceneAction {
  bool _isDone = false;
  bool _isFirstRun = true;
  final ValueChanged<VoidCallback> completedCallback;

  CallbackSceneAction({required this.completedCallback, dynamic id})
      : super(id);

  @override
  bool runAction(double dt, BonfireGameInterface game) {
    if (_isFirstRun) {
      _isFirstRun = false;
      completedCallback(() => _isDone = true);
    }
    return _isDone;
  }
}
