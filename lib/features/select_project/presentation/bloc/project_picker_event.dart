part of 'project_picker_bloc.dart';

@immutable
sealed class ProjectPickerEvent {}

class SelectProjectDirectory extends ProjectPickerEvent {}

class ApiKeyEnteredEvent extends ProjectPickerEvent {
  final String apiKey;
  ApiKeyEnteredEvent({required this.apiKey});
}
