import 'package:equatable/equatable.dart';
import '../../models/daily_entry.dart';

enum DailyEntryStatus { initial, loading, success, failure }

class DailyEntryState extends Equatable {
  final DailyEntryStatus status;
  final List<DailyEntry> entries;
  final DailyEntry? currentEntry;
  final String? error;

  const DailyEntryState({
    this.status = DailyEntryStatus.initial,
    this.entries = const [],
    this.currentEntry,
    this.error,
  });

  DailyEntryState copyWith({
    DailyEntryStatus? status,
    List<DailyEntry>? entries,
    DailyEntry? currentEntry,
    String? error,
  }) {
    return DailyEntryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      currentEntry: currentEntry ?? this.currentEntry,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, entries, currentEntry, error];
}
