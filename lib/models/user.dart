class User {
  int id;
  String firstname;
  String lastname;
  String job;
  String email;
  String status;
  int fk_population;
  int created_by;
  String created_at;
  String updated_at;

  User({
    required this.id,
    required this.firstname,
    required this.email,
    required this.lastname,
    required this.job,
    required this.status,
    required this.fk_population,
    required this.created_by,

    required this.created_at,
    required this.updated_at,
  });
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstname: json['firstname'].toString(),
        email: json['email'].toString(),
        lastname: json['lastname'].toString(),
        job: json['job'].toString(),
        status: json['status'].toString(),
        fk_population: json['fk_population'],
        created_by: json['created_by'],
        created_at: json['created_at'].toString(),
        updated_at: json['updated_at'].toString(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "email": email,
        "lastname": lastname,
        "job": job,
        "status": status,
        "fk_population":fk_population,
        "created_by":created_by,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}
