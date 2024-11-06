import 'package:equatable/equatable.dart';
import '../../models/daily_entry.dart';

abstract class DailyEntryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDailyEntries extends DailyEntryEvent {
  final String? teamId;
  final String? userId;
  final DateTime? fromDate;
  final DateTime? toDate;

  LoadDailyEntries({
    this.teamId,
    this.userId,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [teamId, userId, fromDate, toDate];
}

class CreateDailyEntry extends DailyEntryEvent {
  final DailyEntry entry;

  CreateDailyEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

class UpdateDailyEntry extends DailyEntryEvent {
  final String id;
  final DailyEntry entry;

  UpdateDailyEntry(this.id, this.entry);

  @override
  List<Object?> get props => [id, entry];
}

class DeleteDailyEntry extends DailyEntryEvent {
  final String id;

  DeleteDailyEntry(this.id);

  @override
  List<Object?> get props => [id];
}

class CheckDailyEntryExists extends DailyEntryEvent {
  final String teamId;
  final DateTime date;

  CheckDailyEntryExists(this.teamId, this.date);

  @override
  List<Object?> get props => [teamId, date];
}

class LoadUserTodayEntry extends DailyEntryEvent {
  final String userId;

  LoadUserTodayEntry(this.userId);

  @override
  List<Object?> get props => [userId];
}
