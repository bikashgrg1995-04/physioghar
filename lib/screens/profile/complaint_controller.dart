import 'package:flutter/material.dart';

import 'package:physioghar/data/repositories/complaint_repository.dart';
import 'package:physioghar/models/complaint.dart';

class ComplaintController {
  ComplaintController({ComplaintRepository? complaintRepository})
    : _complaintRepository = complaintRepository ?? ComplaintRepository();

  final ComplaintRepository _complaintRepository;

  final ValueNotifier<List<Complaint>> complaints =
      ValueNotifier<List<Complaint>>([]);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> loadComplaints() async {
    isLoading.value = true;
    _errorMessage = null;

    try {
      complaints.value = await _complaintRepository.getComplaints();
    } catch (e) {
      _errorMessage = 'Failed to load complaints.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Complaint?> createComplaint({
    required String category,
    required String subject,
    required String description,
  }) async {
    isSubmitting.value = true;
    _errorMessage = null;

    try {
      final complaint = await _complaintRepository.createComplaint(
        category: category,
        subject: subject,
        description: description,
      );

      complaints.value = [
        complaint,
        ...complaints.value,
      ];

      return complaint;
    } catch (e) {
      _errorMessage = 'Failed to submit complaint.';
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<Complaint?> updateComplaint({
    required int id,
    required String category,
    required String subject,
    required String description,
  }) async {
    isSubmitting.value = true;
    _errorMessage = null;

    try {
      final updatedComplaint =
          await _complaintRepository.updateComplaint(
        id: id,
        category: category,
        subject: subject,
        description: description,
      );

      complaints.value = complaints.value.map((complaint) {
        return complaint.id == id
            ? updatedComplaint
            : complaint;
      }).toList();

      return updatedComplaint;
    } catch (e) {
      _errorMessage = 'Failed to update complaint.';
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteComplaint(int id) async {
    _errorMessage = null;

    try {
      await _complaintRepository.deleteComplaint(id);

      complaints.value = complaints.value
          .where((complaint) => complaint.id != id)
          .toList();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete complaint.';
      return false;
    }
  }

  void dispose() {
    complaints.dispose();
    isLoading.dispose();
    isSubmitting.dispose();
  }
}

final complaintController = ComplaintController();