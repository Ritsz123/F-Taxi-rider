import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc() : super(TripInitial());

  @override
  Stream<TripState> mapEventToState(
    TripEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
