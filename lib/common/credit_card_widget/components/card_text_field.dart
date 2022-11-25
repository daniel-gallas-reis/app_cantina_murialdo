import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  const CardTextField(
      {@required this.title,
      this.bold = false,
      @required this.hint,
      this.textInputType,
      this.inputFormatters,
      this.validator,
      this.maxLength,
      this.textAlign = TextAlign.start,
      this.focusNode,
      this.onSubmited,
        this.initialValue,
      this.onSaved}) : textInputAction = onSubmited == null ? TextInputAction.done : TextInputAction.next;

  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String) onSubmited;
  final TextInputAction textInputAction;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (title != null)
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    if (state.hasError)
                      const Text(
                        '    Inválido',
                        style: TextStyle(color: Colors.red, fontSize: 9),
                      )
                  ],
                ),
              TextFormField(
                initialValue: initialValue,
                cursorColor: Colors.white,
                textAlign: textAlign,
                maxLength: maxLength,
                style: TextStyle(
                    color: title != null && !state.hasError ? Colors.white : Colors.red,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w500),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hint,
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  hintStyle: TextStyle(
                    color: Colors.white.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                onChanged: (text) {
                  state.didChange(text);
                },
                focusNode: focusNode,
                onFieldSubmitted: onSubmited,
                textInputAction: textInputAction,
              ),
            ],
          ),
        );
      },
    );
  }
}
