import 'package:app_cantina_murialdo/common/custom_icon_buttom/custom_icon_button.dart';
import 'package:app_cantina_murialdo/models/item_flavor.dart';
import 'package:app_cantina_murialdo/models/product.dart';
import 'package:app_cantina_murialdo/screens/edit_product/components/edit_item_flavor.dart';
import 'package:flutter/material.dart';

class FlavorsForm extends StatelessWidget {

  const FlavorsForm({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemFlavor>>(
        initialValue: product.flavors,
        validator: (flavors){
          if(flavors.isEmpty){
            return 'Insira ao menos um um sabor!';
          }else{
            return null;
          }
        },
        builder: (state){
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sabores',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  CustomIconButton(
                    iconData: Icons.add,
                    onTap: (){
                      state.value.add(ItemFlavor());
                      state.didChange(state.value);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              Column(
                children: state.value.map((flavor){
                  return EditItemFlavor(
                    flavor: flavor,
                    onRemove: () {
                      state.value.remove(flavor);
                      state.didChange(state.value);
                    },
                    onMoveUp: flavor != state.value.first ? () {
                      final index = state.value.indexOf(flavor);
                      state.value.remove(flavor);
                      state.value.insert(index - 1, flavor);
                      state.didChange(state.value);
                    } : null,
                    onMoveDown: flavor != state.value.last ? () {
                      final index = state.value.indexOf(flavor);
                      state.value.remove(flavor);
                      state.value.insert(index + 1, flavor);
                      state.didChange(state.value);
                    } : null,
                    key: ObjectKey(flavor),
                  );
                }).toList(),
              ),
              if(state.hasError)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.errorText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                )
            ],
          );
        },
    );
  }
}
