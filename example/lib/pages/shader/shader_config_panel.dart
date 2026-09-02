import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'shader_config_controller.dart';

class ShaderConfigPanel extends StatefulWidget {
  final ShaderConfigController controller;
  const ShaderConfigPanel({super.key, required this.controller});

  @override
  State<ShaderConfigPanel> createState() => _ShaderConfigPanelState();
}

class _ShaderConfigPanelState extends State<ShaderConfigPanel> {
  late double speed;
  late double distortionStrength;
  late double opacity;
  late Color toneColor;
  late Color lightColor;
  late Vector2 lightRange;

  @override
  void initState() {
    speed = widget.controller.config.speed;
    distortionStrength = widget.controller.config.distortionStrength;
    toneColor = widget.controller.config.toneColor;
    lightColor = widget.controller.config.lightColor;
    opacity = widget.controller.config.opacity;
    lightRange = widget.controller.config.lightRange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('속도: ${speed.toStringAsFixed(3)}'),
              Slider(
                value: speed,
                min: 0,
                max: 0.5,
                onChanged: (value) {
                  setState(() {
                    speed = value;
                  });
                  widget.controller.update(
                    widget.controller.config.copyWith(
                      speed: speed,
                    ),
                  );
                },
              ),
              Text('왜곡 강도: ${distortionStrength.toStringAsFixed(3)}'),
              Slider(
                value: distortionStrength,
                min: 0,
                max: 0.5,
                onChanged: (value) {
                  setState(() {
                    distortionStrength = value;
                  });
                  widget.controller.update(
                    widget.controller.config.copyWith(
                      distortionStrength: distortionStrength,
                    ),
                  );
                },
              ),
              Text('불투명도: ${opacity.toStringAsFixed(3)}'),
              Slider(
                value: opacity,
                min: 0,
                max: 1,
                onChanged: (value) {
                  setState(() {
                    opacity = value;
                  });
                  widget.controller.update(
                    widget.controller.config.copyWith(
                      opacity: opacity,
                    ),
                  );
                },
              ),
              Text(
                  '광원 범위: 최소 ${lightRange.x.toStringAsFixed(3)} | 최대 ${lightRange.y.toStringAsFixed(3)}'),
              RangeSlider(
                values: RangeValues(lightRange.x, lightRange.y),
                min: 0,
                max: 1,
                onChanged: (value) {
                  setState(() {
                    lightRange = Vector2(value.start, value.end);
                  });
                  widget.controller.update(
                    widget.controller.config.copyWith(
                      lightRange: lightRange,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('톤 색상'),
                    const SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        showColorPicker(
                          toneColor,
                          (value) {
                            setState(() {
                              toneColor = value;
                            });
                            widget.controller.update(
                              widget.controller.config.copyWith(
                                toneColor: toneColor,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: toneColor,
                          shape: BoxShape.circle,
                        ),
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('광원 색상'),
                    const SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        showColorPicker(
                          lightColor,
                          (value) {
                            setState(() {
                              lightColor = value;
                            });
                            widget.controller.update(
                              widget.controller.config.copyWith(
                                lightColor: lightColor,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: lightColor,
                          shape: BoxShape.circle,
                        ),
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showColorPicker(Color color, ValueChanged<Color> onChange) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('색상을 선택하세요!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: onChange,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('선택 완료'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
