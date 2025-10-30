import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String? id;
  final String requestedBy;
  final String jobTitle;
  final String department;
  final DateTime requestDate;
  final double totalTime;
  final String requestedTimeframe;
  final String status;

  RequestModel({
    this.id,
    required this.requestedBy,
    required this.jobTitle,
    required this.department,
    required this.requestDate,
    required this.totalTime,
    required this.requestedTimeframe,
    required this.status,
  });

  // Convert Request to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'requestedBy': requestedBy,
      'jobTitle': jobTitle,
      'department': department,
      'requestDate': Timestamp.fromDate(requestDate),
      'totalTime': totalTime,
      'requestedTimeframe': requestedTimeframe,
      'status': status,
    };
  }

  // Create Request from Firebase document
  factory RequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RequestModel(
      id: documentId,
      requestedBy: map['requestedBy'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      department: map['department'] ?? '',
      requestDate: (map['requestDate'] as Timestamp).toDate(),
      totalTime: (map['totalTime'] ?? 0).toDouble(),
      requestedTimeframe: map['requestedTimeframe'] ?? '',
      status: map['status'] ?? '',
    );
  }

  // Create Request from Firestore DocumentSnapshot
  factory RequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return RequestModel.fromMap(data, snapshot.id);
  }

  // CopyWith method for easy updates
  RequestModel copyWith({
    String? id,
    String? requestedBy,
    String? jobTitle,
    String? department,
    DateTime? requestDate,
    double? totalTime,
    String? requestedTimeframe,
    String? status,
  }) {
    return RequestModel(
      id: id ?? this.id,
      requestedBy: requestedBy ?? this.requestedBy,
      jobTitle: jobTitle ?? this.jobTitle,
      department: department ?? this.department,
      requestDate: requestDate ?? this.requestDate,
      totalTime: totalTime ?? this.totalTime,
      status: status ?? this.status,
      requestedTimeframe: requestedTimeframe ?? this.requestedTimeframe,
    );
  }
}