import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'components/card.dart';
import 'components/foundation.dart';
import 'components/pile.dart';
import 'components/stock.dart';
import 'components/waste.dart';

class KlondikeGame extends FlameGame {
  // 카드 설정 글로벌 상수
  static const double cardGap = 175.0;
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);

  @override
  Future<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');

    // 1개의 Stock, 1개의 Waste, 4개의 Foundation, 7개의 Pile 컴포넌트를 생성한다
    final stock = Stock()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);
    final foundations = List.generate(
      4,
      (i) => Foundation()
        ..size = cardSize
        ..position =
            Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );
    final piles = List.generate(
      7,
      (i) => Pile()
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
    );

    // main World컴포넌트를 생성해서 모든 컴포넌트를 추가한다
    final world = World()
      ..add(stock)
      ..add(waste)
      ..addAll(foundations)
      ..addAll(piles);

    // World 컴포넌트를 현재 게임에 추가한다
    add(world);

    /**
     * world를 보기 위한 카메라 오브젝트를 생성한다
     * 카메라는 viewport와 viewfinder로 구성된다
     * viewport는 게임 화면의 크기를 나타내고, viewfinder는 viewport에서 보여지는 영역을 나타낸다
     * default viewport는 MaxViewport이다
     */
    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize =
          Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap)
      ..viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);

    final random = Random();
    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 4; j++) {
        final card = Card(random.nextInt(13) + 1, random.nextInt(4))
          ..position = Vector2(100 + i * 1150, 100 + j * 1500)
          ..addToParent(world);
        // flip the card face-up with 90% probability
        if (random.nextDouble() < 0.9) {
          card.flip();
        }
      }
    }
  }
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
