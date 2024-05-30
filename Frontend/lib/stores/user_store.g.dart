// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  Computed<User?>? _$currentUserComputed;

  @override
  User? get currentUser =>
      (_$currentUserComputed ??= Computed<User?>(() => super.currentUser,
              name: '_UserStore.currentUser'))
          .value;
  Computed<Permissions>? _$permissionsComputed;

  @override
  Permissions get permissions =>
      (_$permissionsComputed ??= Computed<Permissions>(() => super.permissions,
              name: '_UserStore.permissions'))
          .value;

  late final _$currentSessionAtom =
      Atom(name: '_UserStore.currentSession', context: context);

  @override
  Session? get currentSession {
    _$currentSessionAtom.reportRead();
    return super.currentSession;
  }

  @override
  set currentSession(Session? value) {
    _$currentSessionAtom.reportWrite(value, super.currentSession, () {
      super.currentSession = value;
    });
  }

  @override
  String toString() {
    return '''
currentSession: ${currentSession},
currentUser: ${currentUser},
permissions: ${permissions}
    ''';
  }
}
