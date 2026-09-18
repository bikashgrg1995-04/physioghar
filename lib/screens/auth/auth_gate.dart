import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_loading.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/data/providers/auth_provider.dart';
import 'package:physioghar/models/auth_result.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({
    super.key,
  });

  void _handleAuthStatus(
    BuildContext context,
    AuthStatus status,
  ) {
    if (!context.mounted) {
      return;
    }

    switch (status) {
      case AuthStatus.authenticated:
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.navigation,
          (route) => false,
        );
        break;

      case AuthStatus.unauthenticated:
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.login,
          (route) => false,
        );
        break;

      case AuthStatus.sessionExpired:
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.login,
          (route) => false,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppSnackBar.showInfo(
            AppStrings.sessionExpired,
          );
        });
        break;
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen<AsyncValue<AuthStatus>>(
      authProvider,
      (previous, next) {
        next.whenData((status) {
          _handleAuthStatus(
            context,
            status,
          );
        });
      },
    );

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: authState.when(
        loading: () => const AppLoading(),
        error: (error, stackTrace) {
          return const AppLoading();
        },
        data: (_) => const AppLoading(),
      ),
    );
  }
}