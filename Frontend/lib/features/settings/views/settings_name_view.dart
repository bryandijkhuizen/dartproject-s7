import 'package:darts_application/components/form_field_label.dart';
import 'package:darts_application/components/form_save_button.dart';
import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/extensions.dart';
import 'package:darts_application/features/app_router/app_router_extensions.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsNameView extends StatefulWidget {
  const SettingsNameView({super.key});

  @override
  State<SettingsNameView> createState() => _SettingsNameViewState();
}

class _SettingsNameViewState extends State<SettingsNameView> {
  bool loading = false;
  User user = Supabase.instance.client.auth.currentUser!;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  String? Function(String?)? firstNameValidator =
      ValidationBuilder(requiredMessage: 'Please enter your first name')
          .minLength(2, 'Your first name must be a minimum of 2 characters')
          .build();

  String? Function(String?)? lastNameValidator =
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
            data: {
              'first_name': firstNameController.text,
              'last_name': lastNameController.text,
            },
          ),
        );

        if (mounted) {
          context.goBack('/settings');
          context.ShowSnackbar(
            const SnackBar(
              content: Text('Succesfully changed your name!'),
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
  void initState() {
    super.initState();
    firstNameController.text = user.userMetadata?['first_name'];
    lastNameController.text = user.userMetadata?['last_name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Change your name'),
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
                      const FormFieldLabel(label: 'First name'),
                      TextFormField(
                        controller: firstNameController,
                        decoration: createInputDecoration(
                          'First name',
                          'John',
                        ),
                        validator: firstNameValidator,
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      const FormFieldLabel(
                        label: 'Last name',
                      ),
                      TextFormField(
                        controller: lastNameController,
                        decoration: createInputDecoration('Last name', 'Doe'),
                        validator: lastNameValidator,
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
