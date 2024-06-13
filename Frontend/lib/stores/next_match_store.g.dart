// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_match_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NextMatchStore on _NextMatchStore, Store {
  late final _$nextMatchAtom =
      Atom(name: '_NextMatchStore.nextMatch', context: context);

  @override
  MatchModel? get nextMatch {
    _$nextMatchAtom.reportRead();
    return super.nextMatch;
  }

  @override
  set nextMatch(MatchModel? value) {
    _$nextMatchAtom.reportWrite(value, super.nextMatch, () {
      super.nextMatch = value;
    });
  }

  late final _$nextMatchErrorAtom =
      Atom(name: '_NextMatchStore.nextMatchError', context: context);

  @override
  String? get nextMatchError {
    _$nextMatchErrorAtom.reportRead();
    return super.nextMatchError;
  }

  @override
  set nextMatchError(String? value) {
    _$nextMatchErrorAtom.reportWrite(value, super.nextMatchError, () {
      super.nextMatchError = value;
    });
  }

  late final _$loadNextMatchAsyncAction =
      AsyncAction('_NextMatchStore.loadNextMatch', context: context);

  @override
  Future<void> loadNextMatch(String? userId) {
    return _$loadNextMatchAsyncAction.run(() => super.loadNextMatch(userId));
  }

  @override
  String toString() {
    return '''
nextMatch: ${nextMatch},
nextMatchError: ${nextMatchError}
    ''';
  }
}
