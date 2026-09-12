import 'package:flutter/material.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text('Sessions', key: const Key('sessions-screen-title')),
    );
  }
}