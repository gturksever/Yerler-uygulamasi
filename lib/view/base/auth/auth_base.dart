import 'package:flutter/material.dart';

class BaseAuth extends StatelessWidget {
  const BaseAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'What do people call you?',
            labelText: 'Name *',
          ),
          onSaved: (String? value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String? value) {
            print(value);
            return (value != null && !value.contains('@'))
                ? 'Lütfen geçerli bir e-posta adresi giriinz.'
                : null;
          },
        )
      ],
    );
  }
}
