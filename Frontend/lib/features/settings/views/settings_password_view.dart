import 'package:darts_application/components/form_field_label.dart';
import 'package:darts_application/components/form_save_button.dart';
import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/extensions.dart';
import 'package:darts_application/features/app_router/app_router_extensions.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPasswordView extends StatefulWidget {
  const SettingsPasswordView({super.key});

  @override
  State<SettingsPasswordView> createState() => _SettingsPasswordViewState();
}

class _SettingsPasswordViewState extends State<SettingsPasswordView> {
  bool loading = false;
  User user = Supabase.instance.client.auth.currentUser!;
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  String? Function(String?)? passwordValidator =
      ValidationBuilder(requiredMessage: 'Please enter your first name')
          .minLength(2, 'Your first name must be a minimum of 2 characters')
          .build();

  String? Function(String?)? repeatPasswordValidator =
      ValidationBuilder(requiredMessage: 'Please enter your last name')
          .minLength(2, 'Your last name must be a minimum of 2 characters')
          .build();

  InputDecoration createInputDecoration(String label, String hintText) =>
      InputDecoration(
        label: Text(label),
        hintText: hintText,
      );

  void submit() async {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState?.validate() == true) {
      try {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(
            password: newPasswordController.text,
          ),
        );

        if (mounted) {
          context.goBack('/settings');
          context.ShowSnackbar(
            const SnackBar(
              content: Text('Succesfully changed your password!'),
            ),
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          context.goBack('/settings');
          context.ShowSnackbar(
            SnackBar(
              content: Text(e.message),
            ),
          );
        }
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Change your Password'),
      ),
      body: GenericScreen(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FormFieldLabel(label: 'New password'),
                      TextFormField(
                        controller: newPasswordController,
                        decoration: createInputDecoration(
                          'New password',
                          '',
                        ),
                        obscureText: true,
                        validator: passwordValidator,
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      const FormFieldLabel(
                        label: 'Last name',
                      ),
                      TextFormField(
                        controller: repeatPasswordController,
                        decoration:
                            createInputDecoration('Repeat password', ''),
                        obscureText: true,
                        validator: repeatPasswordValidator,
                      ),
                    ],
                  ),
                )),
            const Spacer(),
            FormSaveButton(
              loading: loading,
              onCancel: () {
                context.goBack('/settings');
              },
              onSave: submit,
            ),
          ],
        ),
      ),
    );
  }
}
