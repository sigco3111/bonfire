import 'dart:async';

import 'package:bonfire/bonfire.dart';

///
/// 작성자 (Created by)
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// 작성일: 04/02/22
mixin UseAssetsLoader on Component {
  /// [onLoad]에서 자원을 로드하는 데 사용됩니다.
  AssetsLoader? loader = AssetsLoader();
  @override
  Future<void> onLoad() async {
    await loader?.load();
    loader = null;
    return super.onLoad();
  }
}

class AssetToLoad<T> {
  Function(T? value)? callback;
  final FutureOr<T>? future;

  AssetToLoad(this.future, this.callback);
  Future<void> load() async {
    if (future == null) {
      return Future.value();
    }
    callback?.call(await future);
    callback = null;
  }
}

class AssetsLoader<T> {
  final List<AssetToLoad> _assets = [];

  void add(AssetToLoad asset) => _assets.add(asset);

  FutureOr<void> load() async {
    for (final element in _assets) {
      await element.load();
    }
    _assets.clear();
  }
}
