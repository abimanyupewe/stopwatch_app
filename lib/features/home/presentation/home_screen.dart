import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../stopwatch/presentation/stopwatch_screen.dart';
import '../../timer/presentation/timer_screen.dart';
import 'widgets/custom_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header / Tab Bar
            CustomTabBar(
              selectedIndex: _currentIndex,
              onTabSelected: _onTabSelected,
            ),
            const SizedBox(height: 20),
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const [StopwatchScreen(), TimerScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
