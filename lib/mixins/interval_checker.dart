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
/// 작성일: 17/05/22
mixin InternalChecker on Component {
  /// 어떤 동작의 빈도를 제어하기 위해 사용될 수 있는 시각들을 저장하는 데 사용되는 맵입니다.
  Map<String, IntervalTick>? _timers;

  /// 정의된 밀리초(millisecond) 간격이 매번 지날 때마다 true를 반환합니다.
  /// `Timer.periodic`과 유사합니다.
  /// [update]와 관련된 흐름에서 사용됩니다.
  bool checkInterval(
    String key,
    int intervalInMilli,
    double dt, {
    bool firstCheckIsTrue = true,
  }) {
    _timers ??= {};
    if (_timers![key]?.interval != intervalInMilli) {
      _timers![key] = IntervalTick(intervalInMilli);
      return firstCheckIsTrue;
    } else {
      return _timers![key]?.update(dt) ?? false;
    }
  }

  void resetInterval(String key) {
    _timers?.remove(key);
  }

  void tickInterval(String key) {
    _timers?[key]?.tick();
  }

  void pauseEffectController(String key) {
    _timers?[key]?.pause();
  }

  void playInterval(String key) {
    _timers?[key]?.play();
  }

  bool invervalIsRunning(String key) {
    return _timers?[key]?.running ?? false;
  }

  @override
  void onRemove() {
    super.onRemove();
    _timers?.clear();
  }
}
