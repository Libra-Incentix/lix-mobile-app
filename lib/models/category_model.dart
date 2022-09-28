class Category {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  bool? selected;

  Category({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.selected,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      selected: false,
    );
  }
}
