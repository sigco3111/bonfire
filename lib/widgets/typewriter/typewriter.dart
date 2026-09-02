import 'dart:async';

import 'package:flutter/material.dart';

class TypeWriter extends StatefulWidget {
  final TextStyle? style;
  final List<TextSpan> text;
  final VoidCallback? onFinish;
  final int speed;
  final bool autoStart;

  /// 텍스트를 수평 방향으로 어떻게 정렬할지 지정합니다.
  final TextAlign textAlign;

  /// 텍스트의 방향성(directionality)입니다.
  ///
  /// 이는 [TextAlign.start] / [TextAlign.end] 같은 [textAlign] 값을
  /// 어떻게 해석할지 결정합니다.
  ///
  /// 또한 양방향(bidirectional) 텍스트 렌더링의 모호성을 해소하는 데도 사용됩니다.
  /// 예를 들어, [text]가 영어 구절 뒤에 히브리어 구절이 오는 경우,
  /// [TextDirection.ltr] 컨텍스트에서는 영어 구절이 왼쪽에, 히브리어 구절이 오른쪽에
  /// 위치하고, [TextDirection.rtl] 컨텍스트에서는 영어 구절이 오른쪽에,
  /// 히브리어 구절이 왼쪽에 위치합니다.
  ///
  /// 별도로 지정하지 않으면 주변 [Directionality]에서 상속됩니다.
  /// 주변 [Directionality]가 없는 경우 null이 될 수 없습니다.
  final TextDirection? textDirection;

  /// 텍스트를 부드러운 줄 바꿈(soft line break)에서 끊을지 여부입니다.
  ///
  /// false인 경우 텍스트 글리프(glyph)는 수평 공간이 무한한 것처럼 배치됩니다.
  final bool softWrap;

  /// 시각적 오버플로(overflow)를 어떻게 처리할지 설정합니다.
  final TextOverflow overflow;

  /// 각 논리 픽셀(logical pixel)당 폰트 픽셀(font pixel)의 수입니다.
  ///
  /// 예를 들어 텍스트 스케일 팩터(text scale factor)가 1.5이면,
  /// 텍스트는 지정된 폰트 크기보다 50% 크게 표시됩니다.
  final TextScaler textScaler;

  /// 텍스트가 차지할 수 있는 최대 줄 수(선택 사항)입니다.
  /// 필요에 따라 줄 바꿈되며, 지정된 줄 수를 초과하면
  /// [overflow] 설정에 따라 잘립니다.
  ///
  /// 1로 지정하면 줄 바꿈이 일어나지 않습니다. 그 외에는 박스 경계에서 줄 바꿈됩니다.
  final int? maxLines;

  /// 동일한 유니코드 문자라도 로케일(locale)에 따라 다르게 렌더링될 수 있는 경우
  /// 사용할 폰트를 선택하는 데 사용됩니다.
  ///
  /// 이 프로퍼티를 별도로 설정할 일은 거의 없습니다. 기본값은
  /// `Localizations.localeOf(context)`로 둘러싼 앱에서 상속됩니다.
  ///
  /// 자세한 내용은 [RenderParagraph.locale]을 참고하세요.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis textWidthBasis;
  const TypeWriter({
    required this.text,
    super.key,
    this.style,
    this.speed = 50,
    this.autoStart = true,
    this.onFinish,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaler = TextScaler.noScaling,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
  });

  @override
  State<TypeWriter> createState() => TypeWriterState();
}

class TypeWriterState extends State<TypeWriter> {
  late StreamController<List<TextSpan>> _textSpanController;
  late List<TextSpan> textSpanList;
  bool _finished = false;

  @override
  void initState() {
    textSpanList = widget.text;
    _textSpanController = StreamController<List<TextSpan>>.broadcast();
    if (widget.autoStart) {
      Future.delayed(Duration.zero, start);
    }
    super.initState();
  }

  @override
  void dispose() {
    _textSpanController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TextSpan>>(
      stream: _textSpanController.stream,
      builder: (context, snapshot) {
        return RichText(
          locale: widget.locale,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
          softWrap: widget.softWrap,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          textScaler: widget.textScaler,
          textWidthBasis: widget.textWidthBasis,
          text: TextSpan(
            children: snapshot.data,
            style: widget.style,
          ),
        );
      },
    );
  }

  Future<void> start({List<TextSpan>? text}) async {
    _finished = false;
    if (text != null) {
      textSpanList = text;
    }
    // Clean the stream to prevent textStyle from changing before the text
    _textSpanController.add([const TextSpan()]);

    for (final span in textSpanList) {
      if (_textSpanController.isClosed) {
        return;
      }
      for (var i = 0; i < (span.text?.length ?? 0); i++) {
        await Future.delayed(Duration(milliseconds: widget.speed));
        if (_textSpanController.isClosed || _finished) {
          return;
        }
        _textSpanController.add(
          [
            ...textSpanList.sublist(0, textSpanList.indexOf(span)),
            TextSpan(
              text: span.text?.substring(0, i + 1),
              style: span.style,
            ),
          ],
        );
      }
    }
    _finished = true;
    widget.onFinish?.call();
  }

  void finishTyping() {
    _finished = true;
    _textSpanController.add([...textSpanList]);
    widget.onFinish?.call();
  }
}
