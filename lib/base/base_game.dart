import 'package:bonfire/bonfire.dart';
import 'package:bonfire/mixins/pointer_detector.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// 터치 스크린 제스처를 캡처하기 위해 `Listener`를 사용하도록 만들어진 CustomBaseGame입니다.
/// 캔버스에 줌(zoom)을 적용합니다.
/// 프레임마다 컴포넌트의 순서를 재정렬합니다.
abstract class BaseGame extends FlameGame
    with PointerDetector, KeyboardEvents, HasTimeScale {
  BaseGame({super.world, super.camera});
  bool enabledGestures = true;
  bool enabledKeyboard = true;
  final List<PointerDetectorHandler> _gesturesComponents =
      <PointerDetectorHandler>[];

  @override
  void updateTree(double dt) {
    // Reuse the same list to avoid allocations per frame.
    _gesturesComponents.clear();

    for (final c in world.children) {
      if (_hasGesture(c)) {
        _gesturesComponents.add(c as PointerDetectorHandler);
      }
    }

    for (final c in camera.viewport.children) {
      if (_hasGesture(c)) {
        _gesturesComponents.add(c as PointerDetectorHandler);
      }
    }

    super.updateTree(dt);
  }

  /// 제스처(gestures)를 포함하는 컴포넌트를 가져옵니다.
  // Note: we avoid building a combined list here to reduce allocations on key events.
  Iterable<KeyboardEventListener> get _keyboardComponents sync* {
    for (final k in world.children.query<KeyboardEventListener>()) {
      yield k;
    }
    for (final k in camera.viewport.children.query<KeyboardEventListener>()) {
      yield k;
    }
  }

  @override
  void onPointerCancel(PointerCancelEvent event) {
    if (!hasLayout || !enabledGestures) {
      return;
    }
    for (final c in _gesturesComponents) {
      if (c.handlerPointerCancel(event)) {
        return;
      }
    }
  }

  @override
  void onPointerUp(PointerUpEvent event) {
    if (!hasLayout || !enabledGestures) {
      return;
    }
    for (final c in _gesturesComponents) {
      if (c.handlerPointerUp(event)) {
        return;
      }
    }
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    if (!hasLayout || !enabledGestures) {
      return;
    }
    for (final c in _gesturesComponents) {
      if (c.handlerPointerMove(event)) {
        return;
      }
    }
  }

  @override
  void onPointerDown(PointerDownEvent event) {
    if (!hasLayout || !enabledGestures) {
      return;
    }
    for (final c in _gesturesComponents) {
      if (c.handlerPointerDown(event)) {
        return;
      }
    }
  }

  @override
  void onPointerHover(PointerHoverEvent event) {
    if (!hasLayout || !enabledGestures) {
      return;
    }
    for (final c in _gesturesComponents) {
      if (c.handlerPointerHover(event)) {
        return;
      }
    }
  }

  @override
  void onPointerSignal(PointerSignalEvent event) {
    if (!hasLayout || !enabledGestures) {
      return;
    }
    for (final c in _gesturesComponents) {
      if (c.handlerPointerSignal(event)) {
        return;
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    var result = KeyEventResult.ignored;
    if (!enabledKeyboard) {
      return result;
    }
    for (final listener in _keyboardComponents) {
      if (listener.onKeyboard(event, keysPressed)) {
        result = KeyEventResult.handled;
      }
    }
    return result;
  }

  /// 컴포넌트가 제스처(gestures)를 포함하는지 확인합니다.
  bool _hasGesture(Component c) {
    return (c is GameComponent && c.isVisible) && (c.hasGesture());
  }

  @override
  void onRemove() {
    super.onRemove();
    removeAll(children);
    processLifecycleEvents();
  }
}
