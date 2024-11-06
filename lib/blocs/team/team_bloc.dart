import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/team.dart';
import '../../models/team_summary.dart';
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

class LoadTeamSummaries extends TeamEvent {}

// States
class TeamState extends Equatable {
  final List<Team> teams;
  final Team? selectedTeam;
  final Map<String, TeamSummary> teamSummaries;
  final bool isLoading;
  final String? error;

  const TeamState({
    this.teams = const [],
    this.selectedTeam,
    this.teamSummaries = const {},
    this.isLoading = false,
    this.error,
  });

  TeamState copyWith({
    List<Team>? teams,
    Team? selectedTeam,
    Map<String, TeamSummary>? teamSummaries,
    bool? isLoading,
    String? error,
  }) {
    return TeamState(
      teams: teams ?? this.teams,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      teamSummaries: teamSummaries ?? this.teamSummaries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [teams, selectedTeam, teamSummaries, isLoading, error];
}

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;

  TeamBloc({required TeamRepository teamRepository})
      : _teamRepository = teamRepository,
        super(const TeamState()) {
    on<LoadTeams>(_onLoadTeams);
    on<LoadTeamDetails>(_onLoadTeamDetails);
    on<LoadTeamSummaries>(_onLoadTeamSummaries);
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

  Future<void> _onLoadTeamSummaries(
    LoadTeamSummaries event,
    Emitter<TeamState> emit,
  ) async {
    try {
      final summaries = await _teamRepository.getTeamsSummaryForToday();
      emit(state.copyWith(teamSummaries: summaries));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
