import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/util/priority_layer.dart';

/// 커스텀 게임 배경을 만들 때 사용하는 기본 클래스입니다.
class GameBackground extends GameComponent {
  @override
  int get priority => LayerPriority.BACKGROUND;

  @override
  bool get isVisible => true;
}
