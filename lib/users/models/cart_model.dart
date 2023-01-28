class Cart {
  int? cart_id;
  int? user_id;
  int? item_id;
  int? quantity;
  String? color;
  String? size;
  // item_id belongs to these values
  String? item_name;
  double? item_rating;
  List<String>? item_tags;
  double? item_price;
  List<String>? item_sizes;
  List<String>? item_colors;
  String? item_desc;
  String? item_image;

  Cart({
    this.cart_id,
    this.user_id,
    this.item_id,
    this.quantity,
    this.color,
    this.size,
    this.item_name,
    this.item_rating,
    this.item_tags,
    this.item_price,
    this.item_sizes,
    this.item_colors,
    this.item_desc,
    this.item_image,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cart_id: int.parse(json["cart_id"]),
      user_id: int.parse(json["user_id"]),
      item_id: int.parse(json["item_id"]),
      quantity: int.parse(json["quantity"]),
      color: json["color"],
      size: json["size"],
      item_name: json['item_name'],
      item_rating: double.parse(json['item_rating']),
      item_tags: json['item_tags'].toString().split(', '),
      item_price: double.parse(json['item_price']),
      item_sizes: json['item_sizes'].toString().split(', '),
      item_colors: json['item_colors'].toString().split(', '),
      item_desc: json['item_desc'],
      item_image: json['item_image'],
    );
  }
}
