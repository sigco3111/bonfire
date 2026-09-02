import 'package:bonfire/bonfire.dart';

/// Tiled로 생성한 맵 구성에서 사용되는, 충돌이 있는 GameDecoration입니다.
class GameDecorationWithCollision extends GameDecoration {
  Iterable<ShapeHitbox>? collisions;
  GameDecorationWithCollision({
    required super.position,
    required super.size,
    super.sprite,
    super.animation,
    this.collisions,
    super.renderAboveComponents,
  });

  GameDecorationWithCollision.withSprite({
    required Future<Sprite> super.sprite,
    required super.position,
    required super.size,
    this.collisions,
    super.renderAboveComponents,
  }) : super.withSprite();

  GameDecorationWithCollision.withAnimation({
    required Future<SpriteAnimation> super.animation,
    required super.position,
    required super.size,
    this.collisions,
    super.renderAboveComponents,
  }) : super.withAnimation();

  @override
  Future<void> onLoad() {
    collisions?.let(addAll);
    return super.onLoad();
  }
}
