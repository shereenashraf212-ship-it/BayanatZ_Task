import '../data/model/employee_model.dart';

abstract class RequestRepository {
  Future<void> uploadRequests(List<RequestModel> requests);
  Future<List<RequestModel>> getRequests();
  Future<void> updateRequestStatus(String requestId, String status);
  Future<void> deleteRequest(String requestId);
}
