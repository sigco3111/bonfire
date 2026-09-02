// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:async';

import 'package:bonfire/mixins/pointer_detector.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/src/game/game_render_box.dart';
import 'package:flame/src/game/game_widget/gesture_detector_builder.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef GameLoadingWidgetBuilder = Widget Function(
  BuildContext,
);

typedef GameErrorWidgetBuilder = Widget Function(
  BuildContext,
  Object error,
);

typedef OverlayWidgetBuilder<T extends Game> = Widget Function(
  BuildContext context,
  T game,
);

typedef GameFactory<T extends Game> = T Function();

/// [Game] 인스턴스를 Flutter 위젯 트리에 연결하는 역할을 하는 [StatefulWidget]입니다.
class ListenerGameWidget<T extends Game> extends StatefulWidget {
  /// 일반 생성자가 사용된 경우, 이 위젯이 렌더링할 게임 인스턴스입니다.
  /// [ListenerGameWidget.controlled] 생성자가 사용된 경우, 이 값은 항상 `null`이 됩니다.
  final T? game;

  /// 이 위젯이 렌더링할 [Game]을 생성하는 함수입니다.
  final GameFactory<T>? gameFactory;

  /// 게임 내 텍스트 요소에 사용될 텍스트 방향입니다.
  final TextDirection? textDirection;

  /// Game의 `Game.onLoad` 및 `Game.onMount`를 통해 제공된 [Future]가 해결될 때까지
  /// 빌드될 위젯 트리를 제공하는 빌더입니다.
  /// 기본값은 빈 Container()입니다.
  final GameLoadingWidgetBuilder? loadingBuilder;

  /// 설정되면 onLoad 메서드 중 발생하는 오류가 throw되지 않고,
  /// 대신 이 위젯이 표시됩니다. 제공되지 않으면 오류가 상위로 전파됩니다.
  final GameErrorWidgetBuilder? errorBuilder;

  /// 게임 요소와 [Game.backgroundColor]를 통해 제공된 배경색 사이에
  /// 빌드될 위젯 트리를 제공하는 빌더입니다.
  final WidgetBuilder? backgroundBuilder;

  /// 오버레이 위젯을 표시하기 위한 맵입니다.
  ///
  /// 참고:
  /// - [ListenerGameWidget]
  /// - [Game.overlays]
  final Map<String, OverlayWidgetBuilder<T>>? overlayBuilderMap;

  /// 이벤트 입력을 받기 위한 게임 포커스를 제어하는 [FocusNode]입니다.
  /// 생략하면 내부에서 관리되는 기본 focus node가 사용됩니다.
  final FocusNode? focusNode;

  /// 게임이 마운트될 때 [focusNode]가 포커스를 요청할지 여부입니다.
  /// 기본값은 true입니다.
  final bool autofocus;

  final MouseCursor? mouseCursor;
  final List<String>? initialActiveOverlays;

  /// Flutter 위젯 트리에서 [game]을 렌더링합니다.
  ///
  /// 예:
  /// ```
  /// // State 내부에서...
  /// late MyGameClass game;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   game = MyGameClass();
  /// }
  /// ...
  /// Widget build(BuildContext context) {
  ///   return GameWidget(
  ///     game: game,
  ///   )
  /// }
  /// ...
  /// ```
  ///
  /// 위젯 서브트리로 게임 표면 위에 위젯 레이어를 렌더링할 수도 있습니다.
  ///
  /// 이를 위해서는 [overlayBuilderMap]을 제공해야 합니다. 이 오버레이들의 가시성은
  /// [Game.overlays] 프로퍼티로 제어됩니다.
  ///
  /// 예:
  /// ```
  /// ...
  ///
  /// final game = MyGame();
  ///
  /// Widget build(BuildContext  context) {
  ///   return GameWidget(
  ///     game: game,
  ///     overlayBuilderMap: {
  ///       'PauseMenu': (ctx, game) {
  ///         return Text('일시정지 메뉴');
  ///       },
  ///     },
  ///   )
  /// }
  /// ...
  /// game.overlays.add('PauseMenu');
  /// ```
  ListenerGameWidget({
    required T this.game,
    super.key,
    this.textDirection,
    this.loadingBuilder,
    this.errorBuilder,
    this.backgroundBuilder,
    this.overlayBuilderMap,
    this.initialActiveOverlays,
    this.focusNode,
    this.autofocus = true,
    this.mouseCursor,
    this.addRepaintBoundary = true,
  }) : gameFactory = null {
    _initializeGame(game!);
  }

