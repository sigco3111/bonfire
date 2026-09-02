import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/geometry/polygon.dart';
import 'package:bonfire/geometry/rectangle.dart';
import 'package:bonfire/util/extensions/color_extensions.dart';
import 'package:flutter/material.dart';

/// 컴포넌트에 기본적인 시야(Vision)를 추가하는 데 사용되는 mixin입니다.
mixin Vision on GameComponent {
  // ignore: constant_identifier_names
  static const VISION_360 = 6.28319;
  final Paint _paint = Paint()..color = Colors.red.setOpacity(0.5);
  bool _drawVision = false;
  bool _checkWithRaycast = true;
  final Map<String, PolygonShape> _polygonCache = {};
  PolygonShape? _currentShape;
  int _countPolygonPoints = 20;

  void setupVision({
    Color? color,
    bool drawVision = false,
    bool checkWithRaycast = true,
    int countPolygonPoints = 20,
  }) {
    assert(countPolygonPoints.isEven, 'countPolygonPoints must be even');
    _drawVision = drawVision;
    _checkWithRaycast = checkWithRaycast;
    _countPolygonPoints = countPolygonPoints;
    _paint.color = color ?? Colors.red.setOpacity(0.5);
  }

  /// 이 메서드는 컴포넌트가 [radiusVision] 설정 영역에 진입한 것을
  /// 감지했을 때 알리는 데 사용됩니다.
  /// [update] 메서드 안에서 사용되는 메서드입니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위입니다.
  PolygonShape? seeComponent(
    GameComponent component, {
    required Function(GameComponent) observed,
    VoidCallback? notObserved,
    double radiusVision = 32,
    double? visionAngle,
    double angle = 3.14159,
  }) {
    if (component.isRemoving) {
      notObserved?.call();
      return _currentShape = null;
    }

    final shape = _getShapeVision(radiusVision, visionAngle, angle);

    if (_canSee(shape, component, radiusVision)) {
      observed(component);
    } else {
      notObserved?.call();
    }
    return _currentShape = shape;
  }

  bool _canSee(
    PolygonShape shape,
    GameComponent component,
    double radiusVision,
  ) {
    if (component.isRemoving || component is CanNotSeen) {
      return false;
    }

    final rect = component.rectCollision;
    final otherShape = RectangleShape(
      rect.sizeVector2,
      position: rect.positionVector2,
    );

    final inShape = shape.isCollision(otherShape);
    if (inShape) {
      if (_checkWithRaycast) {
        final myCenter = rectCollision.center.toVector2();
        final compCenter = component.rectCollision.center.toVector2();
        final direction = (compCenter - myCenter).normalized();

        final result = raycast(
          direction,
          maxDistance: radiusVision,
          origin: myCenter,
          ignoreHitboxes: _getCanNotSeenHitbox(),
        );
        final vParent = result?.hitbox?.parent;
        return vParent == component || vParent == null;
      }
      return true;
    }

    return false;
  }

  /// 이 메서드는 타입별 컴포넌트들이 [radiusVision] 설정 영역에 진입한 것을
  /// 감지했을 때 알리는 데 사용됩니다.
  /// [update] 메서드 안에서 사용되는 메서드입니다.
  /// [visionAngle]은 라디안(radians) 단위입니다.
  /// [angle]은 라디안(radians) 단위입니다.
  PolygonShape? seeComponentType<T extends GameComponent>({
    required void Function(List<T>) observed,
    VoidCallback? notObserved,
    double radiusVision = 32,
    double? visionAngle,
    double angle = 3.14159,
  }) {
    final compVisible = gameRef.visibles<T>();

    if (compVisible.isEmpty) {
      notObserved?.call();
      return _currentShape = null;
    }

    final shape = _getShapeVision(radiusVision, visionAngle, angle);

    final compObserved = compVisible.where((comp) {
      return _canSee(shape, comp, radiusVision);
    }).toList();

    if (compObserved.isNotEmpty) {
      observed(compObserved);
    } else {
      notObserved?.call();
    }
    return _currentShape = shape;
  }

  PolygonShape _buildShape(
    double radiusVision,
    double? angleVision,
    double angle,
    Vector2 position,
  ) {
    final angleV = angleVision ?? VISION_360;
    final nextX = radiusVision * cos(angle);
    final nextY = radiusVision * sin(angle);
    final point = Offset(nextX, nextY);
    final pointsP = <Vector2>[];
    List.generate(_countPolygonPoints ~/ 2, (index) {
      if (index == 0) {
        pointsP.add(
          point.rotate(angleV / _countPolygonPoints, Offset.zero).toVector2(),
        );
      } else {
        pointsP.add(
          pointsP.last
              .toOffset()
              .rotate(angleV / _countPolygonPoints, Offset.zero)
              .toVector2(),
        );
      }
    });
    final pointsN = <Vector2>[];
    List.generate(_countPolygonPoints ~/ 2, (index) {
      if (index == 0) {
        pointsN.add(
          point.rotate(angleV / -_countPolygonPoints, Offset.zero).toVector2(),
        );
      } else {
        pointsN.add(
          pointsN.last
              .toOffset()
              .rotate(angleV / -_countPolygonPoints, Offset.zero)
              .toVector2(),
        );
      }
    });

    return PolygonShape(
      [
        Vector2(0, 0),
        ...pointsP.reversed,
        point.toVector2(),
        ...pointsN,
      ],
      position: position,
    );
  }

  @override
  void onRemove() {
    cleanVisionCache();
    super.onRemove();
  }

  void cleanVisionCache() {
    _polygonCache.clear();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_drawVision) {
      canvas.save();
      canvas.translate(-position.x, -position.y);
      _currentShape?.render(canvas, _paint);
      canvas.restore();
    }
  }

  PolygonShape _getShapeVision(
    double radiusVision,
    double? visionAngle,
    double angle,
  ) {
    final key = '$radiusVision/$visionAngle/$angle';
    PolygonShape shape;
    final center = rectCollision.centerVector2;
    if (_polygonCache.containsKey(key)) {
      shape = _polygonCache[key]!;
      shape.position = center;
    } else {
      shape = _buildShape(radiusVision, visionAngle, angle, center);
      _polygonCache[key] = shape;
    }
    return shape;
  }

  List<ShapeHitbox> _getCanNotSeenHitbox() {
    final sensorHitBox = <ShapeHitbox>[];
    gameRef.query<CanNotSeen>(onlyVisible: true).forEach((e) {
      sensorHitBox.addAll(e.children.query<ShapeHitbox>());
    });
    return sensorHitBox;
  }
}

// 컴포넌트가 `Vision` mixin으로 감지되지 않도록 하려면 이 mixin을 사용하세요.
mixin CanNotSeen on GameComponent {}
