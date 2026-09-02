import 'dart:ui';

import 'package:bonfire/base/game_component.dart';

// ignore: constant_identifier_names
enum AcceptableAttackOriginEnum { ALL, ENEMY, PLAYER_AND_ALLY, NONE }

// ignore: constant_identifier_names
enum AttackOriginEnum { ENEMY, PLAYER_OR_ALLY, WORLD }

/// 컴포넌트에 데미지를 받는 동작을 추가하는 역할을 하는 mixin입니다.
mixin Attackable on GameComponent {
  /// 어떤 종류의 컴포넌트가 데미지를 받을 수 있는지 정의하는 데 사용됩니다.
  AcceptableAttackOriginEnum receivesAttackFrom =
      AcceptableAttackOriginEnum.ALL;

  /// 적의 생명력(life)입니다.
  double _life = 100;

  /// 적의 최대 생명력(max life)입니다.
  double _maxLife = 100;
  double get maxLife => _maxLife;

  bool _isDead = false;

  double get life => _life;

  /// 초기 생명력을 설정합니다.
  void initialLife(double life) {
    _life = life;
    _maxLife = life;
  }

  /// 생명력을 증가시킵니다.
  void addLife(double life) {
    var newLife = _life + life;

    if (newLife > maxLife) {
      newLife = maxLife;
    }
    onRestoreLife(newLife - _life);
    _life = newLife;

    _verifyLimitsLife();
  }

  // 생명력을 업데이트합니다.
  void updateLife(double life, {bool verifyDieOrRevive = true}) {
    _life = life;
    if (verifyDieOrRevive) {
      _verifyLimitsLife();
    }
  }

  /// 생명력을 감소시킵니다.
  void removeLife(double life) {
    var newLife = _life - life;
    if (newLife < 0) {
      newLife = 0;
    }
    onRemoveLife(_life - newLife);
    _life = newLife;

    _verifyLimitsLife();
  }

  // 생명력이 감소할 때 호출됩니다.
  void onRemoveLife(double life) {}

  // 생명력이 회복될 때 호출됩니다.
  void onRestoreLife(double life) {}

  void _verifyLimitsLife() {
    if (_life > 0 && isDead) {
      onRevive();
    } else if (_life == 0 && !_isDead) {
      onDie();
    }
  }

  /// 이 컴포넌트에 데미지를 주기 위해 호출되는 메서드입니다.
  /// [checkCanReceiveDamage] 메서드가 `true`를 반환할 때만 데미지를 받습니다.
  bool handleAttack(
    AttackOriginEnum attacker,
    double damage,
    dynamic identify,
  ) {
    final canReceive = checkCanReceiveDamage(attacker);
    if (canReceive) {
      onReceiveDamage(attacker, damage, identify);
    }
    return canReceive;
  }

  // 컴포넌트가 데미지를 받을 때 호출됩니다.
  void onReceiveDamage(
    AttackOriginEnum attacker,
    double damage,
    dynamic identify,
  ) {
    removeLife(damage);
  }

  /// 이 컴포넌트가 어떤 공격자로부터도 데미지를 받을 수 있는지
  /// 확인할 때 사용하는 메서드입니다.
  bool checkCanReceiveDamage(AttackOriginEnum attacker) {
    if (isDead || isRemoving) {
      return false;
    }
    switch (receivesAttackFrom) {
      case AcceptableAttackOriginEnum.ALL:
        return true;
      case AcceptableAttackOriginEnum.ENEMY:
        if (attacker == AttackOriginEnum.ENEMY ||
            attacker == AttackOriginEnum.WORLD) {
          return true;
        }
        break;
      case AcceptableAttackOriginEnum.PLAYER_AND_ALLY:
        if (attacker == AttackOriginEnum.PLAYER_OR_ALLY ||
            attacker == AttackOriginEnum.WORLD) {
          return true;
        }
        break;
      case AcceptableAttackOriginEnum.NONE:
        return false;
    }

    return false;
  }

  // 컴포넌트가 죽을 때 호출됩니다.
  void onDie() {
    _isDead = true;
  }

  // 컴포넌트가 부활할 때 호출됩니다.
  void onRevive() {
    _isDead = false;
  }

  bool get isDead => _isDead;

  // 데미지를 받을 때 사용되는 컴포넌트의 충돌 사각형(rect collision)을 가져옵니다.
  Rect rectAttackable() => rectCollision;
}
