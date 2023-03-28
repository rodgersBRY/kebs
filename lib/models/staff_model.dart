class Staff {
  Staff({
    required this.hrno,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.position,
    required this.status,
  });

  String hrno;
  String firstname;
  String middlename;
  String lastname;
  String position;
  String status;

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        hrno: json["Hrno"],
        firstname: json["Firstname"],
        middlename: json["Middlename"],
        lastname: json["Lastname"],
        position: json["Position"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Hrno": hrno,
        "Firstname": firstname,
        "Middlename": middlename,
        "Lastname": lastname,
        "Position": position,
        "Status": status,
      };
}
