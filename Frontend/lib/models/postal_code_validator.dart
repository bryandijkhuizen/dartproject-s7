import 'package:reactive_forms/reactive_forms.dart';

class PostalCodeValidator extends Validator<dynamic> {
  const PostalCodeValidator();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is String) {
      // General regex for postal code validation
      final RegExp regex = RegExp(r'^[a-zA-Z0-9]{4,10}$');
      if (!regex.hasMatch(value)) {
        return {ValidationMessage.pattern: true};
      }
    }
    return null;
  }
}
