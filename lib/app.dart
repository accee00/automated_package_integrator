import 'dart:io';

import 'package:automated_package_integrator/constants/app_theme.dart';
import 'package:automated_package_integrator/features/select_project/presentation/view/map_screen.dart';
import 'package:automated_package_integrator/features/select_project/presentation/view/project_picker_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Platform.isMacOS ? const ProjectPickerScreen() : const MapScreen(),
    );
  }
}
