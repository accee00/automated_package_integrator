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
    Emitter<PickProjectState> emit,
  ) async {
    // Validate inputs
    if (event.apiKey.isEmpty) {
      emit(state.copyWith(
        status: ProjectValidationStatus.error,
        message: ErrorText.emptyApiKey,
        isError: true,
      ));
      return;
    }

    if (state.path == null || state.path!.isEmpty) {
      emit(state.copyWith(
        status: ProjectValidationStatus.error,
        message: ErrorText.pathNotFound,
        isError: true,
      ));
      return;
    }

    try {
      // Platform-specific injection with individual error handling
      bool androidSuccess = true, iosSuccess = true;

      try {
        await ApiKeyInjector.injectAndroidKey(state.path!, event.apiKey);
      } catch (e) {
        androidSuccess = false;
        debugPrint('Android injection failed: $e');
      }

      try {
        await ApiKeyInjector.injectIosKey(state.path!, event.apiKey);
      } catch (e) {
        iosSuccess = false;
        debugPrint('iOS injection failed: $e');
      }

      // Handle partial/full failures
      if (!androidSuccess && !iosSuccess) {
        emit(state.copyWith(
          status: ProjectValidationStatus.error,
          message: ErrorText.apiKeyInjectionFailed,
          isError: true,
        ));
      } else if (!androidSuccess) {
        emit(state.copyWith(
          status: ProjectValidationStatus.error,
          message: ErrorText.androidInjectionFailed,
          isError: true,
        ));
      } else if (!iosSuccess) {
        emit(state.copyWith(
          status: ProjectValidationStatus.error,
          message: ErrorText.iosInjectionFailed,
          isError: true,
        ));
      } else {
        emit(state.copyWith(
          status: ProjectValidationStatus.apiKeySuccess,
          message: SuccessText.apiKeySetSuccess,
          isError: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProjectValidationStatus.error,
        message: '${ErrorText.apiKeyInjectionFailed}: ${e.toString()}',
        isError: true,
      ));
    }
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
        message: SuccessText.projectSelected,
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
