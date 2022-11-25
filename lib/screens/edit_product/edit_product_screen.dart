import 'package:app_cantina_murialdo/models/product.dart';
import 'package:app_cantina_murialdo/models/product_manager.dart';
import 'package:app_cantina_murialdo/screens/edit_product/components/delete_product_dialog.dart';
import 'package:app_cantina_murialdo/screens/edit_product/components/images_form.dart';
import 'package:app_cantina_murialdo/screens/edit_product/components/flavors_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;

  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Anúncio'),
          centerTitle: true,
          actions: [
            if(editing)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (_) => DeleteProductDialog(product: product,)
                  );
                },
              )
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(
                product: product,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                          hintText: 'Título', border: InputBorder.none),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name.length < 6) {
                          return 'Título muito curto!';
                        }
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                    Text(
                      'R\$...',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FlavorsForm(
                      product: product,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            height: 44,
                            child: RaisedButton(
                              onPressed: !product.loading
                                  ? () async {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        await product.save();

                                        context
                                            .read<ProductManager>()
                                            .update(product);

                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  : null,
                              color: Theme.of(context).primaryColor,
                              disabledColor:
                                  Theme.of(context).primaryColor.withAlpha(100),
                              textColor: Colors.white,
                              child: product.loading
                                  ? const CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : const Text(
                                      'Salvar',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
