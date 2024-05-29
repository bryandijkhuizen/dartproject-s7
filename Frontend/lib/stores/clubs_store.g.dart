// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClubsStore on _ClubsStore, Store {
  late final _$clubsAtom = Atom(name: '_ClubsStore.clubs', context: context);

  @override
  List<Club> get clubs {
    _$clubsAtom.reportRead();
    return super.clubs;
  }

  @override
  set clubs(List<Club> value) {
    _$clubsAtom.reportWrite(value, super.clubs, () {
      super.clubs = value;
    });
  }

  late final _$queryResultsAtom =
      Atom(name: '_ClubsStore.queryResults', context: context);

  @override
  int get queryResults {
    _$queryResultsAtom.reportRead();
    return super.queryResults;
  }

  @override
  set queryResults(int value) {
    _$queryResultsAtom.reportWrite(value, super.queryResults, () {
      super.queryResults = value;
    });
  }

  late final _$loadingAssignedClubsAtom =
      Atom(name: '_ClubsStore.loadingAssignedClubs', context: context);

  @override
  bool get loadingAssignedClubs {
    _$loadingAssignedClubsAtom.reportRead();
    return super.loadingAssignedClubs;
  }

  @override
  set loadingAssignedClubs(bool value) {
    _$loadingAssignedClubsAtom.reportWrite(value, super.loadingAssignedClubs,
        () {
      super.loadingAssignedClubs = value;
    });
  }

  late final _$assignedClubsAtom =
      Atom(name: '_ClubsStore.assignedClubs', context: context);

  @override
  List<Club> get assignedClubs {
    _$assignedClubsAtom.reportRead();
    return super.assignedClubs;
  }

  @override
  set assignedClubs(List<Club> value) {
    _$assignedClubsAtom.reportWrite(value, super.assignedClubs, () {
      super.assignedClubs = value;
    });
  }

  late final _$_fetchClubsPageAsyncAction =
      AsyncAction('_ClubsStore._fetchClubsPage', context: context);

  @override
  Future<void> _fetchClubsPage(int page, [String searchPrompt = '']) {
    return _$_fetchClubsPageAsyncAction
        .run(() => super._fetchClubsPage(page, searchPrompt));
  }

  late final _$fetchAsyncAction =
      AsyncAction('_ClubsStore.fetch', context: context);

  @override
  Future<void> fetch(int page, [String searchPrompt = '']) {
    return _$fetchAsyncAction.run(() => super.fetch(page, searchPrompt));
  }

  late final _$fetchUserClubsAsyncAction =
      AsyncAction('_ClubsStore.fetchUserClubs', context: context);

  @override
  Future<void> fetchUserClubs() {
    return _$fetchUserClubsAsyncAction.run(() => super.fetchUserClubs());
  }

  @override
  String toString() {
    return '''
clubs: ${clubs},
queryResults: ${queryResults},
loadingAssignedClubs: ${loadingAssignedClubs},
assignedClubs: ${assignedClubs}
    ''';
  }
}
