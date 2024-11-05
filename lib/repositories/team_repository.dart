import 'package:flutter/material.dart';
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
