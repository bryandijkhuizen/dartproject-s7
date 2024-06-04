import 'package:darts_application/features/club_management/club_edit_controller.dart';
import 'package:darts_application/models/postal_code_validator.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'club_edit_view_store.g.dart';

class ClubEditViewStore = _ClubEditViewStore with _$ClubEditViewStore;

abstract class _ClubEditViewStore with Store {
  final SupabaseClient _supabaseClient;
  final Map<String, String?> model;
  final int clubID;
  _ClubEditViewStore(this._supabaseClient, this.model, this.clubID);

  late FormGroup form = FormGroup({
    'clubName': FormControl<String>(
      value: model['name'],
      validators: [
        Validators.required,
        Validators.minLength(2),
      ],
    ),
    'email': FormControl<String>(
      value: model['email'],
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    'phoneNumber': FormControl<PhoneNumber>(
      value:model['phonenumber'] == '' ? const PhoneNumber(isoCode: IsoCode.NL, nsn: '') : PhoneNumber.parse(model['phonenumber']!),
      validators: [
        PhoneValidators.required,
        PhoneValidators.valid,
      ],
    ),
    'address': FormControl<String>(
      value: model['address'],
      validators: [
        Validators.required,
      ],
    ),
    'postalCode': FormControl<String>(
      value: model['postalcode'],
      validators: [
        Validators.required,
        const PostalCodeValidator(),
      ],
    ),
    'city': FormControl<String>(
      value: model['city'],
      validators: [
        Validators.required,
      ],
    ),
  });

  @action
  Future<SupabaseResultType> onSubmit() async {
    if (form.invalid) {
      return const SupabaseResultType(
        success: false,
        message: 'Invalid form submitted',
      );
    }

    try {
      PhoneNumber phoneNumber =
          form.control('phoneNumber').value as PhoneNumber;
      String phoneNumberString =
          '${phoneNumber.countryCode} ${phoneNumber.nsn}';


      Map<String, dynamic> json =
          await _supabaseClient.rpc<Map<String, dynamic>>(
        'update_club',
        params: {
          'p_id' : clubID,
          'p_name': form.control('clubName').value as String,
          'p_address': form.control('address').value as String,
          'p_postal_code': form.control('postalCode').value as String,
          'p_city': form.control('city').value as String,
          'p_email': form.control('email').value as String,
          'p_phone': phoneNumberString,
        },
      );

      return SupabaseResultType.fromJson(json);
    } catch (error) {
      return const SupabaseResultType(
        success: false,
        message: 'Unknown error occurred.',
      );
    }
  }
}

class SupabaseResultType {
  final bool success;
  final String message;

  const SupabaseResultType({required this.success, required this.message});

  factory SupabaseResultType.fromJson(Map<String, dynamic> json) {
    return SupabaseResultType(
      success: json['success'],
      message: json['message'],
    );
  }
}
