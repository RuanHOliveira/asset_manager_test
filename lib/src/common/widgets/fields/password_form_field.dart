import 'package:asset_manager_test/src/common/widgets/fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final FormFieldValidator<String>? validator;

  const PasswordFormField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      obscureText: isHidden,
      controller: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      validator: widget.validator,
      suffixIcon: InkWell(
        borderRadius: BorderRadius.circular(23.0),
        onTap: () {
          setState(() {
            isHidden = !isHidden;
          });
        },
        child: Icon(
          isHidden ? Icons.visibility : Icons.visibility_off,
          color: Colors.blue.shade500,
        ),
      ),
    );
  }
}
