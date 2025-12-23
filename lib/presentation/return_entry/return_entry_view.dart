// lib/presentation/return_entry/return_entry_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ✨ படி 1: மொழிபெயர்ப்பு கோப்பை import செய்யவும்
import '../../core/utils/app_localizations.dart';
import '../../data/models/collection_model.dart';
import 'return_entry_viewmodel.dart';

class ReturnEntryScreen extends ConsumerStatefulWidget {
  final CollectionModel? initialData;
  const ReturnEntryScreen({super.key, this.initialData});

  @override
  ConsumerState<ReturnEntryScreen> createState() => _ReturnEntryScreenState();
}

class _ReturnEntryScreenState extends ConsumerState<ReturnEntryScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(returnEntryViewModelProvider).preFillData(widget.initialData!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(returnEntryViewModelProvider);
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // ✨ படி 2: மொழிபெயர்ப்பு instance-ஐப் பெறவும்
    final lang = AppLocalizations.of(context);

    ref.listen<AsyncValue<void>>(returnEntryStateProvider, (_, state) {
      if (state.isLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      } else if (state.hasError) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save return entry: ${state.error}')),
        );
      } else if (state.hasValue && !state.isLoading) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Return entry saved successfully!')),
        );
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
        title: Text(lang.addReturnTitle),
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // City Field
            _buildCombinedInputField(
              context: context,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              label: lang.city,
              initialController: viewModel.cityIniController,
              mainController: viewModel.cityController,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              initialHint: lang.cityInitial,
              focusedColor: colorScheme.secondary,
            ),
            const SizedBox(height: 20),

            // Name Field
            _buildCombinedInputField(
              context: context,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              label: lang.name,
              initialController: viewModel.initialController,
              mainController: viewModel.nameController,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              initialHint: lang.initial,
              focusedColor: colorScheme.secondary,
            ),
            const SizedBox(height: 20),

            // Spouse Name Field
            _buildSingleInputField(
              context: context,
              controller: viewModel.spouseController,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              label: lang.spouseName,
              icon: Icons.family_restroom_outlined,
              focusedColor: colorScheme.secondary,
            ),
            const SizedBox(height: 20),

            // Education Field
            _buildSingleInputField(
              context: context,
              controller: viewModel.educationController,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              label: lang.education,
              icon: Icons.school_outlined,
              focusedColor: colorScheme.secondary,
            ),
            const SizedBox(height: 20),

            // Occupation Field
            _buildSingleInputField(
              context: context,
              controller: viewModel.workController,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              label: lang.occupation,
              icon: Icons.work_outline,
              focusedColor: colorScheme.secondary,
            ),
            const SizedBox(height: 20),

            // Amount Field
            _buildSingleInputField(
              context: context,
              controller: viewModel.amountController,
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
              label: lang.amount,
              icon: Icons.currency_rupee,
              keyboardType: TextInputType.number,
              focusedColor: colorScheme.secondary,
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  viewModel.createReturnEntry();
                }
              },
              icon: Icon(Icons.keyboard_return, color: colorScheme.onSecondary),
              label: Text(
                // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                lang.saveReturn.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSecondary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: colorScheme.secondary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // இந்த helper முறைகள் அப்படியே இருக்கும், ஆனால் context-ஐப் பெறும்
  Widget _buildCombinedInputField({
    required BuildContext context,
    required String label,
    required TextEditingController initialController,
    required TextEditingController mainController,
    required String initialHint,
    required Color focusedColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onBackground),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: TextFormField(
                controller: initialController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  hintText: initialHint,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: focusedColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (label == AppLocalizations.of(context).name && (value == null || value.isEmpty)) {
                    return 'Req';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: mainController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  hintText: 'Enter ${label.toLowerCase()}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: focusedColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Color focusedColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onBackground),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: colorScheme.onSurface.withOpacity(0.6)),
            filled: true,
            fillColor: colorScheme.surface,
            hintText: 'Enter ${label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: focusedColor, width: 2),
            ),
          ),
          validator: (value) {
            if (label == AppLocalizations.of(context).amount && (value == null || value.isEmpty)) {
              return 'Please enter amount';
            }
            return null;
          },
        ),
      ],
    );
  }
}
