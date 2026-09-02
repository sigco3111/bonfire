// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

enum PersonSayDirection { LEFT, RIGHT }

class Say {
  /// TalkDialog에 표시될 TextSpan들의 목록입니다.
  /// 예시:
  /// ```dart
  /// [
  ///   TextSpan(text: '새로운'),
  ///   TextSpan(text: ' 아이템 ', style: TextStyle(color: Colors.red)),
  ///   TextSpan(text: '잠금 해제!'),
  /// ]
  /// ```
  final List<TextSpan> text;
  final Widget? person;
  final PersonSayDirection personSayDirection;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? background;
  final Widget? header;
  final Widget? bottom;

  /// 각 문자가 표시되는 데 걸리는 시간(밀리초 단위)입니다.
  /// 기본값은 50입니다.
  final int? speed;

  /// `TalkDialog.show` 안에서 표시될 텍스트 애니메이션을 생성합니다.
  Say({
    required this.text,
    this.personSayDirection = PersonSayDirection.LEFT,
    this.boxDecoration,
    this.padding,
    this.margin,
    this.person,
    this.background,
    this.header,
    this.bottom,
    this.speed,
  });
}
