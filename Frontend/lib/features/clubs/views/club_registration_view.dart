import 'package:darts_application/components/form_field_label.dart';
import 'package:darts_application/components/form_save_button.dart';
import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/extensions.dart';
import 'package:darts_application/features/app_router/app_router_extensions.dart';
import 'package:darts_application/features/clubs/stores/club_registration_view_store.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubRegistrationView extends StatefulWidget {
  const ClubRegistrationView({super.key});

  @override
  State<ClubRegistrationView> createState() => _ClubRegistrationViewState();
}

class _ClubRegistrationViewState extends State<ClubRegistrationView> {
  late final ClubRegistrationViewStore store;

  @override
  void initState() {
    super.initState();
    store = ClubRegistrationViewStore(Supabase.instance.client);
  }

  InputDecoration createInputDecoration(String label, [String? hintText]) =>
      InputDecoration(
        label: Text(label),
        hintText: hintText,
      );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Join our platform'),
      ),
      body: GenericScreen(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    'Wanna be a part of a larger community?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Enroll as club below:',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ReactiveForm(
                formGroup: store.form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FormFieldLabel(label: 'Club name*'),
                    ReactiveTextField(
                      formControlName: 'clubName',
                      decoration:
                          createInputDecoration('Club name', 'Café het Hoekje'),
                      validationMessages: {
                        'required': (error) => 'Please fill in a club name',
                        'minLength': (error) =>
                            'Should be a minimum of ${(error as Map)['requiredLength']} characters long'
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const FormFieldLabel(
                      label: 'Email*',
                      height: 8,
                    ),
                    ReactiveTextField(
                      formControlName: 'email',
                      decoration: createInputDecoration(
                          'Email', 'john.doe@cafehethoekje.nl'),
                      validationMessages: {
                        'required': (error) => 'Please fill in your email',
                        'email': (error) => 'Invalid email address'
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const FormFieldLabel(
                      label: 'Phone number*',
                      height: 8,
                    ),
                    ReactivePhoneFormField(
                      formControlName: 'phoneNumber',
                      decoration: createInputDecoration('Phone', '612345678'),
                      countrySelectorNavigator:
                          CountrySelectorNavigator.draggableBottomSheet(
                        searchBoxTextStyle: theme.textTheme.bodyLarge,
                        titleStyle: theme.textTheme.bodyLarge,
                        subtitleStyle: theme.textTheme.bodySmall,
                        favorites: [
                          IsoCode.NL,
                        ],
                        noResultMessage: 'No country found',
                      ),
                      validationMessages: {
                        'phone.required': (error) =>
                            'Please fill in a phone number',
                        'phone.invalidPhoneNumber': (error) =>
                            'Invalid phone number'
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const FormFieldLabel(
                      label: 'Address*',
                      height: 8,
                    ),
                    ReactiveTextField(
                      formControlName: 'address',
                      decoration:
                          createInputDecoration('Address', 'Grotestraat 1'),
                      validationMessages: {
                        'required': (error) =>
                            'Please fill in the club\'s address'
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const FormFieldLabel(
                      label: 'Postal code*',
                      height: 8,
                    ),
                    ReactiveTextField(
                      formControlName: 'postalCode',
                      decoration:
                          createInputDecoration('Postal code', '6969XD'),
                      validationMessages: {
                        'required': (error) =>
                            'Please fill in the club\'s postal code',
                        'pattern': (error) => 'Invalid postal code'
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const FormFieldLabel(
                      label: 'City*',
                      height: 8,
                    ),
                    ReactiveTextField(
                      formControlName: 'city',
                      decoration: createInputDecoration('City', 'Leeuwarden'),
                      validationMessages: {
                        'required': (error) => 'Please fill in the club\'s city'
                      },
                    ),
                    const FormFieldLabel(
                      label: 'Note (optional)',
                      height: 8,
                    ),
                    ReactiveTextField(
                      minLines: 3,
                      maxLines: null,
                      formControlName: 'note',
                      decoration: createInputDecoration(
                          'Note', 'Something I would like you to know...'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FormSaveButton(
                      onCancel: () {
                        context.goBack('/clubs');
                      },
                      onSave: () async {
                        if (store.form.invalid) {
                          // Mark al fields as touched so errors will show up
                          store.form.markAllAsTouched();
                        } else {
                          SupabaseResultType result = await store.onSubmit();

                          if (context.mounted) {
                            context.ShowSnackbar(
                              SnackBar(
                                  content: Text(result.success
                                      ? 'Successfully applied for a new club'
                                      : result.message),
                                  backgroundColor: result.success
                                      ? theme.colorScheme.secondary
                                      : theme.colorScheme.error),
                            );

                            if (result.success) {
                              context.goBack('/clubs');
                            }
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
