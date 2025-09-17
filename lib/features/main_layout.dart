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

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  // Create BLoC instances once and reuse them
  late final ReportBloc _reportBloc;
  late final BranchBloc _branchBloc;
  late final UserBloc _userBloc;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize BLoCs once
    _reportBloc = ReportBloc(sl<ReportRepository>());
    _branchBloc = BranchBloc(sl<BranchRepository>());
    _userBloc = UserBloc(sl<UserRepository>());

    // Initialize pages after BLoCs are created
    _pages.addAll([
      const ReportsPage(),
      const BranchManagementPage(),
      const UserManagementPage(),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    // Dispose BLoCs
    _reportBloc.close();
    _branchBloc.close();
    _userBloc.close();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      
      // Add a subtle haptic feedback
      // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
      create: (context) => ReportBloc(sl<ReportRepository>()),
    ),
    BlocProvider.value(value: context.read<BranchBloc>()),
    BlocProvider.value(value: context.read<UserBloc>()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _pages.map((page) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: page,
              );
            }).toList(),
          ),
        ),
        bottomNavigationBar: AdminBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}