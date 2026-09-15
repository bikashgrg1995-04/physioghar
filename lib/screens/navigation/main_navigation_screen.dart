// import 'package:flutter/material.dart';

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({super.key});

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = const [
//     DashboardScreen(),
//     ScheduleScreen(),
//     SessionsScreen(),
//     PatientsScreen(),
//     ProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(index: _currentIndex, children: _screens),

//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _currentIndex,
//         onDestinationSelected: _onItemTapped,
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.calendar_month_outlined),
//             selectedIcon: Icon(Icons.calendar_month),
//             label: 'Schedule',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.event_note_outlined),
//             selectedIcon: Icon(Icons.event_note),
//             label: 'Sessions',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.people_outline),
//             selectedIcon: Icon(Icons.people),
//             label: 'Patients',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline),
//             selectedIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/screens/new/auth/auth_controller.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();

    _authController = AuthController();
  }

  @override
  void dispose() {
    _authController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      
      listenable: _authController.isLoading,
      builder: (context, _) {
        final isLoading = _authController.isLoading.value;

        return Scaffold(
          body: Center(
            child: AppButton(
              width: double.infinity,
              text: isLoading ? 'Logging out...' : 'Logout',
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.logout_rounded, size: 19),
              onPressed: isLoading ? null : () => _authController.logout(context),
            ),
          ),
        );
      },
    );
  }
}
