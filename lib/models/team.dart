import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'user_model.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final List<String> managerIds;
  final List<User>? members;

  const Team({
    required this.id,
    required this.name,
    required this.managerIds,
    this.members,
  });

  Team copyWith({
    String? id,
    String? name,
    List<String>? managerIds,
    List<User>? members,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      managerIds: managerIds ?? this.managerIds,
      members: members ?? this.members,
    );
  }

  static Team fromRecord(RecordModel record) {
    return Team(
      id: record.id,
      name: record.getStringValue('name'),
      managerIds: List<String>.from(record.getListValue('managers')),
    );
  }

  @override
  List<Object?> get props => [id, name, managerIds, members];
}
