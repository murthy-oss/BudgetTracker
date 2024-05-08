import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LogOutEvent>(logOutState);
  }

  FutureOr<void> logOutState(LogOutEvent event, Emitter<HomeState> emit) {
    print("logout ra");
    emit(LogOutState());
  }
}
