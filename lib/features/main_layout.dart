import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/injection/injection_container.dart';
import 'reports/data/repositories/report_repository.dart';
import 'reports/presentation/bloc/report_bloc.dart';
import 'reports/presentation/pages/reports_page.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc(sl<ReportRepository>()),
      child: const ReportsPage(),
    );
  }
}