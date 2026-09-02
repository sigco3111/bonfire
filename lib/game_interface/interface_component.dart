import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';

/// [GameInterface]에 추가하는 데 사용되는 컴포넌트입니다.
class InterfaceComponent extends GameComponent
    with UseAssetsLoader, UseSprite, TapGesture {
  /// 식별자(identifier).
  final int id;

  /// 렌더링될 스프라이트(sprite).
  Sprite? spriteUnselected;

  /// 눌렸을 때 렌더링될 스프라이트(sprite).
  Sprite? spriteSelected;

  /// 컴포넌트의 onTap 제스처(gesture)를 받기 위한 콜백(callback)입니다.
  /// 선택되었는지 여부를 반환합니다.
  final ValueChanged<bool>? onTapComponent;
  final bool selectable;
  bool _lastSelected = false;
  bool selected = false;

  InterfaceComponent({
    required this.id,
    required Vector2 position,
    required Vector2 size,
    Future<Sprite>? spriteUnselected,
    Future<Sprite>? spriteSelected,
    this.selectable = false,
    this.onTapComponent,
  }) {
    loader?.add(
      AssetToLoad<Sprite>(spriteUnselected, (value) {
        this.spriteUnselected = value;
      }),
    );
    loader?.add(
      AssetToLoad<Sprite>(spriteSelected, (value) {
        this.spriteSelected = value;
      }),
    );
    this.position = position;
    this.size = size;
  }

  @override
  void update(double dt) {
    sprite = selected ? (spriteSelected ?? spriteUnselected) : spriteUnselected;
    super.update(dt);
  }

  @override
  void onTapCancel() {
    if (selectable) {
      return;
    }
    selected = !selected;
  }

  @override
  void onTap() {
    if (selectable && !_lastSelected) {
      selected = true;
    } else {
      selected = !selected;
    }
    _lastSelected = selected;
    onTapComponent?.call(selected);
  }

  @override
  bool onTapDown(GestureEvent event) {
    selected = true;
    return true;
  }
}
