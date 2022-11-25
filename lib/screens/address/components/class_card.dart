import 'package:app_cantina_murialdo/screens/address/components/class_input_field.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {

  ClassCard(this.classController);

  TextEditingController classController;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Turma/Setor',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            ClassInputField(classController),
          ],
        ),
      ),
    );
  }
}
