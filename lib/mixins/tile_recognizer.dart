import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/map/base/tile_component.dart';
import 'package:bonfire/util/extensions/game_component_extensions.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 16/05/22

mixin TileRecognizer on GameComponent {
  /// 현재 아래에 있는 맵 타일의 타입을 확인하는 메서드입니다.
  String? tileTypeBelow() {
    final list = tileTypeListBelow();
    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  /// 현재 아래에 있는 맵 타일의 타입 목록을 확인하는 메서드입니다.
  List<String> tileTypeListBelow() {
    if (!hasGameRef) {
      return [];
    }
    final map = gameRef.map;
    if (map.getRenderedTiles().isNotEmpty) {
      return tileListBelow().map<String>((e) => e.tileClass!).toList();
    }
    return [];
  }

  /// 현재 아래에 있는 맵 타일의 속성을 확인하는 메서드입니다.
  Map<String, dynamic>? tilePropertiesBelow() {
    final list = tilePropertiesListBelow();
    if (list?.isNotEmpty == true) {
      return list?.first;
    }

    return null;
  }

  /// 현재 아래에 있는 맵 타일의 속성 목록을 확인하는 메서드입니다.
  List<Map<String, dynamic>>? tilePropertiesListBelow() {
    if (!hasGameRef) {
      return null;
    }
    final map = gameRef.map;
    if (map.layers.isNotEmpty) {
      return tileListBelow()
          .map<Map<String, dynamic>>((e) => e.properties!)
          .toList();
    }
    return null;
  }

  /// 아래에 어떤 맵 타일이 있는지 확인하는 메서드입니다.
  Iterable<TileComponent> tileListBelow() {
    if (!hasGameRef) {
      return [];
    }
    final map = gameRef.map;
    if (map.layers.isNotEmpty) {
      return map.getRenderedTiles().where((element) {
        return element.overlaps(rectCollision) && (element.properties != null);
      });
    }
    return [];
  }
}
