import 'package:bonfire/bonfire.dart';

class WorldBuildData {
  final WorldMap map;
  final List<GameComponent>? components;

  /// 타일 맵의 자식 컴포넌트로 렌더링되어야 하는 데코레이션입니다
  /// (예: 레이어 순서를 따라야 하고 게임 레벨 컴포넌트가 사용하는 동적 Y-sort를
  /// 따르면 안 되는 Tiled에서 오는 크기가 큰 타일들).
  final List<GameComponent>? mapChildren;

  WorldBuildData({
    required this.map,
    this.components,
    this.mapChildren,
  });
}
