import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:istudy/features/dashboard/data/models/dashboard_stats_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
