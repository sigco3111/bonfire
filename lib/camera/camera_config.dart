// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bonfire/bonfire.dart';

enum InitialMapZoomFitEnum { none, fitWidth, fitHeight, fit }

/// 카메라 동작을 설정하는 데 사용하는 클래스입니다.
class CameraConfig {
  static final movementWindowDefault = Vector2.all(16);

  /// 화면 중앙에서 카메라가 움직이지 않고 컴포넌트가 이동할 수 있는 영역(window)
  Vector2 movementWindow;

  /// true로 설정하면 카메라가 맵 영역 안에 머무릅니다.
  bool moveOnlyMapArea;

  /// 카메라 이동 속도.
  double speed;

  /// 일부 설정에 따라 자동으로 줌을 조정합니다.
  InitialMapZoomFitEnum initialMapZoomFit;

  /// 카메라 줌 설정. 기본값: 1
  final double zoom;

  /// 카메라를 회전시킬 각도. 기본값: 0
  final double angle;

  /// 카메라가 포커스하거나 따라갈 컴포넌트.
  final GameComponent? target;

  final bool startFollowPlayer;

  final Vector2? initPosition;

  final Vector2? resolution;

  CameraConfig({
    this.moveOnlyMapArea = false,
    this.startFollowPlayer = true,
    this.zoom = 1.0,
    this.angle = 0.0,
    this.target,
    this.speed = 5, // no smoth speed sets double.infinity
    this.initialMapZoomFit = InitialMapZoomFitEnum.none,
    this.initPosition,
    Vector2? movementWindow,
    this.resolution,
  }) : movementWindow = movementWindow ?? movementWindowDefault;

  CameraConfig copyWith({
    Vector2? movementWindow,
    bool? moveOnlyMapArea,
    double? zoom,
    double? angle,
    GameComponent? target,
    double? speed,
    bool? startFollowPlayer,
    InitialMapZoomFitEnum? initialMapZoomFit,
    Vector2? initPosition,
    Vector2? resolution,
  }) {
    return CameraConfig(
      movementWindow: movementWindow ?? this.movementWindow,
      moveOnlyMapArea: moveOnlyMapArea ?? this.moveOnlyMapArea,
      zoom: zoom ?? this.zoom,
      angle: angle ?? this.angle,
      target: target ?? this.target,
      speed: speed ?? this.speed,
      startFollowPlayer: startFollowPlayer ?? this.startFollowPlayer,
      initialMapZoomFit: initialMapZoomFit ?? this.initialMapZoomFit,
      initPosition: initPosition ?? this.initPosition,
      resolution: resolution ?? this.resolution,
    );
  }
}
