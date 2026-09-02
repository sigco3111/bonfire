import 'package:bonfire/bonfire.dart';
import 'package:example/pages/mini_games/platform/fox_player.dart';
import 'package:example/pages/mini_games/platform/gem_decoration.dart';
import 'package:flutter/material.dart';

class PlatformGameController extends GameComponent {
  bool showGameOver = false;
  bool showWin = false;
  final VoidCallback reset;

  PlatformGameController({required this.reset});
  @override
  void update(double dt) {
    if (checkInterval('check win', 500, dt)) {
      _checkWin();
      _checkGameOver();
    }
    super.update(dt);
  }

  void _checkWin() {
    var containGem = gameRef.query<GemDecoration>().isNotEmpty;
    if (!containGem && !showWin) {
      showWin = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('축하합니다'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  void _checkGameOver() {
    if (gameRef.query<FoxPlayer>().isEmpty && !showGameOver) {
      showGameOver = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('게임 오버'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  reset();
                },
                child: const Text('다시 시도'),
              ),
            ],
          );
        },
      );
    }
  }
}
