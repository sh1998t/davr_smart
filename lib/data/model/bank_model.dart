// class Bank {
//   final int id;
//   final String name;
//   final String logo;
//   final int status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Bank({
//     required this.id,
//     required this.name,
//     required this.logo,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Bank.fromJson(Map<String, dynamic> json) {
//     return Bank(
//       id: json['id'],
//       name: json['name'],
//       logo: json['logo'],
//       status: json['status'],
//       createdAt: DateTime.parse(json['created_at']['date']),
//       updatedAt: DateTime.parse(json['updated_at']['date']),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'logo': logo,
//         'status': status,
//         'created_at': {'date': createdAt.toIso8601String()},
//         'updated_at': {'date': updatedAt.toIso8601String()},
//       };
// }
