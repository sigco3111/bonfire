import 'package:bonfire/bonfire.dart';
import 'package:flutter/gestures.dart';

enum MouseButton { left, right, middle, unknow }

/// 마우스 제스처를 수신하는 역할을 하는 믹스인입니다.
mixin MouseEventListener on GameComponent {
  bool enableMouseGesture = true;
  int _pointer = -1;
  bool _hoverEnter = false;
  MouseButton? _buttonClicked;

  /// 화면 전반에 걸친 마우스 커서의 이동을 수신합니다.
  void onMouseHoverScreen(int pointer, Vector2 position) {}

  /// 화면 전반에서 마우스 버튼이 눌린 상태로 이동하는 것을 수신합니다.
  void onMouseMoveScreen(int pointer, Vector2 position, MouseButton button) {}

  /// 마우스 커서가 이 컴포넌트 위에 올라왔을 때를 수신합니다.
  void onMouseHoverEnter(int pointer, Vector2 position) {}

  /// 마우스 커서가 이 컴포넌트 밖으로 벗어났을 때를 수신합니다.
  void onMouseHoverExit(int pointer, Vector2 position) {}

  /// 화면 전반에서 마우스 휠 스크롤을 사용할 때를 수신합니다.
  void onMouseScrollScreen(
    int pointer,
    Vector2 position,
    Vector2 scrollDelta,
  ) {}

  /// 컴포넌트 안에서 마우스 휠 스크롤을 사용할 때를 수신합니다.
  void onMouseScroll(int pointer, Vector2 position, Vector2 scrollDelta) {}

  /// 컴포넌트 안에서 마우스가 눌렸을 때를 수신합니다.
  void onMouseTapDown(int pointer, Vector2 position, MouseButton button) {}

  /// 컴포넌트 안에서 마우스가 떼어졌을 때를 수신합니다.
  void onMouseTapUp(int pointer, Vector2 position, MouseButton button) {}

  // 컴포넌트 안에서 마우스가 클릭되었을 때를 수신합니다.
  void onMouseTap(MouseButton button);
  void onMouseCancel() {}

  @override
  bool handlerPointerMove(PointerMoveEvent event) {
    if (event.kind == PointerDeviceKind.mouse) {
      final pointer = event.pointer;
      final position = event.localPosition.toVector2();
      onMouseMoveScreen(pointer, position, _getMouseButtonByInt(event.buttons));
    }
    return super.handlerPointerMove(event);
  }

  @override
  bool handlerPointerHover(PointerHoverEvent event) {
    if (!enableMouseGesture) {
      return super.handlerPointerHover(event);
    }
    final pointer = event.pointer;
    final position = event.localPosition.toVector2();
    var realPosition = position;
    if (!isHud) {
      realPosition = gameRef.screenToWorld(realPosition);
    }
    onMouseHoverScreen(pointer, position);

    if (containsPoint(realPosition) && !_hoverEnter) {
      _hoverEnter = true;
      onMouseHoverEnter(pointer, position);
    } else if (!containsPoint(realPosition) && _hoverEnter) {
      _hoverEnter = false;
      onMouseHoverExit(pointer, position);
    }

    return super.handlerPointerHover(event);
  }

  @override
  bool handlerPointerSignal(PointerSignalEvent event) {
    if (!enableMouseGesture) {
      return super.handlerPointerSignal(event);
    }
    final pointer = event.pointer;
    final position = event.localPosition.toVector2();
    var realPosition = event.localPosition.toVector2();
    if (!isHud) {
      realPosition = gameRef.screenToWorld(realPosition);
    }
    final scrollDelta = (event as PointerScrollEvent).scrollDelta.toVector2();
    onMouseScrollScreen(pointer, position, scrollDelta);
    if (containsPoint(realPosition)) {
      onMouseScroll(pointer, position, scrollDelta);
    }
    return super.handlerPointerSignal(event);
  }

  @override
  bool handlerPointerDown(PointerDownEvent event) {
    if (!enableMouseGesture || event.kind != PointerDeviceKind.mouse) {
      return super.handlerPointerDown(event);
    }
    if (hasGameRef) {
      onMouseScreenTapDown(
        event.pointer,
        event.localPosition.toVector2(),
        _getMouseButtonByInt(event.buttons),
      );
    }
    return super.handlerPointerDown(event);
  }

  @override
  bool handlerPointerUp(PointerUpEvent event) {
    if (!enableMouseGesture || event.kind != PointerDeviceKind.mouse) {
      return super.handlerPointerUp(event);
    }

    if (hasGameRef) {
      onMouseScreenTapUp(
        event.pointer,
        event.localPosition.toVector2(),
      );
      _pointer = -1;
    }
    return super.handlerPointerUp(event);
  }

  // 화면에서 마우스가 눌렸을 때를 수신합니다.
  void onMouseScreenTapDown(int pointer, Vector2 position, MouseButton button) {
    var realPosition = position;
    if (!isHud) {
      realPosition = gameRef.screenToWorld(realPosition);
    }
    if (containsPoint(realPosition)) {
      _buttonClicked = button;
      _pointer = pointer;
      onMouseTapDown(pointer, position, button);
    }
  }

  // 화면에서 마우스가 떼어졌을 때를 수신합니다.
  void onMouseScreenTapUp(int pointer, Vector2 position) {
    var realPosition = position;
    if (!isHud) {
      realPosition = gameRef.screenToWorld(realPosition);
    }
    if (containsPoint(realPosition) &&
        pointer == _pointer &&
        _buttonClicked != null) {
      onMouseTapUp(pointer, position, _buttonClicked!);
      onMouseTap(_buttonClicked!);
    } else if (_buttonClicked != null) {
      onMouseCancel();
    }
    _buttonClicked = null;
  }

  MouseButton _getMouseButtonByInt(int buttonClicked) {
    switch (buttonClicked) {
      case kPrimaryMouseButton:
        return MouseButton.left;
      case kSecondaryMouseButton:
        return MouseButton.right;
      case kMiddleMouseButton:
        return MouseButton.middle;
    }

    return MouseButton.unknow;
  }

  @override
  bool hasGesture() => enableMouseGesture;
}
