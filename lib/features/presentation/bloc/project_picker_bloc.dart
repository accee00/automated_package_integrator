import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/enums.dart';
import '../../service/package_editor.dart';

part 'project_picker_event.dart';
part 'project_picker_state.dart';

class ProjectPickerBloc extends Bloc<ProjectPickerEvent, PickProjectState> {
  ProjectPickerBloc() : super(PickProjectState()) {
    on<SelectProjectDirectory>(_selectProjectDirectory);
  }

  Future<void> _selectProjectDirectory(
    ProjectPickerEvent event,
    Emitter<PickProjectState> emit,
  ) async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      final isFlutterProject = File('$result/pubspec.yaml').existsSync();
      if (!isFlutterProject) {
        emit(state.copyWith(
          path: result,
          status: ProjectValidationStatus.invalid,
          message: "This is not a valid Flutter project.",
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
            message: "Package added and pub get succeeded.",
            isError: false,
            status: ProjectValidationStatus.success,
          ));
        } else {
          emit(state.copyWith(
            message: "flutter pub get failed.",
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
