import 'package:equatable/equatable.dart';

enum UserRole { admin, teamManager, member }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String teamId;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.teamId,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        teamId,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      teamId: map['team_id'],
      role: UserRole.values.firstWhere(
        (role) => role.toString() == 'UserRole.${map['role']}',
      ),
      isActive: map['is_active'],
      createdAt: DateTime.parse(map['created']),
      updatedAt: DateTime.parse(map['updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'team_id': teamId,
      'role': role.toString().split('.').last,
      'is_active': isActive,
    };
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isTeamManager => role == UserRole.teamManager;
  bool get isMember => role == UserRole.member;
}
