import 'package:automated_package_integrator/app.dart';
import 'package:automated_package_integrator/features/presentation/bloc/project_picker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProjectPickerBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
