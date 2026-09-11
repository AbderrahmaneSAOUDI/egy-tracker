import 'package:flutter/material.dart';
import '../../../core/theme/t_app_theme.dart';
import 'c_initial_balance_input_field.dart';

/// Form holding the USD and EGP starting balance fields.
class EditInitialBalancesForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usdController;
  final TextEditingController egpController;
  final bool isSubmitting;
  final bool isDark;
  final ColorScheme colorScheme;

  const EditInitialBalancesForm({
    super.key,
    required this.formKey,
    required this.usdController,
    required this.egpController,
    required this.isSubmitting,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Starting physical cash before trip expenses begin. USD and EGP are kept strictly independent.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
          ),
          const SizedBox(height: 20),
          InitialBalanceInputField(
            controller: usdController,
            label: 'Starting USD (\$)',
            symbol: '\$',
            colorLight: AppTheme.usdColorLight,
            colorDark: AppTheme.usdColorDark,
            isSubmitting: isSubmitting,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          InitialBalanceInputField(
            controller: egpController,
            label: 'Starting EGP (EGP)',
            symbol: 'EGP',
            colorLight: AppTheme.egpColorLight,
            colorDark: AppTheme.egpColorDark,
            isSubmitting: isSubmitting,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
