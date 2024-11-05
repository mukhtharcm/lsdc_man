import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final List<String> managerIds;

  const Team({
    required this.id,
    required this.name,
    required this.managerIds,
  });

  static Team fromRecord(RecordModel record) {
    return Team(
      id: record.id,
      name: record.getStringValue('name'),
      managerIds: List<String>.from(record.getListValue('managers')),
    );
  }

  @override
  List<Object?> get props => [id, name, managerIds];
}
