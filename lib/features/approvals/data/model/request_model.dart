
import 'package:cloud_firestore/cloud_firestore.dart';

/// Employee Model
class Employee {
  final String? id;
  final String name;
  final String department;
  final String jobTitle;

  Employee({
    this.id,
    required this.name,
    required this.department,
    required this.jobTitle,
  });

  // Convert Employee to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department,
      'jobTitle': jobTitle,
    };
  }

  // Create Employee from Firebase document
  factory Employee.fromMap(Map<String, dynamic> map, String documentId) {
    return Employee(
      id: documentId,
      name: map['name'] ?? '',
      department: map['department'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
    );
  }

  // Create Employee from Firestore DocumentSnapshot
  factory Employee.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Employee.fromMap(data, snapshot.id);
  }

  // CopyWith method for easy updates
  Employee copyWith({
    String? id,
    String? name,
    String? department,
    String? jobTitle,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      jobTitle: jobTitle ?? this.jobTitle,
    );
  }
}