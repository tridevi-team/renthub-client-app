class Explore {
  final int id;
  final String name;
  final String image;
  final String description;
  final int quantity;

  Explore({required this.id, required this.name, required this.image, this.description = '', required this.quantity});
}