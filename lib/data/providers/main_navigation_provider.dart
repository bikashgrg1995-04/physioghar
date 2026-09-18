import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider =
    NotifierProvider<NavigationIndexNotifier, int>(
  NavigationIndexNotifier.new,
);

class NavigationIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }

  void resetToHome() {
    state = 0;
  }
}