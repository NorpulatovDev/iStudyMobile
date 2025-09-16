import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/report_model.dart';
import '../../data/repositories/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;

  ReportBloc(this._reportRepository) : super(ReportInitial()) {
    // Payment Reports
    on<LoadDailyPaymentReport>(_onLoadDailyPaymentReport);
    on<LoadMonthlyPaymentReport>(_onLoadMonthlyPaymentReport);
    on<LoadPaymentRangeReport>(_onLoadPaymentRangeReport);
    
    // Expense Reports
    on<LoadDailyExpenseReport>(_onLoadDailyExpenseReport);
    on<LoadMonthlyExpenseReport>(_onLoadMonthlyExpenseReport);
    on<LoadExpenseRangeReport>(_onLoadExpenseRangeReport);
    
    // Salary Reports
    on<LoadMonthlySalaryReport>(_onLoadMonthlySalaryReport);
    
    // Financial Summary
    on<LoadFinancialSummary>(_onLoadFinancialSummary);
    on<LoadFinancialSummaryRange>(_onLoadFinancialSummaryRange);
  }

  // Payment Report Handlers
  Future<void> _onLoadDailyPaymentReport(
    LoadDailyPaymentReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getDailyPaymentReport(
        event.branchId,
        event.date,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onLoadMonthlyPaymentReport(
    LoadMonthlyPaymentReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getMonthlyPaymentReport(
        event.branchId,
        event.year,
        event.month,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onLoadPaymentRangeReport(
    LoadPaymentRangeReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getPaymentRangeReport(
        event.branchId,
        event.startDate,
        event.endDate,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  // Expense Report Handlers
  Future<void> _onLoadDailyExpenseReport(
    LoadDailyExpenseReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getDailyExpenseReport(
        event.branchId,
        event.date,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onLoadMonthlyExpenseReport(
    LoadMonthlyExpenseReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getMonthlyExpenseReport(
        event.branchId,
        event.year,
        event.month,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onLoadExpenseRangeReport(
    LoadExpenseRangeReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getExpenseRangeReport(
        event.branchId,
        event.startDate,
        event.endDate,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  // Salary Report Handlers
  Future<void> _onLoadMonthlySalaryReport(
    LoadMonthlySalaryReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getMonthlySalaryReport(
        event.branchId,
        event.year,
        event.month,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  // Financial Summary Handlers
  Future<void> _onLoadFinancialSummary(
    LoadFinancialSummary event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getFinancialSummary(
        event.branchId,
        event.year,
        event.month,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onLoadFinancialSummaryRange(
    LoadFinancialSummaryRange event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _reportRepository.getFinancialSummaryRange(
        event.branchId,
        event.startDate,
        event.endDate,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}