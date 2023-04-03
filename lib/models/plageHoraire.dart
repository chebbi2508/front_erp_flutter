class PlageHoraireModel {
  
  int id;
  String name;
  String applies_to;
  String applies_at;
  String created_at;
  String updated_at;

  PlageHoraireModel({
    required this.id,
    required this.name,
    required this.applies_to,
    required this.applies_at,
    required this.created_at,
    required this.updated_at,
  });
  factory PlageHoraireModel.fromJson(Map<String, dynamic> json) => PlageHoraireModel(
        id: json['id'],
        name: json['name'],
        applies_to: json['applies_to'],
        applies_at: json['applies_at'],
        created_at: json['created_at'].toString(),
        updated_at: json['updated_at'].toString(),
      );
 
}
