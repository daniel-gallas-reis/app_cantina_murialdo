class ItemFlavor {

  ItemFlavor({this.name, this.price, this.stock});

  ItemFlavor.fromMap(Map<String, dynamic> map){
    name = map['name'] as String;
    price = map['price'] as num;
    stock = map['stock'] as int;
  }

  String name;
  num price;
  int stock;

  bool get temStock => stock > 0;

  @override
  String toString() {
    return 'ItemFlavor{name: $name, price: $price, stock: $stock}';
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'price': price,
      'stock': stock
    };
  }

  ItemFlavor clone(){
    return ItemFlavor(
      name: name,
      price: price,
      stock: stock
    );
  }

}