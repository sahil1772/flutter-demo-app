import 'dart:async';

enum LoanState { initial, loading, loaded, error }

class LoanEvent {}

class SubmitLoanApplication extends LoanEvent {
  final double amount;
  final int tenure;
  SubmitLoanApplication(this.amount, this.tenure);
}

class LoanBloc {
  LoanState _state = LoanState.initial;
  final _stateController = StreamController<LoanState>.broadcast();
  Stream<LoanState> get stateStream => _stateController.stream;
  LoanState get state => _state;
  bool _isClosed = false;

  void add(LoanEvent event) {
    if (event is SubmitLoanApplication) {
      _handleSubmit(event);
    }
  }

  void _handleSubmit(SubmitLoanApplication event) {
    _state = LoanState.loading;
    _stateController.add(_state);

    Future.delayed(const Duration(seconds: 2), () {
      _state = LoanState.loaded;
      _stateController.add(_state);
    });
  }

  void close() {
    _isClosed = true;
    _stateController.close();
  }
}
