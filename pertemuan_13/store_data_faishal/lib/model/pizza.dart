// Konstanta untuk JSON keys
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImageUrl = 'imageUrl';

class Pizza {
  int id;
  String pizzaName;
  String description;
  double price;
  String imageUrl;

  Pizza({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json[keyId] is int
          ? json[keyId]
          : int.tryParse(json[keyId]?.toString() ?? '') ?? 0,

      pizzaName: json[keyPizzaName]?.toString() ?? 'No Name',

      description: json[keyDescription]?.toString() ?? 'No Description',

      price: json[keyPrice] is double
          ? json[keyPrice]
          : double.tryParse(json[keyPrice]?.toString() ?? '') ?? 0,

      imageUrl: json[keyImageUrl]?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      keyId: id,
      keyPizzaName: pizzaName,
      keyDescription: description,
      keyPrice: price,
      keyImageUrl: imageUrl,
    };
  }
}
