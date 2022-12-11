import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pong/pong_game.dart';

void main() {
  runApp(GameWidget(
    game: PongGame(),
  ));
}
