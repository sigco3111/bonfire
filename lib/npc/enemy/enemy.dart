import 'package:bonfire/mixins/attackable.dart';
import 'package:bonfire/npc/npc.dart';

export 'platform_enemy.dart';
export 'rotation_enemy.dart';
export 'simple_enemy.dart';

/// 적(enemy)을 표현하는 데 사용됩니다.
class Enemy extends Npc with Attackable {
  Enemy({
    required super.position,
    required super.size,
    double life = 10,
    super.speed,
    AcceptableAttackOriginEnum receivesAttackFrom =
        AcceptableAttackOriginEnum.PLAYER_AND_ALLY,
  }) {
    this.receivesAttackFrom = receivesAttackFrom;
    initialLife(life);
  }
}
