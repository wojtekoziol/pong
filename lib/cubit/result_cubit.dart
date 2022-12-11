import 'package:bloc/bloc.dart';

class ResultState {
  ResultState(this.top, this.bottom);

  final int top;
  final int bottom;
}

class ResultCubit extends Cubit<ResultState> {
  ResultCubit() : super(ResultState(0, 0));

  void increment({bool top = false, bool bottom = false}) {
    if (top) emit(ResultState(state.top + 1, state.bottom));
    if (bottom) emit(ResultState(state.top, state.bottom + 1));
  }
}
