import 'package:flutter/material.dart';
import 'package:lsdc_man/models/daily_entry.dart';
import 'package:lsdc_man/models/team_summary.dart';
import 'package:pocketbase/pocketbase.dart';
import '../models/team.dart';
import '../models/user_model.dart';

class TeamRepository {
  final PocketBase _pb;

  TeamRepository(this._pb);

  Future<List<Team>> getTeams() async {
    final records = await _pb.collection('teams').getList();
    return records.items.map((record) => Team.fromRecord(record)).toList();
  }

  Future<Map<String, TeamSummary>> getTeamsSummaryForToday() async {
    final today = DateTime.now();
    final startOfDay = "${today.toIso8601String().split('T')[0]} 00:00:00.000Z";
    final endOfDay = "${today.toIso8601String().split('T')[0]} 23:59:59.999Z";

    debugPrint('Getting team summaries between $startOfDay and $endOfDay');

    try {
      final records = await _pb.collection('dairy_entries').getList(
            filter: 'date >= "$startOfDay" && date <= "$endOfDay"',
            expand: 'team,user',
          );

      debugPrint('Found ${records.items.length} entries for today');

      Map<String, TeamSummary> summaries = {};

      for (var record in records.items) {
        final entry = DailyEntry.fromRecord(record);
        final teamId = entry.teamId;

        if (!summaries.containsKey(teamId)) {
          summaries[teamId] = TeamSummary(
            teamId: teamId,
            totalCollection: 0,
            totalCalendars: 0,
            totalSold: 0,
            totalExpense: 0,
            totalBatta: 0,
            entriesCount: 0,
          );
        }

        final summary = summaries[teamId]!;
        summaries[teamId] = summary.copyWith(
          totalCollection: summary.totalCollection + entry.total,
          totalCalendars: summary.totalCalendars + entry.noOfCalendar,
          totalSold: summary.totalSold + entry.soldNo,
          totalExpense: summary.totalExpense + entry.expense,
          totalBatta: summary.totalBatta + entry.batta,
          entriesCount: summary.entriesCount + 1,
        );
      }

      return summaries;
    } catch (e) {
      debugPrint('Error getting team summaries: $e');
      rethrow;
    }
  }

  Future<Team> getTeamWithMembers(String teamId) async {
    // Get team details
    final teamRecord = await _pb.collection('teams').getOne(teamId);
    final team = Team.fromRecord(teamRecord);

    // Get team members
    final memberRecords = await _pb.collection('users').getList(
          filter: 'team = "$teamId"',
        );

    debugPrint('Found ${memberRecords.items.length} members for team $teamId');

    final members =
        memberRecords.items.map((record) => User.fromRecord(record)).toList();

    return team.copyWith(members: members);
  }
}
