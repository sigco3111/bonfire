import 'package:bonfire/base/bonfire_game_interface.dart';

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

/// `SceneActions`를 만들기 위한 기반(base) 클래스입니다.
abstract class SceneAction {
  final dynamic id;

  SceneAction(this.id);
  bool runAction(double dt, BonfireGameInterface game);
}
