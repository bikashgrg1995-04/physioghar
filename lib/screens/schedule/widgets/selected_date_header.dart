import 'package:flutter/material.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';

class SelectedDateHeader extends StatelessWidget {
  final DateTime date;

  const SelectedDateHeader({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeUtils.formatFullDate(date),
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}