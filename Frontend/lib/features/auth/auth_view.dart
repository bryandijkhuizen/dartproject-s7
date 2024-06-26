import 'package:darts_application/extensions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:form_validator/form_validator.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Color getColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered)) {
        return theme.colorScheme.primary.withOpacity(0.4);
      }

      return theme.colorScheme.primary;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                0,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dartin Molema',
                      style: theme.textTheme.displaySmall,
                    ),
                    Text(
                      'Sign in to become a pro',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SupaSocialsAuth(
                      redirectUrl: 'dartinmolema://login-callback',
                      colored: false,
                      socialProviders: const [
                        OAuthProvider.google,
                      ],
                      onSuccess: (response) {},
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Theme(
                      data: theme.copyWith(
                        elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith(getColor),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            splashFactory: InkSplash.splashFactory,
                          ),
                        ),
                      ),
                      child: SupaEmailAuth(
                        redirectTo: 'dartinmolema://',
                        onSignInComplete: (response) {
                          // app_router will handle redirecting the user inside the app
                        },
                        onSignUpComplete: (response) {
                          // app_router will handle redirecting the user inside the app
                        },
                        onPasswordResetEmailSent: () {
                          if (context.mounted) {
                            context.ShowSnackbar(
                              const SnackBar(
                                content: Text(
                                    'Press the link in your email to reset your password.'),
                              ),
                            );
                          }
                        },
                        metadataFields: [
                          MetaDataField(
                            label: 'First name',
                            key: 'first_name',
                            prefixIcon: const Icon(Icons.assignment_ind),
                            validator: ValidationBuilder(
                                    requiredMessage:
                                        'Please fill in your first name')
                                .maxLength(128, 'Last name is too long')
                                .build(),
                          ),
                          MetaDataField(
                            label: 'Last name',
                            key: 'last_name',
                            prefixIcon: const Icon(Icons.assignment_ind),
                            validator: ValidationBuilder(
                                    requiredMessage:
                                        'Please fill in your last name')
                                .maxLength(128, 'Last name is too long')
                                .build(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
