import 'package:bonfire/bonfire.dart';
import 'package:example/shared/util/enemy_sprite_sheet.dart';
import 'package:example/shared/util/player_sprite_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerDialog {
  static void execShowTalk(
    BonfireGameInterface gameRef,
    GameComponent first,
    VoidCallback onClose,
  ) {
    gameRef.camera.moveToTargetAnimated(
      effectController: EffectController(duration: 1),
      target: first,
      zoom: 2,
      onComplete: () {
        gameRef.pauseEngine();

        TalkDialog.show(
          gameRef.context,
          [
            Say(
              text: [
                const TextSpan(
                  text: '이거 보세요! 여긴',
                ),
                const TextSpan(
                  text: ' 혼자가 아닌 ',
                  style: TextStyle(color: Colors.red),
                ),
                const TextSpan(
                  text: '것 같네요...',
                ),
              ],
              person: SizedBox(
                width: 100,
                height: 100,
                child: PlayerSpriteSheet.idleRight.asWidget(),
              ),
            ),
            Say(
              text: [
                const TextSpan(
                  text: '로크 타르 오그르!',
                ),
                const TextSpan(
                  text: ' 로크 타르 오그르! ',
                  style: TextStyle(color: Colors.green),
                ),
                const TextSpan(
                  text: ' 로크 타르 오그르! ',
                ),
                const TextSpan(
                  text: '로크 타르 오그르!',
                  style: TextStyle(color: Colors.green),
                ),
              ],
              person: SizedBox(
                width: 100,
                height: 100,
                child: EnemySpriteSheet.idleLeft.asWidget(),
              ),
              personSayDirection: PersonSayDirection.RIGHT,
            ),
          ],
          onClose: () {
            gameRef.resumeEngine();
            onClose();
          },
          onFinish: () {
            // ignore: avoid_print
            print('finish talk');
          },
          logicalKeyboardKeysToNext: [
            LogicalKeyboardKey.space,
            LogicalKeyboardKey.enter
          ],
        );
      },
    );
  }
}
