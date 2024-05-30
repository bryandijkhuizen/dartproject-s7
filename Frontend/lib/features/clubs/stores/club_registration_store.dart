import 'package:darts_application/models/postal_code_validator.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'club_registration_store.g.dart';

class ClubRegistrationStore = _ClubRegistrationStore
    with _$ClubRegistrationStore;

abstract class _ClubRegistrationStore with Store {
  final SupabaseClient _supabaseClient;
  _ClubRegistrationStore(this._supabaseClient);

  final form = FormGroup({
    'clubName': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(2),
      ],
    ),
    'email': FormControl<String>(
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    'phoneNumber': FormControl<PhoneNumber>(
      value: const PhoneNumber(isoCode: IsoCode.NL, nsn: ''),
      validators: [
        PhoneValidators.required,
        PhoneValidators.valid,
      ],
    ),
    'address': FormControl<String>(
      validators: [
        Validators.required,
      ],
    ),
    'postalCode': FormControl<String>(
      validators: [
        Validators.required,
        const PostalCodeValidator(),
      ],
    ),
    'city': FormControl<String>(
      validators: [
        Validators.required,
      ],
    ),
    'note': FormControl<String>(),
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

      bool noteNotNull = form.control('note').value != null;

      Map<String, dynamic> json =
          await _supabaseClient.rpc<Map<String, dynamic>>(
        'create_club',
        params: {
          'p_name': form.control('clubName').value as String,
          'p_address': form.control('address').value as String,
          'p_postal_code': form.control('postalCode').value as String,
          'p_city': form.control('city').value as String,
          'p_email': form.control('email').value as String,
          'p_phone': phoneNumberString,
          'p_note': noteNotNull ? form.control('note').value as String : '',
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
