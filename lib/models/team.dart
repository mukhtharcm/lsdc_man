import 'package:equatable/equatable.dart';
import 'user.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final List<User> managers;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Team({
    required this.id,
    required this.name,
    required this.managers,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        managers,
        isActive,
        createdAt,
        updatedAt,
      ];

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      managers: (map['expand']?['managers'] as List<dynamic>?)
              ?.map((manager) => User.fromMap(manager))
              .toList() ??
          [],
      isActive: map['is_active'],
      createdAt: DateTime.parse(map['created']),
      updatedAt: DateTime.parse(map['updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'managers': managers.map((user) => user.id).toList(),
      'is_active': isActive,
    };
  }
}
