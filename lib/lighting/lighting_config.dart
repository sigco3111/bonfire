import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/pulse_value.dart';
import 'package:flutter/widgets.dart';

/// 조명(lighting) 설정에 사용되는 클래스입니다.
class LightingConfig {
  /// 조명의 반경.
  final double radius;

  /// 조명의 색상.
  final Color color;

  /// 조명에 펄스(pulse) 효과를 활성화합니다.
  final bool withPulse;

  /// 컴포넌트의 각도를 따라 조명이 회전합니다.
  final bool useComponentAngle;

  /// 펄스 효과의 변화 폭을 설정합니다.
  final double pulseVariation;

  /// 펄스 효과의 속도를 설정합니다.
  final double pulseSpeed;

  /// 펄스 효과의 곡선(curve)을 설정합니다.
  final Curve pulseCurve;

  /// 조명의 흐림(blur) 정도를 설정합니다.
  final double blurBorder;

  /// 조명의 종류를 설정합니다.
  final LightingType type;

  final Vector2 align;

  late MaskFilter _maskFilter;

  PulseValue? _pulseAnimation;

  LightingConfig({
    required this.radius,
    required this.color,
    this.withPulse = false,
    this.useComponentAngle = false,
    this.pulseCurve = Curves.decelerate,
    this.pulseVariation = 0.1,
    this.pulseSpeed = 0.1,
    double? blurBorder,
    this.type = LightingType.circle,
    Vector2? align,
  })  : align = align ?? Vector2.zero(),
        blurBorder = blurBorder ?? radius {
    _pulseAnimation = PulseValue(
      speed: pulseSpeed,
      curve: pulseCurve,
      pulseVariation: pulseVariation,
    );

    _maskFilter = MaskFilter.blur(
      BlurStyle.normal,
      _convertRadiusToSigma(this.blurBorder),
    );
  }

  void update(double dt) {
    if (withPulse) {
      _pulseAnimation?.update(dt);
    }
  }

  double get valuePulse => _pulseAnimation?.value ?? 0.0;
  MaskFilter get maskFilter => _maskFilter;

  static double _convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  LightingConfig copyWith({
    double? radius,
    Color? color,
    bool? withPulse,
    bool? useComponentAngle,
    double? pulseVariation,
    double? pulseSpeed,
    Curve? pulseCurve,
    double? blurBorder,
    LightingType? type,
  }) {
    return LightingConfig(
      radius: radius ?? this.radius,
      color: color ?? this.color,
      withPulse: withPulse ?? this.withPulse,
      useComponentAngle: useComponentAngle ?? this.useComponentAngle,
      pulseVariation: pulseVariation ?? this.pulseVariation,
      pulseSpeed: pulseSpeed ?? this.pulseSpeed,
      pulseCurve: pulseCurve ?? this.pulseCurve,
      blurBorder: blurBorder ?? this.blurBorder,
      type: type ?? this.type,
    );
  }
}
