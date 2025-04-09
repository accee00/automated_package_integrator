import 'package:automated_package_integrator/constants/app_colors.dart';
import 'package:automated_package_integrator/constants/app_text.dart';
import 'package:automated_package_integrator/constants/app_text_style.dart';
import 'package:automated_package_integrator/core/custom_snackbar.dart';
import 'package:automated_package_integrator/features/select_project/presentation/bloc/project_picker_bloc.dart';
import 'package:automated_package_integrator/features/select_project/presentation/view/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automated_package_integrator/core/enums.dart';

class ProjectPickerScreen extends StatefulWidget {
  const ProjectPickerScreen({super.key});

  @override
  State<ProjectPickerScreen> createState() => _ProjectPickerScreenState();
}

class _ProjectPickerScreenState extends State<ProjectPickerScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _showApiKeyDialog(BuildContext context, String path) async {
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backGroundColor,
        title: const Text(AppText.enterKey),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 1.6,
                blurRadius: 10,
                offset: const Offset(2, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Color(0xffF7F8F8),
              hintText: AppText.hintText,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text(AppText.skip),
          ),
          TextButton(
            onPressed: () => context.read<ProjectPickerBloc>().add(
                  ApiKeyEnteredEvent(
                    apiKey: controller.text.trim(),
                  ),
                ),
            child: const Text(AppText.submit),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocListener<ProjectPickerBloc, PickProjectState>(
        listener: (context, state) {
          if (state.message != null) {
            showCustomSnackBar(
              context: context,
              message: state.message!,
              type: state.isError ? SnackBarType.failure : SnackBarType.success,
            );
          }

          if (state.status == ProjectValidationStatus.valid) {
            _showApiKeyDialog(context, state.path!);
          }

          // Add navigation to MapScreen when API key is successfully set
          if (state.status == ProjectValidationStatus.apiKeySuccess) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MapScreen()),
            );
          }
        },
        child: BlocBuilder<ProjectPickerBloc, PickProjectState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Selected Path: ${state.path ?? 'None'}',
                    style: AppTextStyle.bodyTextStyle,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Status: ${state.status.name.toUpperCase()}',
                    style: TextStyle(
                      color: {
                        ProjectValidationStatus.valid: Colors.green,
                        ProjectValidationStatus.invalid: Colors.red,
                        ProjectValidationStatus.error: Colors.orange,
                        ProjectValidationStatus.initial: Colors.grey,
                        ProjectValidationStatus.success: Colors.blue,
                        ProjectValidationStatus.apiKeySuccess: Colors.purple,
                      }[state.status],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(221, 130, 241, 0.4),
                          spreadRadius: 3,
                          blurRadius: 9,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProjectPickerBloc>()
                            .add(SelectProjectDirectory());
                      },
                      child: const Text(
                        AppText.pickDirectory,
                        style: AppTextStyle.elevatedButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        AppText.appbar,
        style: AppTextStyle.appBarTextStyle,
      ),
    );
  }
}
