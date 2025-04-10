import 'dart:io';
import 'package:automated_package_integrator/constants/app_text.dart';
import 'package:automated_package_integrator/features/select_project/service/api_key_injector.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/enums.dart';
import '../../service/package_editor.dart';

part 'project_picker_event.dart';
part 'project_picker_state.dart';

class ProjectPickerBloc extends Bloc<ProjectPickerEvent, PickProjectState> {
  ProjectPickerBloc() : super(PickProjectState()) {
    on<SelectProjectDirectory>(_selectProjectDirectory);
    on<ApiKeyEnteredEvent>(_apiKeyEntered);
  }


  Future<void> _apiKeyEntered(
    ApiKeyEnteredEvent event,
    Emitter<ProjectPickerState> emit,
  ) async {
    if (state.path == null) {
      emit(state.copyWith(
        path: '',
        status: ProjectValidationStatus.error,
        message: "Path not found",
        isError: true,
      ));
      return;
    }
    // Inject API key for both platforms
    await ApiKeyInjector.injectAndroidKey(state.path!, event.apiKey);
    await ApiKeyInjector.injectIosKey(state.path!, event.apiKey);
    // Emit success state
    emit(state.copyWith(
      status: ProjectValidationStatus.apiKeySuccess,
      message: SuccessText.apiKeySetSuccess,
      isError: false,
    ));
  }

  Future<void> _selectProjectDirectory(
    ProjectPickerEvent event,
    Emitter<ProjectPickerState> emit,
  ) async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      final isFlutterProject = File('$result/pubspec.yaml').existsSync();
      if (!isFlutterProject) {
        emit(state.copyWith(
          path: result,
          status: ProjectValidationStatus.invalid,
          message: ErrorText.notValid,
          isError: true,
        ));
        return;
      }

      emit(state.copyWith(
        path: result,
        status: ProjectValidationStatus.valid,
        message: "Project selected.",
        isError: false,
      ));

      try {
        await PackageEditor.addGoogleMapsFlutter(result);

        final process = await Process.start(
          'flutter',
          ['pub', 'get'],
          workingDirectory: result,
          runInShell: true,
        );

        final exitCode = await process.exitCode;

        if (exitCode != 0) {
          emit(state.copyWith(
            message: SuccessText.addPackagaeSuccess,
            isError: false,
            status: ProjectValidationStatus.success,
          ));
        } else {
          emit(state.copyWith(
            message: ErrorText.pubGetFailed,
            isError: true,
            status: ProjectValidationStatus.error,
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          message: e.toString(),
          isError: true,
          status: ProjectValidationStatus.error,
        ));
      }
    }
  }
}
