import 'dart:async';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';

/// 이 컴포넌트는 씬(scene)에 추가하고 싶은 모든 것을 나타냅니다.
/// 간단한 "배럴"부터 플레이어와 상호작용할 수 있는 NPC까지 무엇이든 될 수 있습니다.
///
/// ImageSprite 또는 Animation[FlameAnimation.Animation]을 사용할 수 있습니다.
class GameDecoration extends AnimatedGameObject {
  GameDecoration({
    required super.position,
    required super.size,
    Sprite? sprite,
    SpriteAnimation? animation,
    super.anchor,
    super.angle,
    super.lightingConfig,
    super.renderAboveComponents,
  }) {
    this.sprite = sprite;
    setAnimation(animation);
    applyBleedingPixel(position: position, size: size);
  }

  GameDecoration.withSprite({
    required FutureOr<Sprite> sprite,
    required super.position,
    required super.size,
    super.anchor,
    super.angle,
    super.lightingConfig,
    super.renderAboveComponents,
  }) {
    loader?.add(
      AssetToLoad<Sprite>(sprite, (value) => this.sprite = value),
    );
    applyBleedingPixel(position: position, size: size);
  }

  GameDecoration.withAnimation({
    required FutureOr<SpriteAnimation> animation,
    required super.position,
    required super.size,
    super.anchor,
    super.angle,
    super.lightingConfig,
    super.renderAboveComponents,
  }) {
    loader?.add(AssetToLoad<SpriteAnimation>(animation, setAnimation));
    applyBleedingPixel(position: position, size: size);
  }

  @override
  Future playSpriteAnimationOnce(
    FutureOr<SpriteAnimation> animation, {
    Vector2? size,
    Vector2? offset,
    VoidCallback? onFinish,
    VoidCallback? onStart,
    bool loop = false,
  }) {
    return super.playSpriteAnimationOnce(
      animation,
      size: size,
      offset: offset,
      loop: loop,
      onFinish: onFinish,
      onStart: () {
        onStart?.call();
      },
    );
  }
}
