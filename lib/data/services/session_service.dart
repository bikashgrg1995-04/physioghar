import 'package:dio/dio.dart';
import 'package:physioghar/core/network/api_client.dart';
import 'package:physioghar/core/network/api_endpoints.dart';

import 'package:physioghar/models/session.dart';

class SessionService {
  SessionService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<Session>> getSessions({
    SessionStatus? status,
    int? patientId,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (status != null) {
      queryParameters['status'] = status.value;
    }
    if (patientId != null) {
      queryParameters['patient'] = patientId;
    }
    final response = await _dio.get(
      ApiEndpoints.sessions,
      queryParameters: queryParameters,
    );

    final data = response.data;

    if (data is! List) {
      throw const FormatException('Invalid sessions response.');
    }

    return data
        .map((item) => Session.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Session> getSession(int sessionId) async {
    final response = await _dio.get('${ApiEndpoints.sessions}$sessionId/');

    return Session.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<Session> createSession({
    required int patientId,
    required int scheduleSlotId,
    required String treatment,
    required String location,
    String? notes,
  }) async {
    final data = <String, dynamic>{
      'patient': patientId,
      'schedule_slot': scheduleSlotId,
      'treatment': treatment,
      'location': location,
    };

    if (notes != null && notes.trim().isNotEmpty) {
      data['notes'] = notes.trim();
    }

    final response = await _dio.post(ApiEndpoints.sessions, data: data);

    return Session.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<Session> acceptSession(int sessionId) async {
    return _performAction(sessionId, 'accept');
  }

  Future<Session> declineSession({
    required int sessionId,
    required String cancellationReason,
  }) async {
    return _performAction(
      sessionId,
      'decline',
      data: {'cancellation_reason': cancellationReason},
    );
  }

  Future<Session> rescheduleSession({
    required int sessionId,
    required int scheduleSlotId,
  }) async {
    return _performAction(
      sessionId,
      'reschedule',
      data: {'schedule_slot': scheduleSlotId},
    );
  }

  Future<Session> completeSession({
    required int sessionId,
    required String notes,
  }) async {
    return _performAction(sessionId, 'complete', data: {'notes': notes});
  }

  Future<Session> cancelSession({
    required int sessionId,
    required String cancellationReason,
  }) async {
    return _performAction(
      sessionId,
      'cancel',
      data: {'cancellation_reason': cancellationReason},
    );
  }

  Future<Session> _performAction(
    int sessionId,
    String action, {
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.post(
      '${ApiEndpoints.sessions}'
      '$sessionId/$action/',
      data: data,
    );

    return Session.fromJson(Map<String, dynamic>.from(response.data as Map));
  }
}
