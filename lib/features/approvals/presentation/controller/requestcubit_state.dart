
// ==================== requestcubit_state.dart ====================
part of 'requestcubit_cubit.dart';

@immutable
sealed class RequestcubitState {}

final class RequestcubitInitial extends RequestcubitState {}

final class RequestcubitLoading extends RequestcubitState {}

final class RequestcubitLoaded extends RequestcubitState {
  final List<RequestModel> requests;

  RequestcubitLoaded(this.requests);
}

final class RequestcubitUploading extends RequestcubitState {}

final class RequestcubitUploadSuccess extends RequestcubitState {
  final String message;

  RequestcubitUploadSuccess(this.message);
}

final class RequestcubitError extends RequestcubitState {
  final String message;

  RequestcubitError(this.message);
}

final class RequestcubitStatusUpdated extends RequestcubitState {
  final String message;

  RequestcubitStatusUpdated(this.message);
}