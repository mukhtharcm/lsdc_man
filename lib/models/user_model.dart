import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

enum UserRole { admin, teamManager, member }

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? team;
  final UserRole? role;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.team,
    this.role,
  });

  static User fromRecord(RecordModel record) {
    return User(
      id: record.id,
      email: record.getStringValue('email'),
      name: record.getStringValue('name'),
      team: record.getStringValue('team'),
      role: _parseRole(record.getStringValue('role')),
    );
  }

  static UserRole? _parseRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'teamManager':
        return UserRole.teamManager;
      case 'member':
        return UserRole.member;
      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [id, email, name, team, role];
}
