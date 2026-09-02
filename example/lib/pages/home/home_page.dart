import 'package:bonfire/bonfire.dart';
import 'package:example/pages/collision/collision_page.dart';
import 'package:example/pages/enemy/enemy_page.dart';
import 'package:example/pages/forces/forces_page.dart';
import 'package:example/pages/home/widgets/drawer/home_drawer.dart';
import 'package:example/pages/home/widgets/home_content.dart';
import 'package:example/pages/input/drag/drag_gesture_page.dart';
import 'package:example/pages/input/keyboard/keyboard_page.dart';
import 'package:example/pages/input/mouse/mouse_input_page.dart';
import 'package:example/pages/input/move_camera_mouse/move_camera_page.dart';
import 'package:example/pages/input/tap/tap_gesture_page.dart';
import 'package:example/pages/lighting/lighting_page.dart';
import 'package:example/pages/map/spritefusion/spritefusion_page.dart';
import 'package:example/pages/map/terrain_builder/terrain_builder_page.dart';
import 'package:example/pages/map/tiled/tiled_network_page.dart';
import 'package:example/pages/map/tiled/tiled_page.dart';
import 'package:example/pages/mini_games/manual_map/game_manual_map.dart';
import 'package:example/pages/mini_games/multi_scenario/multi_scenario_game.dart';
import 'package:example/pages/mini_games/platform/platform_game.dart';
import 'package:example/pages/mini_games/random_map/random_map_game.dart';
import 'package:example/pages/mini_games/simple_example/simple_example_game.dart';
import 'package:example/pages/mini_games/tiled_map/game_tiled_map.dart';
import 'package:example/pages/mini_games/top_down_game/top_down_game.dart';
import 'package:example/pages/parallax/bonfire/bonfire_parallax_page.dart';
import 'package:example/pages/parallax/flame/parallax_page.dart';
import 'package:example/pages/path_finding/path_finding_page.dart';
import 'package:example/pages/performance/performance_game.dart';
import 'package:example/pages/player/platform/platform_player_page.dart';
import 'package:example/pages/player/rotation/rotation_player_page.dart';
import 'package:example/pages/player/simple/simple_player_page.dart';
import 'package:example/pages/shader/shader_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../player_controllers/player_controllers_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget content = const HomeContent();
  ItemDrawer? itemSelected;
  late List<SectionDrawer> menu;

  @override
  void initState() {
    menu = _buildMenu();
    itemSelected = menu.first.itens.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Bonfire 예제'),
      ),
      drawer: HomeDrawer(
        itemSelected: itemSelected,
        itens: menu,
        onChange: _onChange,
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: content,
          ),
          if (itemSelected?.codeUrl.isNotEmpty == true)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _launch(itemSelected!.codeUrl),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  child: const Text(
                    '소스 코드',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  void _onChange(ItemDrawer value) {
    setState(() {
      itemSelected = value;
      content = value.builder(context);
    });
  }

  List<SectionDrawer> _buildMenu() {
    return [
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'home',
            name: '홈',
            builder: (_) => const HomeContent(),
          ),
        ],
      ),
      SectionDrawer(
        id: 'map',
        name: '맵',
        itens: [
          ItemDrawer(
            id: 'tiled',
            name: 'Tiled 사용',
            builder: (_) => const TiledPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/map/tiled',
          ),
          ItemDrawer(
            id: 'tiled_url',
            name: 'Tiled URL 사용',
            builder: (_) => const TiledNetworkPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/map/tiled',
          ),
          ItemDrawer(
            id: 'spritefusion',
            name: 'Spritefusion 사용',
            builder: (_) => const SpritefusionPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/map/spritefusion',
          ),
          ItemDrawer(
            id: 'matrix',
            name: '매트릭스 사용',
            builder: (_) => const TerrainBuilderPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/map/terrain_builder',
          ),
        ],
      ),
      SectionDrawer(
        id: 'input',
        name: '입력',
        itens: [
          ItemDrawer(
            id: 'tap',
            name: '탭 동작',
            builder: (_) => const TapGesturePage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/input/tap',
          ),
          ItemDrawer(
            id: 'drag',
            name: '드래그 동작',
            builder: (_) => const DragGesturePage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/input/drag',
          ),
          ItemDrawer(
            id: 'move_camera',
            name: '카메라 이동',
            builder: (_) => const MoveCameraPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/input/move_camera_mouse',
          ),
          ItemDrawer(
            id: 'mouse',
            name: '마우스',
            builder: (_) => const MouseInputPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/input/mouse',
          ),
          ItemDrawer(
            id: 'keyboard',
            name: '키보드',
            builder: (_) => const KeyboardPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/input/keyboard',
          ),
          ItemDrawer(
            id: 'player_controllers',
            name: '플레이어 컨트롤러',
            builder: (_) => const PlayerControllersPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/player_controllers',
          ),
        ],
      ),
      SectionDrawer(
        id: 'player',
        name: '플레이어',
        itens: [
          ItemDrawer(
            id: 'simple_player',
            name: '단순 플레이어',
            builder: (_) => const SimplePlayerPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/player/simple',
          ),
          ItemDrawer(
            id: 'rotation_player',
            name: '회전 플레이어',
            builder: (_) => const RotationPlayerPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/player/rotation',
          ),
          ItemDrawer(
            id: 'platform_player',
            name: '플랫폼 플레이어',
            builder: (_) => const PlatformPlayerPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/player/platform',
          )
        ],
      ),
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'enemy',
            name: '적',
            builder: (_) => const EnemyPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/enemy',
          ),
        ],
      ),
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'forces',
            name: '힘',
            builder: (_) => const ForcesPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/forces',
          ),
        ],
      ),
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'block_movement_collision',
            name: '이동 차단 충돌',
            builder: (_) => const CollisionPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/forces',
          ),
        ],
      ),
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'lighting',
            name: '조명',
            builder: (_) => const LightingPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/lighting',
          ),
        ],
      ),
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'path_finding',
            name: '경로 탐색',
            builder: (_) => const PathFindingPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/path_finding',
          ),
        ],
      ),
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'shader',
            name: '셰이더',
            builder: (_) => const ShaderPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/shader',
          ),
        ],
      ),
      SectionDrawer(
        itens: [
          ItemDrawer(
            id: 'performance',
            name: '성능',
            builder: (_) => const PerformanceGame(),
            codeUrl: '',
          ),
        ],
      ),
      SectionDrawer(
        id: 'parallax',
        name: '시차 스크롤',
        itens: [
          ItemDrawer(
            id: 'parallax',
            name: '시차 스크롤',
            builder: (_) => const ParallaxPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/parallax/flame',
          ),
          ItemDrawer(
            id: 'camera_parallax',
            name: '카메라 시차',
            builder: (_) => const BonfireParallaxPage(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/blob/develop/example/lib/pages/parallax/bonfire',
          ),
        ],
      ),
      SectionDrawer(
        id: 'mini_games',
        name: '미니 게임',
        itens: [
          ItemDrawer(
            id: 'tiled_map',
            name: 'Tiled 맵',
            builder: (_) => const GameTiledMap(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/tree/develop/example/lib/pages/mini_games',
          ),
          ItemDrawer(
            id: 'topdown_game',
            name: '탑다운 게임',
            builder: (_) => const TopDownGame(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/tree/develop/example/lib/pages/mini_games',
          ),
          ItemDrawer(
            id: 'platform_game',
            name: '플랫폼 게임',
            builder: (_) => const PlatformGame(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/tree/develop/example/lib/pages/mini_games',
          ),
          ItemDrawer(
            id: 'multi_scenario',
            name: '다중 시나리오 게임',
            builder: (_) => const MultiScenario(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/tree/develop/example/lib/pages/mini_games',
          ),
          ItemDrawer(
            id: 'random_map',
            name: '무작위 맵',
            builder: (_) => RandomMapGame(
              size: Vector2(100, 100),
            ),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/tree/develop/example/lib/pages/mini_games',
          ),
          ItemDrawer(
            id: 'manual_map',
            name: '수동 맵 게임',
            builder: (_) => const GameManualMap(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/tree/develop/example/lib/pages/mini_games',
          ),
          ItemDrawer(
            id: 'simple',
            name: '단순 예제',
            builder: (_) => const SimpleExampleGame(),
            codeUrl:
                'https://github.com/RafaelBarbosatec/bonfire/tree/develop/example/lib/pages/mini_games',
          ),
        ],
      ),
    ];
  }

  _launch(String codeUrl) {
    launchUrl(Uri.parse(codeUrl));
  }
}
