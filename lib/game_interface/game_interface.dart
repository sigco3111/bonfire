import 'dart:async';

import 'package:bonfire/bonfire.dart';

/// 체력바, 스테미나, 설정 등을 그리는 방식입니다. 다시 말해, 게임의 인터페이스에 추가할 수 있는 모든 것을 의미합니다.
class GameInterface extends GameComponent {
  @override
  int get priority {
    return LayerPriority.getHudInterfacePriority();
  }

  /// Button처럼 인터페이스에 컴포넌트를 추가하는 데 사용됩니다.
  @override
  FutureOr<void> add(Component component) {
    if (component is InterfaceComponent) {
      removeById(component.id);
    }
    return super.add(component);
  }

  /// id로 인터페이스에서 컴포넌트를 제거하는 데 사용됩니다.
  void removeById(int id) {
    if (children.isEmpty) {
      return;
    }
    removeWhere(
      (component) => component is InterfaceComponent && component.id == id,
    );
  }

  @override
  bool hasGesture() => true;
}
