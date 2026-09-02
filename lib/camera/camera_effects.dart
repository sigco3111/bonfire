import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flame/camera.dart';

class MyFollowBehavior extends FollowBehavior {
  final Vector2 movementWindow;
  final Vector2 targetSize;
  MyFollowBehavior({
    required super.target,
    required this.movementWindow,
    super.maxSpeed = double.infinity,
    super.horizontalOnly = false,
    super.verticalOnly = false,
    Vector2? targetSize,
    super.priority,
  }) : targetSize = targetSize ?? Vector2.zero();

  @override
  void update(double dt) {
    var delta = (target.position + (targetSize / 2)) - owner.position;

    if (horizontalOnly && !verticalOnly) {
      delta = _moveHorizontal(delta);
    } else if (!horizontalOnly && verticalOnly) {
      delta = _moveVertical(delta);
    } else {
      delta = _moveHorizontal(delta);
      delta = _moveVertical(delta);
    }

    if (delta.isZero()) {
      return;
    }
    if (delta.length <= maxSpeed * dt) {
      owner.position = delta..add(owner.position);
    } else {
      owner.position = owner.position.clone()
        ..lerp(owner.position + delta, dt * maxSpeed);
    }
  }

  Vector2 _moveVertical(Vector2 delta) {
    if (delta.y.abs() < movementWindow.y) {
      delta.y = 0;
    } else {
      if (delta.y > 0) {
        delta.y -= movementWindow.y;
      } else {
        delta.y += movementWindow.y;
      }
    }
    return delta;
  }

  Vector2 _moveHorizontal(Vector2 delta) {
    if (delta.x.abs() < movementWindow.x) {
      delta.x = 0;
    } else {
      if (delta.x > 0) {
        delta.x -= movementWindow.x;
      } else {
        delta.x += movementWindow.x;
      }
    }
    return delta;
  }
}

class ShakeEffect extends Component {
  final double intensity;
  final Duration duration;
  PositionProvider get target => parent! as PositionProvider;
  final void Function()? onComplete;
  double _shakeTimer = 0.0;
  late Vector2 initialPosition;
  ShakeEffect({
    required this.intensity,
    required this.duration,
    this.onComplete,
  }) {
    _shakeTimer = duration.inMilliseconds / 1000;
  }

  @override
  void onMount() {
    initialPosition = target.position.clone();
    super.onMount();
  }

  @override
  void update(double dt) {
    if (shaking) {
      final shake = _shakeDelta();
      target.position = target.position.clone()..add(shake);
      _shakeTimer -= dt;
      if (_shakeTimer <= 0.0) {
        onComplete?.call();
        target.position = initialPosition;
        removeFromParent();
      }
    }
    super.update(dt);
  }

  /// 카메라가 현재 흔들리고(shaking) 있는지 여부.
  bool get shaking => _shakeTimer > 0.0;

  /// 흔들림 델타를 재사용하기 위한 버퍼.
  final _shakeBuffer = Vector2.zero();

  /// 흔들림에 사용할 난수 생성기.
  final _shakeRng = Random();

  /// [-1, 1] * [_shakeIntensity] 범위에서 한 개의 값을 생성하며,
  /// 흔들림 델타의 각 축에 한 번씩 사용됩니다.
  double _shakeValue() => (_shakeRng.nextDouble() - 0.5) * 2 * intensity;

  /// 카메라에 적용될 무작위 [Vector2] 변위(displacement)를 생성합니다.
  /// 매 틱마다 무작위 [Vector2]가 생성되어 흔들리는 효과를 만듭니다.
  Vector2 _shakeDelta() {
    if (shaking) {
      _shakeBuffer.setValues(_shakeValue(), _shakeValue());
    } else if (!_shakeBuffer.isZero()) {
      _shakeBuffer.setZero();
    }
    return _shakeBuffer;
  }
}
