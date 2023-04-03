class Population {
  int id;
  String name;
  String created_at;
  String updated_at;

  Population({
    required this.id,
    required this.name,
    required this.created_at,
    required this.updated_at,
  });
  factory Population.fromJson(Map<String, dynamic> json) => Population(
        id: json['id'],
        name: json['name'].toString(),

        created_at: json['created_at'].toString(),
        updated_at: json['updated_at'].toString(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}
