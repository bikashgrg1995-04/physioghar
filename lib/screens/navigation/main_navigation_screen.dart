import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/data/providers/main_navigation_provider.dart';
import 'package:physioghar/screens/dashboard/dashboard_screen.dart';
import 'package:physioghar/screens/patients/patients_screen.dart';
import 'package:physioghar/screens/profile/profile_screen.dart';
import 'package:physioghar/screens/schedule/schedule_screen.dart';
import 'package:physioghar/screens/sessions/sessions_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({
    super.key,
  });

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends ConsumerState<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref
          .read(navigationIndexProvider.notifier)
          .resetToHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(
      navigationIndexProvider,
    );

    const screens = [
      DashboardScreen(),
      ScheduleScreen(),
      SessionsScreen(),
      PatientsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref
              .read(navigationIndexProvider.notifier)
              .setIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}