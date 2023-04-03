class Activite {
  int id;
  String name;
  String description;
  String type ;
  String code;
  int color;
 

  Activite({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.color,
    required this.code,
   
  });
  factory Activite.fromJson(Map<String, dynamic> json) => Activite(
        id: json['id'],
        name: json['name'].toString(),
        description: json['description'].toString(),
        type: json['type'].toString(),
        color: int.parse(json['color']),
      
        code: json['code'].toString(),
       
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "type": type,
       
        "code": code,
       
      };
}
