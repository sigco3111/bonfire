// ignore_for_file: invalid_use_of_internal_member

import 'package:bonfire/collision/quad_tree/custom_quad_tree_broadphase.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/widgets.dart';

/// 쿼드 트리(Quad Tree) 광역(broadphase)을 지원하도록 수정한 충돌 감지 클래스입니다.
///
/// 표준 [items] 리스트를 컴포넌트용으로 사용하지 마세요. 대신 모든 컴포넌트를
/// [QuadTreeBroadphase] 클래스에 추가해야 합니다.
class CustomQuadTreeCollisionDetection
    extends StandardCollisionDetection<QuadTreeBroadphase> {
  CustomQuadTreeCollisionDetection({
    required Rect mapDimensions,
    required ExternalBroadphaseCheck onComponentTypeCheck,
    required ExternalMinDistanceCheck minimumDistanceCheck,
    int maxObjects = 25,
    int maxDepth = 10,
  }) : super(
          broadphase: CustomQuadTreeBroadphase(
            mainBoxSize: mapDimensions,
            maxObjects: maxObjects,
            maxDepth: maxDepth,
            broadphaseCheck: onComponentTypeCheck,
            minimumDistanceCheck: minimumDistanceCheck,
          ),
        );

  final _listenerCollisionType = <ShapeHitbox, VoidCallback>{};
  final _scheduledUpdate = <ShapeHitbox>{};

  @override
  void add(ShapeHitbox item) {
    item.onAabbChanged = () => _scheduledUpdate.add(item);
    void listenerCollisionType() {
      if (item.isMounted) {
        if (item.collisionType == CollisionType.active) {
          broadphase.activeHitboxes.add(item);
        } else {
          broadphase.activeHitboxes.remove(item);
        }
      }
    }

    item.collisionTypeNotifier.addListener(listenerCollisionType);
    _listenerCollisionType[item] = listenerCollisionType;

    super.add(item);
  }

  @override
  void addAll(Iterable<ShapeHitbox> items) {
    for (final item in items) {
      add(item);
    }
  }

  @override
  void remove(ShapeHitbox item) {
    item.onAabbChanged = null;
    final listenerCollisionType = _listenerCollisionType[item];
    if (listenerCollisionType != null) {
      item.collisionTypeNotifier.removeListener(listenerCollisionType);
      _listenerCollisionType.remove(item);
    }

    super.remove(item);
  }

  @override
  void removeAll(Iterable<ShapeHitbox> items) {
    broadphase.clear();
    for (final item in items) {
      remove(item);
    }
  }

  @override
  void run() {
    for (final hitbox in _scheduledUpdate) {
      broadphase.updateTransform(hitbox);
    }
    _scheduledUpdate.clear();
    super.run();
  }
}
