import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/injection/injection_container.dart';
import 'reports/data/repositories/report_repository.dart';
import 'reports/presentation/bloc/report_bloc.dart';
import 'reports/presentation/pages/reports_page.dart';
import 'branches/data/repositories/branch_repository.dart';
import 'branches/presentation/bloc/branch_bloc.dart';
import 'branches/presentation/pages/branch_management_page.dart';
import 'users/data/repositories/user_repository.dart';
import 'users/presentation/bloc/user_bloc.dart';
import 'users/presentation/pages/user_management_page.dart';
import 'shared/widgets/admin_bottom_navigation.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ReportsPage(),
    const BranchManagementPage(),
    const UserManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReportBloc(sl<ReportRepository>()),
        ),
        BlocProvider(
          create: (context) => BranchBloc(sl<BranchRepository>()),
        ),
        BlocProvider(
          create: (context) => UserBloc(sl<UserRepository>()),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: AdminBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}