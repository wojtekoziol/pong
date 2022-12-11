import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pong/components/result.dart';
import 'package:pong/config.dart';
import 'package:pong/components/ball.dart';
import 'package:pong/components/platform.dart';
import 'package:pong/cubit/result_cubit.dart';

class PongGame extends FlameGame
    with
        SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  @override
  Color backgroundColor() => kBackgroundColor;

  @override
  Future<void>? onLoad() {
    add(ScreenHitbox());

    add(PlatformComp(
      position: Vector2(size.x / 2, kPlatformHeight / 2),
      inputType: KeyboardInputType.wasd,
    ));
    add(PlatformComp(
      position: Vector2(size.x / 2, size.y - kPlatformHeight / 2),
      inputType: KeyboardInputType.arrows,
    ));

    add(FlameBlocProvider<ResultCubit, ResultState>(
      create: () => ResultCubit(),
      children: [
        ResultComp(position: Vector2(size.x / 2, size.y / 2)),
        BallComp(
          position: Vector2(
            size.x / 2,
            size.y - kPlatformHeight - kBallRadius - 16,
          ),
        ),
      ],
    ));

    return null;
  }
}
