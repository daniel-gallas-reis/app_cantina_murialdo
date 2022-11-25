import 'package:app_cantina_murialdo/models/home_manager.dart';
import 'package:app_cantina_murialdo/models/section.dart';
import 'package:flutter/material.dart';

class AddSectionWidgets extends StatelessWidget {

  const AddSectionWidgets({@required this.homeManager});

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
              onPressed: (){
                homeManager.addSection(Section(type: 'List'));
              },
              textColor: Colors.white,
              child: const Text(
                'Adicionar Lista'
              ),
          ),
        ),
        Expanded(
          child: FlatButton(
              onPressed: (){
                homeManager.addSection(Section(type: 'Staggered'));
              },
              textColor: Colors.white,
              child: const Text(
                  'Adicionar Grade'
              ),
          ),
        ),
      ],
    );
  }
}
