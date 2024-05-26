// enum Sex {
//   male,
//   female,
//   other,
// }

// const userSex = {
//   Sex.male: 'Male',
//   Sex.female: 'Female',
//   Sex.other: 'Other',
// };

class User {
  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.sex,
    required this.country,
    required this.role,
  });
  int userId;
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String sex;
  final String country;
  final String role;
}
