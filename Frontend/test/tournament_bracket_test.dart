import 'package:darts_application/models/player.dart';
import 'package:darts_application/models/tournament.dart';
import 'package:darts_application/models/match.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';

// Mock classes for dependencies
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late TournamentModel tournament;
  late List<PlayerModel> players;
  late TournamentStore tournamentStore;

  List<PlayerModel> getPlayers() {
    List<PlayerModel> players = [];
    for (var i = 0; i < 16; i++) {
      players.add(
        PlayerModel.placeholderPlayer(
          id: i.toString(),
          lastName: "Player $i",
        ),
      );
    }

    return players;
  }

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    tournament = TournamentModel(
      id: null,
      name: "New tournament",
      location: "Wirdumerdijk 7A, 8911 CB Leeuwarden",
      startTime: DateTime.parse("2024-06-14 12:00:00+00"),
      startingMethod: StartingMethod.bulloff,
    );
    players = getPlayers();

    tournamentStore = TournamentStore(
      mockSupabaseClient,
      tournament,
      players,
      3,
      5,
      501,
    );
  });

  group("CreateRounds", () {
    test('Generates correct structure', () {
      final rounds = tournamentStore.createRounds(players, 1);
      expect(rounds.length, equals(4));
      expect(rounds[1]!.length, equals(8));
      expect(rounds[2]!.length, equals(4));
      expect(rounds[3]!.length, equals(2));
      expect(rounds[4]!.length, equals(1));
    });

    test("Create correct match", () {
      final rounds = tournamentStore.createRounds(players, 1);
      expect(rounds[1]![0].location,
          equals("Wirdumerdijk 7A, 8911 CB Leeuwarden"));
      expect(rounds[1]![0].legTarget, equals(5));
      expect(rounds[1]![0].setTarget, equals(3));
      expect(rounds[1]![0].startingScore, equals(501));
    });
  });

  test('UnselectPlayer works correctly', () {
    tournamentStore.rounds[1]![0].player1Id = players[0].id;
    tournamentStore.rounds[1]![0].player1LastName = players[0].lastName;
    tournamentStore.unselectedPlayers.clear();

    tournamentStore.unselectPlayer(players[0], 1, 0, true);

    expect(tournamentStore.rounds[1]![0].player1Id, "");
    expect(tournamentStore.rounds[1]![0].player1LastName, "");
    expect(tournamentStore.unselectedPlayers.contains(players[0]), true);
  });

  test('SelectPlayer works correctly', () {
    tournamentStore.rounds[1]![0].player1Id = players[1].id;
    tournamentStore.rounds[1]![0].player1LastName = players[1].lastName;
    // tournamentStore.unselectedPlayers.clear();

    tournamentStore.selectPlayer(players[0], 1, 0, true);

    expect(tournamentStore.rounds[1]![0].player1Id, "0");
    expect(tournamentStore.rounds[1]![0].player1LastName, "Player 0");
    expect(tournamentStore.unselectedPlayers.contains(players[0]), false);
  });
}
