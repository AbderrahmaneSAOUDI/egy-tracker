import 'package:flutter/material.dart';
import '../../../core/utils/m_validators.dart';

/// Form component used in AddEmailDialog.
class AddEmailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isSubmitting;

  const AddEmailForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grant a travel partner access to this Egypt expense tracker with their Google account.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            autocorrect: false,
            enabled: !isSubmitting,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'partner or partner@gmail.com',
              helperText: 'Domain @gmail.com is added automatically if omitted',
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            validator: (value) => Validators.validateEmail(
              value,
              allowUsernameOnly: true,
            ),
          ),
        ],
      ),
    );
  }
}
