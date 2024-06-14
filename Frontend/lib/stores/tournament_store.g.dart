// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TournamentStore on _TournamentStore, Store {
  late final _$initializedAtom =
      Atom(name: '_TournamentStore.initialized', context: context);

  @override
  bool get initialized {
    _$initializedAtom.reportRead();
    return super.initialized;
  }

  @override
  set initialized(bool value) {
    _$initializedAtom.reportWrite(value, super.initialized, () {
      super.initialized = value;
    });
  }

  late final _$unselectedPlayersAtom =
      Atom(name: '_TournamentStore.unselectedPlayers', context: context);

  @override
  List<PlayerModel> get unselectedPlayers {
    _$unselectedPlayersAtom.reportRead();
    return super.unselectedPlayers;
  }

  @override
  set unselectedPlayers(List<PlayerModel> value) {
    _$unselectedPlayersAtom.reportWrite(value, super.unselectedPlayers, () {
      super.unselectedPlayers = value;
    });
  }

  @override
  String toString() {
    return '''
initialized: ${initialized},
unselectedPlayers: ${unselectedPlayers}
    ''';
  }
}
