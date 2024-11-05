import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../models/user_model.dart';
import '../../daily_entry/screens/daily_entries_screen.dart';
import '../../admin/screens/admin_dashboard.dart';

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(
            title: Text(_getTitle(user.role)),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              ),
            ],
          ),
          body: user.role == UserRole.admin
              ? const AdminDashboard()
              : DailyEntriesScreen(userRole: user.role, teamId: user.teamId),
        );
      },
    );
  }

  String _getTitle(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin Dashboard';
      case UserRole.teamManager:
        return 'Team Manager Dashboard';
      case UserRole.member:
        return 'Member Dashboard';
      default:
        return 'Dashboard';
    }
  }
}
