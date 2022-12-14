import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {

  const SearchDialog({@required this.initialText});

  final String initialText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 2,
            right: 4,
            left: 4,
            child: Card(
              child: TextFormField(
                initialValue: initialText,
                textInputAction: TextInputAction.search,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                  ),
                ),
                onFieldSubmitted: (text){
                  Navigator.of(context).pop(text);
                },
              ),
            ),
        ),
      ],
    );
  }
}
