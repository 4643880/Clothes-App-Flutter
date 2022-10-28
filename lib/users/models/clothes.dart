class Clothes {
  int? item_id;
  String? item_name;
  double? item_rating;
  List<String>? item_tags;
  double? item_price;
  List<String>? item_sizes;
  List<String>? item_colors;
  String? item_desc;
  String? item_image;

  Clothes({
    this.item_id,
    this.item_name,
    this.item_rating,
    this.item_tags,
    this.item_price,
    this.item_sizes,
    this.item_colors,
    this.item_desc,
    this.item_image,
  });

  Clothes.name(
      this.item_id,
      this.item_name,
      this.item_rating,
      this.item_tags,
      this.item_price,
      this.item_sizes,
      this.item_colors,
      this.item_desc,
      this.item_image);

  factory Clothes.fromJson(Map<String, dynamic> json) => Clothes(
      item_id: int.parse(json['item_id']),
      item_name: json['item_name'],
      item_rating: double.parse(json['item_rating']),
      item_tags: json['item_tags'].toString().split(', '),
      item_price: double.parse(json['item_price']),
      item_sizes: json['item_sizes'].toString().split(', '),
      item_colors: json['item_colors'].toString().split(', '),
      item_desc: json['item_desc'],
      item_image: json['item_image']);
}
