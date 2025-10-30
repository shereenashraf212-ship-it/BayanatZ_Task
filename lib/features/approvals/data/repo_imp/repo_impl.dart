import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repo.dart';
import '../model/employee_model.dart';

class RequestRepositoryImpl implements RequestRepository {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'Request_Data';

  RequestRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> uploadRequests(List<RequestModel> requests) async {
    try {
      final batch = _firestore.batch();

      for (var request in requests) {
        final docRef = _firestore.collection(_collectionName).doc();
        batch.set(docRef, request.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to upload requests: $e');
    }
  }

  @override
  Future<List<RequestModel>> getRequests() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('requestDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RequestModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get requests: $e');
    }
  }

  @override
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(requestId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      await _firestore.collection(_collectionName).doc(requestId).delete();
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }
}