part of 'project_picker_bloc.dart';

@immutable
sealed class ProjectPickerState {}

class PickProjectState extends ProjectPickerState {
  final String? path;
  final ProjectValidationStatus status;
  final String? message;
  final bool isError;

  PickProjectState({
    this.path,
    this.status = ProjectValidationStatus.initial,
    this.message,
    this.isError = false,
  });

  PickProjectState copyWith({
    String? path,
    ProjectValidationStatus? status,
    String? message,
    bool? isError,
  }) {
    return PickProjectState(
      path: path ?? this.path,
      status: status ?? this.status,
      message: message,
      isError: isError ?? this.isError,
    );
  }
}

class ApiKeyEnteredState extends ProjectPickerState {}
