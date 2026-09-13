
enum ScheduleSlotStatus {
  open,
  booked,
  blocked,
}

class ScheduleSlot {
  final String id;
  final DateTime dateTime;
  final ScheduleSlotStatus status;
  final String? sessionId;

  const ScheduleSlot({
    required this.id,
    required this.dateTime,
    required this.status,
    this.sessionId,
  });

  ScheduleSlot copyWith({
    DateTime? dateTime,
    ScheduleSlotStatus? status,
    Object? sessionId = _keepSessionId,
  }) {
    return ScheduleSlot(
      id: id,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      sessionId: sessionId == _keepSessionId
          ? this.sessionId
          : sessionId as String?,
    );
  }
}

const _keepSessionId = Object();
