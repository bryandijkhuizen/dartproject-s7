// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_members_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClubMembersStore on _ClubMembersStore, Store {
  late final _$membersAtom =
      Atom(name: '_ClubMembersStore.members', context: context);

  @override
  ObservableList<Member> get members {
    _$membersAtom.reportRead();
    return super.members;
  }

  @override
  set members(ObservableList<Member> value) {
    _$membersAtom.reportWrite(value, super.members, () {
      super.members = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ClubMembersStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchMembersAsyncAction =
      AsyncAction('_ClubMembersStore.fetchMembers', context: context);

  @override
  Future<dynamic> fetchMembers() {
    return _$fetchMembersAsyncAction.run(() => super.fetchMembers());
  }

  @override
  String toString() {
    return '''
members: ${members},
isLoading: ${isLoading}
    ''';
  }
}
