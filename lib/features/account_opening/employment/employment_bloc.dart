import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EmploymentEvent {}

class EmploymentSubmitted extends EmploymentEvent {
  final String employmentType;
  EmploymentSubmitted(this.employmentType);
}

abstract class EmploymentState {}

class EmploymentInitial extends EmploymentState {}

class EmploymentBloc extends Bloc<EmploymentEvent, EmploymentState> {
  EmploymentBloc() : super(EmploymentInitial());
}
