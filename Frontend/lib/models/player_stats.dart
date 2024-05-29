class PlayerStats {
  final int setsWon;
  final int legsWonInCurrentSet;
  final double averageScore;
  final double firstNineAverage;
  final double averagePerDart;
  final String checkouts;

  PlayerStats({
    required this.setsWon,
    required this.legsWonInCurrentSet,
    required this.averageScore,
    required this.firstNineAverage,
    required this.averagePerDart,
    required this.checkouts,
  });
}
