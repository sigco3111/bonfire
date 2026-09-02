import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';

class Joystick extends PlayerController {
  final List<JoystickAction> actions;
  JoystickDirectional? _directional;

  JoystickDirectional? get directional => _directional;

  /// 게임에 조이스틱(joystick) 컨트롤러를 추가하는 역할을 하는 클래스입니다.
  /// [observer] 매개변수를 전달하면, `player` 매개변수로 전달된 컴포넌트가 아니라 이 옵저버를 컨트롤합니다.
  Joystick({
    super.id,
    this.actions = const [],
    JoystickDirectional? directional,
    PlayerControllerListener? observer,
  }) {
    _directional = directional;
    if (observer != null) {
      addObserver(observer);
    }
  }

  void initialize(Vector2 size) {
    if (!hasGameRef) {
      return;
    }
    directional?.initialize(this, gameRef.camera.viewport);
    for (final action in actions) {
      action.initialize(this, gameRef.camera.viewport);
    }
  }

  Future updateDirectional(JoystickDirectional? directional) async {
    directional?.initialize(this, gameRef.camera.viewport);
    await directional?.onLoad();
    _directional = directional;
  }

  Future addAction(JoystickAction action) async {
    action.initialize(this, gameRef.camera.viewport);
    await action.onLoad();
    actions.add(action);
  }

  void removeAction(dynamic actionId) {
    actions.removeWhere((action) => action.actionId == actionId);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    directional?.render(canvas);
    for (final action in actions) {
      action.render(canvas);
    }
  }

  @override
  void update(double dt) {
    directional?.update(dt);
    for (final action in actions) {
      action.update(dt);
    }
    super.update(dt);
  }

  @override
  bool handlerPointerCancel(PointerCancelEvent event) {
    for (final action in actions) {
      action.actionUp(event.pointer);
    }
    directional?.directionalUp(event.pointer);
    return super.handlerPointerCancel(event);
  }

  @override
  bool handlerPointerDown(PointerDownEvent event) {
    directional?.directionalDown(event.pointer, event.localPosition);
    for (final action in actions) {
      action.actionDown(event.pointer, event.localPosition);
    }
    return super.handlerPointerDown(event);
  }

  @override
  bool handlerPointerMove(PointerMoveEvent event) {
    for (final action in actions) {
      action.actionMove(event.pointer, event.localPosition);
    }
    directional?.directionalMove(event.pointer, event.localPosition);
    return super.handlerPointerMove(event);
  }

  @override
  bool handlerPointerUp(PointerUpEvent event) {
    for (final action in actions) {
      action.actionUp(event.pointer);
    }
    directional?.directionalUp(event.pointer);
    return super.handlerPointerUp(event);
  }

  @override
  void onGameResize(Vector2 size) {
    initialize(size);
    super.onGameResize(size);
  }

  @override
  void onMount() {
    initialize(size);
    super.onMount();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await directional?.onLoad();
    for (final ac in actions) {
      await ac.onLoad();
    }
  }
}
