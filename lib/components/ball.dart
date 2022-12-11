import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/config.dart';
import 'package:pong/components/platform.dart';
import 'package:pong/cubit/result_cubit.dart';
import 'package:pong/pong_game.dart';

class BallComp extends CircleComponent
    with
        CollisionCallbacks,
        FlameBlocListenable<ResultCubit, ResultState>,
        HasGameRef<PongGame>,
        KeyboardHandler {
  double _velocityX = 0.0;
  double _velocityY = 0.0;

  BallComp({required Vector2 position})
      : super(
          paint: Paint()..color = kObjectColor,
          radius: kBallRadius,
          position: position,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() {
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x += _velocityX * dt;
    position.y += _velocityY * dt;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlatformComp) {
      _velocityY *= -1;
      _velocityX = (position.x - other.position.x) * 10;
    } else if (other is ScreenHitbox) {
      if (intersectionPoints.first.y <= 0) {
        bloc.increment(bottom: true);
        _velocityY = 0;
        _velocityX = 0;
        position = Vector2(
          gameRef.size.x / 2,
          kPlatformHeight + kBallRadius + 16,
        );
      }

      if (intersectionPoints.first.y >= other.height) {
        bloc.increment(top: true);
        _velocityY = 0;
        _velocityX = 0;
        position = Vector2(
          gameRef.size.x / 2,
          gameRef.size.y - kPlatformHeight - kBallRadius - 16,
        );
      }

      if (intersectionPoints.first.x <= 0 ||
          intersectionPoints.first.x >= other.width) _velocityX *= -1;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isSpaceClicked = keysPressed.contains(LogicalKeyboardKey.space);
    final isNotMoving = _velocityX == 0 && _velocityY == 0;
    final isStartingOnTop = position.y < gameRef.size.y / 2;

    if (isSpaceClicked && isNotMoving && isStartingOnTop) {
      _velocityY = _velocityX = kBallMovementSpeed;
    } else if (isSpaceClicked && isNotMoving && !isStartingOnTop) {
      _velocityY = _velocityX = -kBallMovementSpeed;
    }

    return true;
  }
}
