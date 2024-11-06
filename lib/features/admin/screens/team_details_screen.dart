import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lsdc_man/config/theme.dart';
import '../../../blocs/team/team_bloc.dart';
import '../../../models/user_model.dart';
import 'member_details_screen.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String teamId;

  const TeamDetailsScreen({super.key, required this.teamId});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>().add(LoadTeamDetails(widget.teamId));
  }

  Future<void> _onRefresh() async {
    context.read<TeamBloc>().add(LoadTeamDetails(widget.teamId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final team = state.selectedTeam;
        if (team == null) {
          return const Scaffold(
            body: Center(child: Text('Team not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(team.name),
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              itemCount: team.members?.length ?? 0,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTheme.paddingSmall),
              itemBuilder: (context, index) {
                final member = team.members![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        member.name ?? member.email,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Padding(
                        padding:
                            const EdgeInsets.only(top: AppTheme.paddingSmall),
                        child: Text(
                          _getRoleText(member.role),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _navigateToMemberDetails(member, team.name),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _getRoleText(UserRole? role) {
    switch (role) {
      case UserRole.teamManager:
        return 'Team Manager';
      case UserRole.member:
        return 'Member';
      default:
        return 'Unknown Role';
    }
  }

  void _navigateToMemberDetails(User member, String teamName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDetailsScreen(
          member: member,
          teamName: teamName,
        ),
      ),
    );
  }
}
