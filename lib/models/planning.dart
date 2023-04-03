class Planning {
  int id;
  String code;
  int user_id;
  int activity;
  DateTime start_time;
  DateTime end_time;
  int employee;
  String status;
  String note;

  Planning({
    required this.id,
    required this.employee,
    required this.code,
 
    required this.end_time,
    required this.start_time,
    required this.activity,
    required this.status,
    required this.user_id,
    required this.note,
    
  });
  factory Planning.fromJson(Map<String, dynamic> json) => Planning(
        id: json['id'],
        employee: json['employe'],
        code: json['code'].toString(),

        end_time: json['end_time'] != null ? DateTime.parse(json['end_time']) : DateTime.now(),
        start_time: json['start_time'] != null ? DateTime.parse(json['start_time']) : DateTime.now(),
        activity: json['activity'],
        note: json['note'].toString(),
        user_id: json['user_id'],
        status: json['status'].toString(),
       
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "employee": employee,
        "code": code,

        "end_time": end_time,
        "start_time": start_time,
        "activity": activity,
        "note": note,
        "status": status,
        "user_id": user_id,
     
      };
}
