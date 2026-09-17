import 'package:physioghar/data/services/complaint_service.dart';
import 'package:physioghar/models/complaint.dart';

class ComplaintRepository {
  ComplaintRepository({ComplaintService? complaintService})
    : _complaintService = complaintService ?? ComplaintService();

  final ComplaintService _complaintService;

  Future<List<Complaint>> getComplaints() async {
    final data = await _complaintService.getComplaints();

    return data.map<Complaint>(
      (item) => Complaint.fromJson(item),
    ).toList();
  }

  Future<Complaint> createComplaint({
    required String category,
    required String subject,
    required String description,
  }) async {
    final data = await _complaintService.createComplaint(
      category: category,
      subject: subject,
      description: description,
    );

    return Complaint.fromJson(data);
  }

  Future<Complaint> updateComplaint({
    required int id,
    required String category,
    required String subject,
    required String description,
  }) async {
    final data = await _complaintService.updateComplaint(
      id: id,
      category: category,
      subject: subject,
      description: description,
    );

    return Complaint.fromJson(data);
  }

  Future<void> deleteComplaint(int id) async {
    await _complaintService.deleteComplaint(id);
  }
}