  /// 게임이 [RepaintBoundary]의 동작을 가정해야 할지 여부이며, 기본값은 `true`입니다.
  final bool addRepaintBoundary;

  /// 위젯 오버레이와 함께 Flutter 위젯 트리에서 [game]을 렌더링합니다.
  ///
  /// 오버레이를 사용하려면 게임 서브클래스에 HasWidgetsOverlay가 mixin되어 있어야 합니다.
  @override
  ListenerGameWidgetState<T> createState() => ListenerGameWidgetState<T>();

  void _initializeGame(T game) {
    if (mouseCursor != null) {
      game.mouseCursor = mouseCursor!;
    }
    if (overlayBuilderMap != null) {
      for (final kv in overlayBuilderMap!.entries) {
        game.overlays.addEntry(
          kv.key,
          (ctx, game) => kv.value(ctx, game as T),
        );
      }
    }
    if (initialActiveOverlays != null) {
      game.overlays.addAll(initialActiveOverlays!);
    }
  }
}

class ListenerGameWidgetState<T extends Game>
    extends State<ListenerGameWidget<T>> {
  late T currentGame;

  Future<void> get loaderFuture => _loaderFuture ??= (() async {
        final game = currentGame;
        assert(game.hasLayout);
        await game.load();
        game.mount();
        if (!game.paused) {
          game.update(0);
        }
      })();

  Future<void>? _loaderFuture;

  late FocusNode _focusNode;

  /// 현재 실행 중인 `build()` 함수의 수입니다.
  int _buildDepth = 0;

  /// true인 경우, 현재 빌드가 완료된 직후 새로운 빌드가 예약됩니다.
  /// 이는 [_buildDepth]가 0이 아닐 때에만 true로 설정되어야 합니다.
  bool _requiresRebuild = false;

  /// [build]가 실행되는 동안 `_buildDepth > 0`이 되도록 arranging하고,
  /// 빌드 중에 [_requiresRebuild] 플래그가 설정되었으면 재빌드를 예약하는 헬퍼 메서드입니다.
  ///
  /// 이 동작이 필요한 이유는, 우리의 build 함수가 사용자 코드를 호출하고
  /// 그 과정에서 [Game]의 일부 프로퍼티를 변경할 수 있기 때문입니다.
  /// 이 경우 [ListenerGameWidget]을 다시 빌드해야 하지만, Flutter는 위젯이 빌드 도중에는
  /// dirty로 표시될 수 없습니다. 따라서 이러한 제한을 우회하여 사용자 코드가
  /// [Game]의 프로퍼티를 자유롭게 설정하고, 가능한 한 빨리 [ListenerGameWidget]에
  /// 반영될 수 있도록 이 메서드가 필요합니다.
  Widget _protectedBuild(Widget Function() build) {
    late final Widget result;
    try {
      _buildDepth++;
      result = build();
    } finally {
      _buildDepth--;
    }
    if (_requiresRebuild && _buildDepth == 0) {
      Future.microtask(_onGameStateChange);
    }
    return result;
  }

  void _onGameStateChange() {
    if (_buildDepth > 0) {
      _requiresRebuild = true;
    } else {
      setState(() => _requiresRebuild = false);
    }
  }

  void initCurrentGame() {
    if (widget.game == null) {
      currentGame = widget.gameFactory!.call();
      widget._initializeGame(currentGame);
    } else {
      currentGame = widget.game!;
    }
    currentGame.addGameStateListener(_onGameStateChange);
    _loaderFuture = null;
  }

  /// 테스트에서 가시화된(visible for testing) 메서드입니다:
  /// https://github.com/flame-engine/flame/issues/2771
  @visibleForTesting
  static void initGameStateListener(
    Game currentGame,
    void Function() onGameStateChange,
  ) {
    currentGame.addGameStateListener(onGameStateChange);

    // See https://github.com/flame-engine/flame/issues/2771
    // for why we aren't using [WidgetsBinding.instance.lifecycleState].
    currentGame.lifecycleStateChange(AppLifecycleState.resumed);
  }

  /// [disposeCurrentGame]은 두 가지 Flutter 이벤트인 `didUpdateWidget`과
  /// `dispose`에서 호출됩니다. [callGameOnDispose] 매개변수가 true이면
  /// `currentGame`의 `onDispose` 메서드가 호출되고, 그렇지 않으면 호출되지 않습니다.
  void disposeCurrentGame({bool callGameOnDispose = false}) {
    currentGame.removeGameStateListener(_onGameStateChange);
    currentGame.lifecycleStateChange(AppLifecycleState.paused);
    currentGame.finalizeRemoval();
    if (callGameOnDispose) {
      currentGame.onDispose();
    }
  }

  @override
  void initState() {
    super.initState();
    initCurrentGame();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.autofocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(ListenerGameWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.game != widget.game) {
      disposeCurrentGame();
      initCurrentGame();
    }
  }

  @override
  void dispose() {
    super.dispose();
    disposeCurrentGame(callGameOnDispose: true);
    // If we received a focus node from the user, they are responsible
    // for disposing it
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode focusNode, KeyEvent event) {
    final game = currentGame;

    if (!_focusNode.hasPrimaryFocus) {
      return KeyEventResult.ignored;
    }

    if (game is KeyboardEvents) {
      return game.onKeyEvent(
        event,
        HardwareKeyboard.instance.logicalKeysPressed,
      );
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return _protectedBuild(() {
      Widget internalGameWidget = RenderGameWidget(
        game: currentGame,
        addRepaintBoundary: widget.addRepaintBoundary,
        behavior: HitTestBehavior.opaque,
      );

      assert(
        !(currentGame is MultiTouchDragDetector && currentGame is PanDetector),
        'WARNING: Both MultiTouchDragDetector and a PanDetector detected. '
        'The MultiTouchDragDetector will override the PanDetector and it will '
        'not receive events',
      );

      internalGameWidget =
          currentGame.gestureDetectors.build(internalGameWidget);

      if (hasMouseDetectors(currentGame)) {
        internalGameWidget = applyMouseDetectors(
          currentGame,
          internalGameWidget,
        );
      }

      final stackedWidgets = <Widget>[internalGameWidget];
      _addBackground(context, stackedWidgets);
      _addOverlays(context, stackedWidgets);

      // We can use Directionality.maybeOf when that method lands on stable
      final textDir = widget.textDirection ?? TextDirection.ltr;

      return ClipRect(
        child: Listener(
          onPointerDown: currentGame is PointerDetector
              ? (currentGame as PointerDetector).onPointerDown
              : null,
          onPointerMove: currentGame is PointerDetector
              ? (currentGame as PointerDetector).onPointerMove
              : null,
          onPointerUp: currentGame is PointerDetector
              ? (currentGame as PointerDetector).onPointerUp
              : null,
          onPointerCancel: currentGame is PointerDetector
              ? (currentGame as PointerDetector).onPointerCancel
              : null,
          onPointerHover: currentGame is PointerDetector
              ? (currentGame as PointerDetector).onPointerHover
              : null,
          onPointerSignal: currentGame is PointerDetector
              ? (currentGame as PointerDetector).onPointerSignal
              : null,
          child: FocusScope(
            child: Focus(
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              descendantsAreFocusable: true,
              onKeyEvent: _handleKeyEvent,
              child: MouseRegion(
                cursor: currentGame.mouseCursor,
                child: Directionality(
                  textDirection: textDir,
                  child: ColoredBox(
                    color: currentGame.backgroundColor(),
                    child: LayoutBuilder(
                      builder: (_, BoxConstraints constraints) {
                        return _protectedBuild(() {
                          final size = constraints.biggest.toVector2();
                          if (size.isZero()) {
                            return widget.loadingBuilder?.call(context) ??
                                Container();
                          }
                          currentGame.onGameResize(size);
                          // This should only be called if the game has already
                          // been loaded (in the case of resizing for example),
                          // since update otherwise should be called after
                          // onMount.
                          if (!currentGame.paused && currentGame.isAttached) {
                            currentGame.update(0);
                          }
                          return FutureBuilder(
                            future: loaderFuture,
                            builder: (_, snapshot) {
                              if (snapshot.hasError) {
                                final errorBuilder = widget.errorBuilder;
                                if (errorBuilder == null) {
                                  throw Error.throwWithStackTrace(
                                    snapshot.error!,
                                    snapshot.stackTrace!,
                                  );
                                } else {
                                  return errorBuilder(context, snapshot.error!);
                                }
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Stack(children: stackedWidgets);
                              }

                              return widget.loadingBuilder?.call(context) ??
                                  const SizedBox.expand();
                            },
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _addBackground(BuildContext context, List<Widget> stackWidgets) {
    if (widget.backgroundBuilder != null) {
      final backgroundContent = KeyedSubtree(
        key: ValueKey(widget.game),
        child: widget.backgroundBuilder!(context),
      );
      stackWidgets.insert(0, backgroundContent);
    }
  }

  void _addOverlays(BuildContext context, List<Widget> stackWidgets) {
    stackWidgets.addAll(
      currentGame.overlays.buildCurrentOverlayWidgets(context),
    );
  }
}
