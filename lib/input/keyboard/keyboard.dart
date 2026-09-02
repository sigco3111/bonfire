import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';

export 'package:bonfire/input/keyboard/keyboard_config.dart';

class Keyboard extends PlayerController with KeyboardEventListener {
  bool _directionalIsIdle = false;

  final KeyboardConfig keyboardConfig;

  /// 게임에 키보드 컨트롤러를 추가하는 역할을 하는 클래스입니다.
  /// [observer] 매개변수를 전달하면, `player` 매개변수로 전달된 Component가 아니라 이 observer를 조이스틱이 제어합니다.
  Keyboard({
    super.id,
    KeyboardConfig? config,
    PlayerControllerListener? observer,
  }) : keyboardConfig = config ?? KeyboardConfig() {
    if (observer != null) {
      addObserver(observer);
    }
  }

  @override
  bool onKeyboard(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    /// 키보드가 비활성화돼 있으면 이벤트를 처리하지 않습니다.
    if (!keyboardConfig.enable) {
      return false;
    }

    /// 허용된 키가 아닌 경우 이벤트를 처리하지 않습니다.
    if (keyboardConfig.acceptedKeys != null) {
      if (!keyboardConfig.acceptedKeys!.contains(event.logicalKey)) {
        return false;
      }
    }

    /// 키보드 이벤트가 없으면 idle 상태를 유지합니다.
    if (!_containDirectionalPressed(keysPressed) &&
        !event.synthesized &&
        !_directionalIsIdle) {
      _directionalIsIdle = true;
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.IDLE,
        ),
      );
    }

    /// 방향 이벤트를 처리합니다.
    if (_isDirectional(event.logicalKey)) {
      final currentKeyboardKeys = _getDirectionlKeysPressed(keysPressed);
      if (currentKeyboardKeys.isNotEmpty) {
        _directionalIsIdle = false;
        if (keyboardConfig.enableDiagonalInput &&
            currentKeyboardKeys.length > 1) {
          _sendTwoDirection(
            currentKeyboardKeys.first,
            currentKeyboardKeys[1],
          );
        } else {
          _sendOneDirection(currentKeyboardKeys.first);
        }
      }
    } else {
      /// 액션 이벤트를 처리합니다.
      if (event is KeyDownEvent) {
        onJoystickAction(
          JoystickActionEvent(
            id: event.logicalKey,
            event: ActionEvent.DOWN,
          ),
        );
      } else if (event is KeyUpEvent) {
        onJoystickAction(
          JoystickActionEvent(
            id: event.logicalKey,
            event: ActionEvent.UP,
          ),
        );
      }
    }

    return true;
  }

  /// 해당 키가 방향키용 키인지 확인합니다 [arrows, wasd 또는 둘 다].
  bool _isDirectional(LogicalKeyboardKey key) {
    return keyboardConfig.directionalKeys.any(
      (element) => element.contain(key),
    );
  }

  bool isUpPressed(LogicalKeyboardKey key) {
    return keyboardConfig.directionalKeys.any((element) => element.up == key);
  }

  bool isDownPressed(LogicalKeyboardKey key) {
    return keyboardConfig.directionalKeys.any((element) => element.down == key);
  }

  bool isLeftPressed(LogicalKeyboardKey key) {
    return keyboardConfig.directionalKeys.any((element) => element.left == key);
  }

  bool isRightPressed(LogicalKeyboardKey key) {
    return keyboardConfig.directionalKeys
        .any((element) => element.right == key);
  }

  void _sendOneDirection(LogicalKeyboardKey key) {
    if (isUpPressed(key)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_UP,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }
    if (isDownPressed(key)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_DOWN,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }

    if (isLeftPressed(key)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_LEFT,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }

    if (isRightPressed(key)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_RIGHT,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }
  }

  void _sendTwoDirection(LogicalKeyboardKey key1, LogicalKeyboardKey key2) {
    if (isRightPressed(key1) && isDownPressed(key2) ||
        isDownPressed(key1) && isRightPressed(key2)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_DOWN_RIGHT,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }

    if (isLeftPressed(key1) && isDownPressed(key2) ||
        isDownPressed(key1) && isLeftPressed(key2)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_DOWN_LEFT,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }

    if (isLeftPressed(key1) && isUpPressed(key2) ||
        isUpPressed(key1) && isLeftPressed(key2)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_UP_LEFT,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }

    if (isRightPressed(key1) && isUpPressed(key2) ||
        isUpPressed(key1) && isRightPressed(key2)) {
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.MOVE_UP_RIGHT,
          intensity: 1.0,
          isKeyboard: true,
        ),
      );
    }
  }

  bool _containDirectionalPressed(Set<LogicalKeyboardKey> keysPressed) {
    for (final element in keysPressed) {
      if (_isDirectional(element)) {
        return true;
      }
    }
    return false;
  }

  List<LogicalKeyboardKey> _getDirectionlKeysPressed(
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    return keysPressed.where(_isDirectional).toList();
  }
}
