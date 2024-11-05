import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/team/team_bloc.dart';
import '../../../models/team.dart';
import 'team_details_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        return ListView.builder(
          itemCount: state.teams.length,
          itemBuilder: (context, index) {
            final team = state.teams[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(team.name),
                subtitle: Text('Managers: ${team.managerIds.length}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamDetailsScreen(teamId: team.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
