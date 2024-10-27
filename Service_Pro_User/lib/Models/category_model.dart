class CategoryModel {
  String? id;
  String? name;
  String? description;
  List<dynamic>? services;
  String? image;
  bool? active;
  String? createdAt;
  String? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.services,
    this.image,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['Name'];
    description = json['Description'];
    services = json['Services'];
    image = json['Image'];
    active = json['Active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['Name'] = name;
    data['Description'] = description;
    data['Services'] = services;
    data['Image'] = image;
    data['Active'] = active;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}
