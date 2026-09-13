import 'package:flutter/material.dart';
import '../../../core/utils/m_validators.dart';

/// Form component used in AddEmailDialog.
class AddEmailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback? onSubmit;

  const AddEmailForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.isSubmitting,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onSubmit != null ? (_) => onSubmit!() : null,
            autofocus: true,
            autocorrect: false,
            enabled: !isSubmitting,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'e.g. alex or alex@gmail.com',
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
