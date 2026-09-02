import 'dart:math';

import 'package:bonfire/bonfire.dart';

typedef SpawnerPositionBuilder = GameComponent Function(Vector2 position);

/// 다른 컴포넌트를 스폰(spawn)하는 데 사용되는 컴포넌트입니다.
class ComponentSpawner extends GameComponent {
  // 컴포넌트가 스폰되는 영역입니다.
  final ShapeHitbox area;
  // 간격(밀리초 단위)입니다.
  final int interval;
  // true인 경우 화면에 보이는 동안에만 생성됩니다.
  final bool onlyVisible;
  // 게임에 컴포넌트를 추가하는 빌더입니다.
  final SpawnerPositionBuilder builder;

  final bool Function(BonfireGameInterface game)? spawnCondition;

  late Random _random;

  ComponentSpawner({
    required Vector2 position,
    required this.area,
    required this.interval,
    required this.builder,
    this.spawnCondition,
    this.onlyVisible = true,
  }) {
    _random = Random();
    this.position = position;
    size = area.size;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (checkInterval('SpawnPosition', interval, dt)) {
      var enabled = true;
      if (onlyVisible) {
        enabled = isVisible;
      }
      if (spawnCondition?.call(gameRef) ?? true && enabled) {
        _spawn();
      }
    }
  }

  void _spawn() {
    var point = Vector2.zero();
    var count = 0;
    do {
      point = Vector2(
        size.x * _random.nextDouble(),
        size.y * _random.nextDouble(),
      );

      count++;
    } while (!area.containsLocalPoint(point) && count < 10);
    if (count < 10) {
      point.add(absolutePosition);
      gameRef.add(builder(point));
    }
  }
}
