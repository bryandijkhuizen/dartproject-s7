// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClubsStore on _ClubsStore, Store {
  late final _$loadingAtom =
      Atom(name: '_ClubsStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
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

  late final _$fetchUserClubsAsyncAction =
      AsyncAction('_ClubsStore.fetchUserClubs', context: context);

  @override
  Future<void> fetchUserClubs() {
    return _$fetchUserClubsAsyncAction.run(() => super.fetchUserClubs());
  }

  @override
  String toString() {
    return '''
loading: ${loading},
assignedClubs: ${assignedClubs}
    ''';
  }
}
