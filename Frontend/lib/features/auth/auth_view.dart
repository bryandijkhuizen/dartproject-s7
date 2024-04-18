import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:form_validator/form_validator.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SupaEmailAuth(
                onSignInComplete: (response) {},
                onSignUpComplete: (response) {},
                metadataFields: [
                  MetaDataField(
                    label: 'First name',
                    key: 'first_name',
                    prefixIcon: const Icon(Icons.assignment_ind),
                    validator: ValidationBuilder(
                            requiredMessage: 'Please fill in your first name')
                        .maxLength(128, 'Last name is too long')
                        .build(),
                  ),
                  MetaDataField(
                    label: 'Last name',
                    key: 'last_name',
                    prefixIcon: const Icon(Icons.assignment_ind),
                    validator: ValidationBuilder(
                            requiredMessage: 'Please fill in your last name')
                        .maxLength(128, 'Last name is too long')
                        .build(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
