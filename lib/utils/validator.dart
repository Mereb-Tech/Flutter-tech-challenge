class CustomFormFieldValidators {
  emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Email is required';
    }
    final RegExp emailRegExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  oldPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Old Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  confirmPasswordValidator(String? value, String? password) {
    if (value!.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != password) {
      return 'Password do not match.';
    }
    return null;
  }

  phoneValidator(String? value) {
    if (value!.isEmpty) {
      return 'Phone is required';
    }
    if (value.length != 9) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  emptyFieldeValidator(String? value, String text) {
    if (value == null) {
      return '     $text is required';
    }
    if (value.isEmpty) {
      return '$text is required';
    }
    if (value.length < 2) {
      return '$text is too short';
    }
    return null;
  }
}
