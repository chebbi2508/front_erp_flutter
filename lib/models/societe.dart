class Societe {
  int id;
  String name;
  String adresse;
  int user_id;
 

  Societe({
    required this.id,
    required this.name,
    required this.adresse,

    required this.user_id,

  });
  factory Societe.fromJson(Map<String, dynamic> json) => Societe(
        id: json['id'],
        name: json['name'].toString(),
        adresse: json['adresse'].toString(),

        user_id: json['user_id'],
      

       
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "adresse": adresse,
       
      };
}
