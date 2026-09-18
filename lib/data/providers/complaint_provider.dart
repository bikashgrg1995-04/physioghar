import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/data/repositories/complaint_repository.dart';
import 'package:physioghar/models/complaint.dart';

final complaintProvider =
    NotifierProvider<ComplaintNotifier, ComplaintState>(
  ComplaintNotifier.new,
);

class ComplaintState {
  const ComplaintState({
    this.complaints = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final List<Complaint> complaints;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;

  ComplaintState copyWith({
    List<Complaint>? complaints,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ComplaintState(
      complaints: complaints ?? this.complaints,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class ComplaintNotifier extends Notifier<ComplaintState> {
  late final ComplaintRepository _complaintRepository;

  @override
  ComplaintState build() {
    _complaintRepository = ComplaintRepository();

    return const ComplaintState();
  }

  Future<void> loadComplaints() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final complaints =
          await _complaintRepository.getComplaints();

      state = state.copyWith(
        complaints: complaints,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      debugPrint('Failed to load complaints: $error');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load complaints.',
      );
    }
  }

  Future<Complaint?> createComplaint({
    required String category,
    required String subject,
    required String description,
  }) async {
    if (state.isSubmitting) return null;

    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
    );

    try {
      final complaint =
          await _complaintRepository.createComplaint(
        category: category,
        subject: subject,
        description: description,
      );

      state = state.copyWith(
        complaints: [
          complaint,
          ...state.complaints,
        ],
        isSubmitting: false,
        clearError: true,
      );

      return complaint;
    } catch (error) {
      debugPrint('Failed to submit complaint: $error');

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to submit complaint.',
      );

      return null;
    }
  }

  Future<Complaint?> updateComplaint({
    required int id,
    required String category,
    required String subject,
    required String description,
  }) async {
    if (state.isSubmitting) return null;

    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
    );

    try {
      final updatedComplaint =
          await _complaintRepository.updateComplaint(
        id: id,
        category: category,
        subject: subject,
        description: description,
      );

      final updatedComplaints =
          state.complaints.map((complaint) {
        return complaint.id == id
            ? updatedComplaint
            : complaint;
      }).toList();

      state = state.copyWith(
        complaints: updatedComplaints,
        isSubmitting: false,
        clearError: true,
      );

      return updatedComplaint;
    } catch (error) {
      debugPrint('Failed to update complaint: $error');

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to update complaint.',
      );

      return null;
    }
  }

  Future<bool> deleteComplaint(int id) async {
    state = state.copyWith(clearError: true);

    try {
      await _complaintRepository.deleteComplaint(id);

      final updatedComplaints =
          state.complaints
              .where((complaint) => complaint.id != id)
              .toList();

      state = state.copyWith(
        complaints: updatedComplaints,
        clearError: true,
      );

      return true;
    } catch (error) {
      debugPrint('Failed to delete complaint: $error');

      state = state.copyWith(
        errorMessage: 'Failed to delete complaint.',
      );

      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}