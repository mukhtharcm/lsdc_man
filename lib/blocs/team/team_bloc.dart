import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/team.dart';
import '../../repositories/team_repository.dart';

// Events
abstract class TeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeams extends TeamEvent {}

class LoadTeamDetails extends TeamEvent {
  final String teamId;

  LoadTeamDetails(this.teamId);

  @override
  List<Object?> get props => [teamId];
}

// States
class TeamState extends Equatable {
  final List<Team> teams;
  final Team? selectedTeam;
  final bool isLoading;
  final String? error;

  const TeamState({
    this.teams = const [],
    this.selectedTeam,
    this.isLoading = false,
    this.error,
  });

  TeamState copyWith({
    List<Team>? teams,
    Team? selectedTeam,
    bool? isLoading,
    String? error,
  }) {
    return TeamState(
      teams: teams ?? this.teams,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [teams, selectedTeam, isLoading, error];
}

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;

  TeamBloc({required TeamRepository teamRepository})
      : _teamRepository = teamRepository,
        super(const TeamState()) {
    on<LoadTeams>(_onLoadTeams);
    on<LoadTeamDetails>(_onLoadTeamDetails);
  }

  Future<void> _onLoadTeams(LoadTeams event, Emitter<TeamState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final teams = await _teamRepository.getTeams();
      emit(state.copyWith(
        teams: teams,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadTeamDetails(
      LoadTeamDetails event, Emitter<TeamState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final team = await _teamRepository.getTeamWithMembers(event.teamId);
      emit(state.copyWith(
        selectedTeam: team,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }
}
