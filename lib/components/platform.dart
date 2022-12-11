import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/config.dart';

enum KeyboardInputType { wasd, arrows }

class PlatformComp extends RectangleComponent
    with KeyboardHandler, CollisionCallbacks {
  double _velocityX = 0.0;

  PlatformComp({
    required Vector2 position,
    required this.inputType,
  }) : super(
          paint: Paint()..color = kObjectColor,
          size: Vector2(kPlatformWidth, kPlatformHeight),
          position: position,
          anchor: Anchor.center,
        );

  final KeyboardInputType inputType;

  @override
  Future<void>? onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x += _velocityX * dt;
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isRightClicked = keysPressed.contains(
        inputType == KeyboardInputType.arrows
            ? LogicalKeyboardKey.arrowRight
            : LogicalKeyboardKey.keyD);
    final isLeftClicked = keysPressed.contains(
        inputType == KeyboardInputType.arrows
            ? LogicalKeyboardKey.arrowLeft
            : LogicalKeyboardKey.keyA);

    if (isRightClicked && !isLeftClicked) {
      _velocityX = kPlatformMovementSpeed;
    } else if (isLeftClicked && !isRightClicked) {
      _velocityX = -kPlatformMovementSpeed;
    } else {
      _velocityX = 0;
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ScreenHitbox && intersectionPoints.first.x <= 0) {
      position.x = kPlatformWidth / 2;
    } else if (other is ScreenHitbox &&
        intersectionPoints.first.x >= other.width) {
      position.x = other.width - kPlatformWidth / 2;
    }

    super.onCollision(intersectionPoints, other);
  }
}
