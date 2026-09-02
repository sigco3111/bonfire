import 'package:example/core/widgets/bonfire_version.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GifView.asset(
                  'assets/bonfire.gif',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  'Bonfire가 무엇인가요?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Bonfire는 게임 개발 프레임워크로, 더 쉽고 명료하며 빠른 방식으로\nFlutter/Flame 게임을 만들 수 있게 해줍니다!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kToolbarHeight),
              ],
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: BonfireVersion(),
          ),
        ),
      ],
    );
  }
}
