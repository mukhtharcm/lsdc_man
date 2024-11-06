class TeamSummary {
  final String teamId;
  final double totalCollection;
  final int totalCalendars;
  final int totalSold;
  final double totalExpense;
  final double totalBatta;
  final int entriesCount;

  const TeamSummary({
    required this.teamId,
    required this.totalCollection,
    required this.totalCalendars,
    required this.totalSold,
    required this.totalExpense,
    required this.totalBatta,
    required this.entriesCount,
  });

  double get averagePerCalendar {
    if (totalSold == 0) return 0;
    return totalCollection / totalSold;
  }

  TeamSummary copyWith({
    String? teamId,
    double? totalCollection,
    int? totalCalendars,
    int? totalSold,
    double? totalExpense,
    double? totalBatta,
    int? entriesCount,
  }) {
    return TeamSummary(
      teamId: teamId ?? this.teamId,
      totalCollection: totalCollection ?? this.totalCollection,
      totalCalendars: totalCalendars ?? this.totalCalendars,
      totalSold: totalSold ?? this.totalSold,
      totalExpense: totalExpense ?? this.totalExpense,
      totalBatta: totalBatta ?? this.totalBatta,
      entriesCount: entriesCount ?? this.entriesCount,
    );
  }
}
