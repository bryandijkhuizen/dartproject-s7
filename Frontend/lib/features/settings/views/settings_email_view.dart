import 'package:darts_application/components/form_field_label.dart';
import 'package:darts_application/components/form_save_button.dart';
import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/extensions.dart';
import 'package:darts_application/features/app_router/app_router_extensions.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsEmailView extends StatefulWidget {
  const SettingsEmailView({super.key});

  @override
  State<SettingsEmailView> createState() => _SettingsEmailViewState();
}

class _SettingsEmailViewState extends State<SettingsEmailView> {
  bool loading = false;
  User user = Supabase.instance.client.auth.currentUser!;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();

  String? Function(String?)? emailValidator =
      ValidationBuilder(requiredMessage: 'Please enter your new email')
          .email('Invalid email address')
          .build();

  late String? Function(String?)? confirmEmailValidator =
      ValidationBuilder(requiredMessage: 'Please confirm your new email')
          .matches(() => emailController.text, 'Addresses dont match')
          .email('Invalid email address')
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
      _formKey.currentState!.save();
      try {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(
            email: emailController.text,
          ),
        );

        if (mounted) {
          context.goBack('/settings');
          context.ShowSnackbar(
            const SnackBar(
              content: Text('An email has been sent to you'),
            ),
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          context.goBack('/settings');
          context.ShowSnackbar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
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
        title: const Text('Change your Email'),
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
                      Text('Current email: ${user.email!}'),
                      const SizedBox(height: 12),
                      const FormFieldLabel(
                        label: 'New email',
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: createInputDecoration(
                            'New email', 'john.doe@exmaple.com'),
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 12),
                      const FormFieldLabel(
                        label: 'Confirm email',
                      ),
                      TextFormField(
                        controller: confirmEmailController,
                        decoration: createInputDecoration(
                            'Confirm email', 'john.doe@exmaple.com'),
                        validator: confirmEmailValidator,
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
