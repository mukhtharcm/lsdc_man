import 'package:pocketbase/pocketbase.dart';
import '../models/daily_entry.dart';

class DailyEntryRepository {
  final PocketBase _pb;
  static const String _collectionName = 'dairy_entries';

  DailyEntryRepository(this._pb);

  Future<List<DailyEntry>> getEntries({
    String? teamId,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final filters = <String>[];

    if (teamId != null) filters.add('team = "$teamId"');
    if (userId != null) filters.add('user = "$userId"');

    if (fromDate != null) {
      filters.add('date >= "${fromDate.toIso8601String().split('T')[0]}"');
    }
    if (toDate != null) {
      filters.add('date <= "${toDate.toIso8601String().split('T')[0]}"');
    }

    final filter = filters.join(' && ');

    final records = await _pb.collection(_collectionName).getList(
          filter: filter.isEmpty ? null : filter,
          sort: '-date',
        );

    return records.items
        .map((record) => DailyEntry.fromRecord(record))
        .toList();
  }

  Future<DailyEntry> createEntry(DailyEntry entry) async {
    final record = await _pb.collection(_collectionName).create(
          body: entry.toJson(),
        );
    return DailyEntry.fromRecord(record);
  }

  Future<DailyEntry> updateEntry(String id, DailyEntry entry) async {
    final record = await _pb.collection(_collectionName).update(
          id,
          body: entry.toJson(),
        );
    return DailyEntry.fromRecord(record);
  }

  Future<void> deleteEntry(String id) async {
    await _pb.collection(_collectionName).delete(id);
  }

  Future<DailyEntry?> getEntryForDate(String teamId, DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    try {
      final records = await _pb.collection(_collectionName).getList(
            filter: 'team = "$teamId" && date = "$dateStr"',
          );

      if (records.items.isEmpty) return null;
      return DailyEntry.fromRecord(records.items.first);
    } catch (e) {
      return null;
    }
  }

  Future<DailyEntry?> getTodayEntryForUser(String userId) async {
    final today = DateTime.now();
    final dateStr = today.toIso8601String().split('T')[0];

    try {
      final records = await _pb.collection(_collectionName).getList(
            filter: 'user = "$userId" && date = "$dateStr"',
            sort: '-created',
            page: 1,
            perPage: 1,
          );

      if (records.items.isEmpty) return null;
      return DailyEntry.fromRecord(records.items.first);
    } catch (e) {
      return null;
    }
  }
}
