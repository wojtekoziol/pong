import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pong/cubit/result_cubit.dart';

class ResultComp extends TextComponent
    with FlameBlocListenable<ResultCubit, ResultState> {
  ResultComp({required Vector2 position})
      : super(text: '0 : 0', position: position);

  @override
  void onNewState(ResultState state) {
    text = '${state.top} : ${state.bottom}';
    super.onNewState(state);
  }
}
