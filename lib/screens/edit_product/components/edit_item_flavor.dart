import 'package:app_cantina_murialdo/common/custom_icon_buttom/custom_icon_button.dart';
import 'package:app_cantina_murialdo/models/item_flavor.dart';
import 'package:flutter/material.dart';

class EditItemFlavor extends StatelessWidget {
  const EditItemFlavor(
      {@required Key key,
        @required this.flavor,
      @required this.onRemove,
      @required this.onMoveDown,
      @required this.onMoveUp}) : super(key: key);

  final ItemFlavor flavor;

  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            validator: (name){
              if(name.isEmpty){
                return 'Insira um nome!';
              }else{
                return null;
              }
            },
            onChanged: (name) => flavor.name = name,
            initialValue: flavor.name,
            decoration: const InputDecoration(
              labelText: 'Titulo',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            onChanged: (stock) => flavor.stock = int.tryParse(stock),
            validator: (stock){
              if(int.tryParse(stock) == null){
                return 'Inválido';
              }else{
                return null;
              }
            },
            initialValue: flavor.stock.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
            onChanged: (price) => flavor.price = num.tryParse(price),
            validator: (price){
              if(num.tryParse(price) == null){
                return 'Inválido';
              }else{
                return null;
              }
            },
            initialValue:
                flavor.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              prefixText: 'R\$ ',
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
