import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/employee_model.dart';
import '../../domain/repo.dart';

part 'requestcubit_state.dart';

class RequestCubit extends Cubit<RequestcubitState> {
  final RequestRepository _repository;

  RequestCubit(this._repository) : super(RequestcubitInitial());

  // Get all requests
  Future<void> getRequests() async {
    emit(RequestcubitLoading());

    try {
      final requests = await _repository.getRequests();

      // Print each request for debugging
      for (var i = 0; i < requests.length; i++) {
        print('   Request $i: ${requests[i].requestedBy} - ${requests[i].status}');
      }

      emit(RequestcubitLoaded(requests));
    } catch (e) {
      emit(RequestcubitError(e.toString()));
    }
  }

  // Update request status
  Future<void> updateStatus(String requestId, String status) async {
    try {
      await _repository.updateRequestStatus(requestId, status);
      emit(RequestcubitStatusUpdated('Status updated successfully'));

      // Reload requests after update
      await getRequests();
    } catch (e) {
      emit(RequestcubitError(e.toString()));
    }
  }

  // Delete request
  Future<void> deleteRequest(String requestId) async {
    try {
      await _repository.deleteRequest(requestId);
      emit(RequestcubitStatusUpdated('Request deleted successfully'));

      // Reload requests after deletion
      await getRequests();
    } catch (e) {
      emit(RequestcubitError(e.toString()));
    }
  }

// REMOVE OR COMMENT OUT THESE METHODS:
// uploadFiveRequests() and _generateFiveRequests()
}