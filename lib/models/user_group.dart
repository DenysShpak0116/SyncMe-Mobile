import 'package:syncme/models/group.dart';
import 'package:syncme/models/user.dart';

class UserGroup {
  UserGroup({
    required this.userGroupId,
    required this.group,
    required this.user,
  });
  final String userGroupId;
  final Group group;
  final User user;
}
