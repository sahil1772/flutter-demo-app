import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddressEvent {}

class CitySelected extends AddressEvent {
  final String city;
  CitySelected(this.city);
}

class AddressState {
  final String? city;
  AddressState({this.city});

  AddressState copyWith({String? city}) {
    return AddressState(city: city ?? this.city);
  }
}

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressState()) {
    on<CitySelected>((event, emit) {
      // BUG TKT-008: Missing emit statement
      // Should be: emit(state.copyWith(city: event.city));
    });
  }
}
