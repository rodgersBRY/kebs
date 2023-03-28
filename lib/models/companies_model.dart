class Company {
  final String companyName;

  Company({required this.companyName});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        companyName: json["companyName"] != null ? json['companyName'] : 'null',
      );
}
