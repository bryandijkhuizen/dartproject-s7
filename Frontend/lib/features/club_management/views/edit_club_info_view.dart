import 'package:darts_application/components/form_field_label.dart';
import 'package:darts_application/components/form_save_button.dart';
import 'package:darts_application/extensions.dart';
import 'package:darts_application/features/app_router/app_router_extensions.dart';
import 'package:darts_application/features/club_management/club_edit_controller.dart';
import 'package:darts_application/features/club_management/stores/club_edit_view_store.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditClubInfoView extends StatefulWidget {
  const EditClubInfoView({Key? key}) : super(key: key);

  @override
  _EditClubInfoViewState createState() => _EditClubInfoViewState();
}

class _EditClubInfoViewState extends State<EditClubInfoView> {
  late ClubEditController controller;
  void loadData() {
    UserStore userStore = context.read();
    int clubId = userStore.permissions
        .getClubIdByPermission(PermissionList.manageClubMembers);
    controller = ClubEditController(Supabase.instance.client, clubId);
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    ThemeData theme = Theme.of(context);
    return FutureBuilder(
        future: controller.model,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          }

          if (snapshot.hasData) {
            Map<String, String?> model = snapshot.data!;
            ClubEditViewStore editViewStore =
                ClubEditViewStore(Supabase.instance.client, model, controller.clubId);
            return SingleChildScrollView(
              child: ReactiveForm(
                          formGroup: editViewStore.form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormFieldLabel(label: 'Club name*'),
                              ReactiveTextField(
                                formControlName: 'clubName',
                                validationMessages: {
                                  'required': (error) =>
                                      'Please fill in a club name',
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
                                validationMessages: {
                                  'required': (error) =>
                                      'Please fill in your email',
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
                                validationMessages: {
                                  'required': (error) =>
                                      'Please fill in the club\'s city'
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              FormSaveButton(
                                onCancel: () {
                                  context.goBack('/');
                                },
                                onSave: () async {
                                  if (editViewStore.form.invalid) {
                                    // Mark al fields as touched so errors will show up
                                    editViewStore.form.markAllAsTouched();
                                  } else {
                                    SupabaseResultType result =
                                        await editViewStore.onSubmit();
              
                                    if (context.mounted) {
                                      context.ShowSnackbar(
                                        SnackBar(
                                            content: Text(result.success
                                                ? 'Successfully updated your club'
                                                : result.message),
                                            backgroundColor: result.success
                                                ? theme.colorScheme.secondary
                                                : theme.colorScheme.error),
                                      );
              
                                      if (result.success) {
                                        context.goBack('/');
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
            );
            
          }
          return const CircularProgressIndicator();
        });
  }
}
