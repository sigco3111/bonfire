import 'package:flutter/services.dart';

class KeyboardDirectionalKeys {
  final LogicalKeyboardKey up;
  final LogicalKeyboardKey down;
  final LogicalKeyboardKey left;
  final LogicalKeyboardKey right;

  KeyboardDirectionalKeys({
    required this.up,
    required this.down,
    required this.left,
    required this.right,
  });

  List<LogicalKeyboardKey> get keys => [up, down, left, right];

  bool contain(LogicalKeyboardKey key) => keys.contains(key);

  factory KeyboardDirectionalKeys.arrows() {
    return KeyboardDirectionalKeys(
      down: LogicalKeyboardKey.arrowDown,
      up: LogicalKeyboardKey.arrowUp,
      left: LogicalKeyboardKey.arrowLeft,
      right: LogicalKeyboardKey.arrowRight,
    );
  }

  factory KeyboardDirectionalKeys.wasd() {
    return KeyboardDirectionalKeys(
      down: LogicalKeyboardKey.keyS,
      up: LogicalKeyboardKey.keyW,
      left: LogicalKeyboardKey.keyA,
      right: LogicalKeyboardKey.keyD,
    );
  }
}

class KeyboardConfig {
  /// 키보드 이벤트의 활성화 여부를 설정하는 데 사용됩니다.
  bool enable;

  /// 방향키 입력의 종류(arrows, wasd 또는 wasdAndArrows)
  final List<KeyboardDirectionalKeys> directionalKeys;

  /// 허용할 특정 키들을 전달할 수 있습니다. null이면 모든 키를 허용합니다.
  final List<LogicalKeyboardKey>? acceptedKeys;

  /// 대각선 입력 이벤트를 활성화하는 데 사용됩니다.
  bool enableDiagonalInput;

  KeyboardConfig({
    this.enable = true,
    List<KeyboardDirectionalKeys>? directionalKeys,
    this.acceptedKeys,
    this.enableDiagonalInput = true,
  }) : directionalKeys = directionalKeys ?? [KeyboardDirectionalKeys.arrows()] {
    acceptedKeys?.addAll(
      this.directionalKeys.map((e) => e.keys).expand((e) => e),
    );
  }
}
