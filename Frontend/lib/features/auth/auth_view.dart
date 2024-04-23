import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:form_validator/form_validator.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Color getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
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
                      socialProviders: const [
                        OAuthProvider.google,
                        OAuthProvider.facebook,
                        OAuthProvider.twitter,
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
                                MaterialStateProperty.resolveWith(getColor),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            splashFactory: InkSplash.splashFactory,
                          ),
                        ),
                      ),
                      child: SupaEmailAuth(
                        onSignInComplete: (response) {
                          // app_router will handle redirecting the user inside the app
                        },
                        onSignUpComplete: (response) {
                          // app_router will handle redirecting the user inside the app
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
