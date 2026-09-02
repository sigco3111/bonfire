// ignore_for_file: unnecessary_this

import 'package:bonfire/bonfire.dart';

/// 컴포넌트에 조명(lighting)을 설정하는 데 사용되는 믹스인입니다.
mixin Lighting on GameComponent {
  LightingConfig? _lightingConfig;

  /// 회전 각도를 정의하는 데 사용됩니다.
  double lightingAngle = 0.0;

  /// 조명을 켜고 끄는 데 사용됩니다.
  bool lightingEnabled = true;

  /// 설정을 지정하는 데 사용됩니다.
  void setupLighting(LightingConfig? config) => _lightingConfig = config;

  LightingConfig? get lightingConfig => _lightingConfig;

  double _lightingAngle() {
    if (_lightingConfig != null && _lightingConfig?.type is ArcLightingType) {
      final type = _lightingConfig!.type as ArcLightingType;
      if (type.isCenter) {
        return this.angle - (type.endRadAngle / 2);
      } else {
        return this.angle - type.endRadAngle;
      }
    }
    return 0.0;
  }

  @override
  void update(double dt) {
    if (_lightingConfig?.useComponentAngle == true) {
      lightingAngle = _lightingAngle();
    }
    super.update(dt);
  }

  @override
  bool get isVisible {
    return hasGameRef ? gameRef.camera.canSeeWithMargin(this) : false;
  }
}
