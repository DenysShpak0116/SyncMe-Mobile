enum Sex {
  male,
  female,
  other,
}

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
  final int userId;
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final Sex sex;
  final String country;
  final String role;
}
