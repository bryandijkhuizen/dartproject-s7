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

  @override
  String toString() {
    return '''
clubs: ${clubs}
    ''';
  }
}
