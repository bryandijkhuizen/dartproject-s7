// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClubUserStore on _ClubUserStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_ClubUserStore.isLoading', context: context);

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

  late final _$isMemberAtom =
      Atom(name: '_ClubUserStore.isMember', context: context);

  @override
  bool get isMember {
    _$isMemberAtom.reportRead();
    return super.isMember;
  }

  @override
  set isMember(bool value) {
    _$isMemberAtom.reportWrite(value, super.isMember, () {
      super.isMember = value;
    });
  }

  late final _$checkMembershipAsyncAction =
      AsyncAction('_ClubUserStore.checkMembership', context: context);

  @override
  Future<dynamic> checkMembership() {
    return _$checkMembershipAsyncAction.run(() => super.checkMembership());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isMember: ${isMember}
    ''';
  }
}
