import 'package:bonfire/background/game_background.dart';
import 'package:bonfire/base/bonfire_collision_config.dart';
import 'package:bonfire/base/bonfire_game.dart';
import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:bonfire/base/bonfire_quad_tree_collision.dart';
import 'package:bonfire/base/bonfire_with_collision.dart';
import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/base/listener_game_widget.dart';
import 'package:bonfire/camera/camera_config.dart';
import 'package:bonfire/color_filter/game_color_filter.dart';
import 'package:bonfire/forces/forces_2d.dart';
import 'package:bonfire/game_interface/game_interface.dart';
import 'package:bonfire/input/player_controller.dart';
import 'package:bonfire/map/base/game_map.dart';
import 'package:bonfire/player/player.dart';
import 'package:bonfire/util/extensions/color_extensions.dart';
import 'package:flutter/material.dart';

class BonfireWidget extends StatefulWidget {
  /// 게임에서 플레이어를 조작합니다. 다양한 방식으로 플레이어를 조작할 수 있도록 컨트롤러 리스트를 전달할 수 있습니다.
  final List<PlayerController>? playerControllers;

  /// 게임에서 사용자가 조작하는 캐릭터를 나타냅니다. 이 클래스의 인스턴스는 바로 쓸 수 있도록 준비된 동작(actions)과 이동(movements)을 가지고 있습니다.
  final Player? player;

  /// 체력바, 스테미나, 설정 등을 그리는 방식입니다. 다시 말해, 게임 인터페이스에 추가할 수 있는 모든 것을 의미합니다.
  final GameInterface? interface;

  /// 게임이 진행되는 맵(또는 월드)을 나타냅니다.
  final GameMap map;

  /// 맵에 그리드를 표시하여 맵의 구성과 테스트를 용이하게 하는 데 사용됩니다.
  final bool debugMode;

  /// 오브젝트의 충돌 영역(area collision)을 그리는 데 사용됩니다.
  final bool showCollisionArea;

  /// `showCollisionArea`가 true일 때 충돌 영역의 색상입니다.
  final Color? collisionAreaColor;

  /// 게임의 조명(lighting) 설정에 사용됩니다.
  final Color? lightingColorGame;

  final Color? backgroundColor;

  /// 이벤트 입력을 받기 위한 게임의 포커스(focus)를 제어하는 [FocusNode]입니다.
  /// 생략하면 내부에서 관리되는 기본 포커스 노드를 사용합니다.
  final FocusNode? focusNode;

  /// 게임이 마운트(mount)될 때 [focusNode]가 포커스를 요청할지 여부입니다.
  /// 기본값은 true입니다.
  final bool autofocus;

  /// 이 [GameWidget]의 초기 마우스 커서입니다.
  /// 마우스 커서는 런타임에 [Game.mouseCursor]를 사용해 변경할 수 있습니다.
  final MouseCursor? mouseCursor;

  final ValueChanged<BonfireGameInterface>? onReady;
  final Map<String, OverlayWidgetBuilder<BonfireGame>>? overlayBuilderMap;
  final List<String>? initialActiveOverlays;
  final List<GameComponent>? components;
  final List<GameComponent>? hudComponents;
  final GameBackground? background;
  final CameraConfig? cameraConfig;
  final GameColorFilter? colorFilter;
  final VoidCallback? onDispose;
  final List<Force2D>? globalForces;
  final BonfireCollisionConfig? collisionConfig;

  const BonfireWidget({
    required this.map,
    super.key,
    this.playerControllers,
    this.player,
    this.interface,
    this.background,
    this.debugMode = false,
    this.showCollisionArea = false,
    this.collisionAreaColor,
    this.lightingColorGame,
    this.backgroundColor,
    this.colorFilter,
    this.hudComponents,
    this.components,
    this.overlayBuilderMap,
    this.initialActiveOverlays,
    this.cameraConfig,
    this.onReady,
    this.focusNode,
    this.autofocus = true,
    this.mouseCursor,
    this.onDispose,
    this.globalForces,
    this.collisionConfig,
  });

  @override
  BonfireWidgetState createState() => BonfireWidgetState();
}

class BonfireWidgetState extends State<BonfireWidget> {
  late BonfireGame _game;
  late BonfireCollisionConfig _collisionConfig;

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  void initState() {
    _collisionConfig =
        widget.collisionConfig ?? BonfireCollisionConfig.dafault();
    _buildGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerGameWidget(
      game: _game,
      overlayBuilderMap: widget.overlayBuilderMap,
      initialActiveOverlays: widget.initialActiveOverlays,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      mouseCursor: widget.mouseCursor,
    );
  }

  void _buildGame() {
    _game = _collisionConfig.when(
      defaultCollision: (c) => BonfireWithCollision(
        configDefault: c,
        context: context,
        playerControllers: widget.playerControllers,
        player: widget.player,
        interface: widget.interface,
        map: widget.map,
        components: widget.components,
        hudComponents: widget.hudComponents,
        background: widget.background,
        backgroundColor: widget.backgroundColor,
        debugMode: widget.debugMode,
        showCollisionArea: widget.showCollisionArea,
        collisionAreaColor: widget.collisionAreaColor ??
            Colors.lightGreenAccent.setOpacity(0.5),
        lightingColorGame: widget.lightingColorGame,
        cameraConfig: widget.cameraConfig,
        colorFilter: widget.colorFilter,
        onReady: widget.onReady,
        globalForces: widget.globalForces,
      ),
      quadTreeCollision: (c) => BonfireQuadTreeCollision(
        configQuadTree: c,
        context: context,
        playerControllers: widget.playerControllers,
        player: widget.player,
        interface: widget.interface,
        map: widget.map,
        components: widget.components,
        hudComponents: widget.hudComponents,
        background: widget.background,
        backgroundColor: widget.backgroundColor,
        debugMode: widget.debugMode,
        showCollisionArea: widget.showCollisionArea,
        collisionAreaColor: widget.collisionAreaColor ??
            Colors.lightGreenAccent.setOpacity(0.5),
        lightingColorGame: widget.lightingColorGame,
        cameraConfig: widget.cameraConfig,
        colorFilter: widget.colorFilter,
        onReady: widget.onReady,
        globalForces: widget.globalForces,
      ),
    );
  }
}
