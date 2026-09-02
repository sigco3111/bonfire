import 'package:bonfire/bonfire.dart';

/// [GameInterface]에 텍스트를 추가하는 데 사용되는 컴포넌트입니다.
class TextInterfaceComponent extends InterfaceComponent {
  String text;
  late TextPaint textConfig;
  TextInterfaceComponent({
    required super.id,
    required super.position,
    this.text = '',
    super.onTapComponent,
    TextStyle? textConfig,
  }) : super(
          size: Vector2.zero(),
        ) {
    this.textConfig = TextPaint(style: textConfig);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textConfig.render(
      canvas,
      text,
      Vector2.zero(),
    );
  }

  @override
  void update(double dt) {
    if (size == Vector2.zero()) {
      size = Vector2(
        textConfig.getLineMetrics(text).width,
        textConfig.getLineMetrics(text).height,
      );
    }
    super.update(dt);
  }
}
