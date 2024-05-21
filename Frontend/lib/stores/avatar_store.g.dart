// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AvatarStore on _AvatarStore, Store {
  late final _$initializedAtom =
      Atom(name: '_AvatarStore.initialized', context: context);

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

  late final _$avatarsAtom =
      Atom(name: '_AvatarStore.avatars', context: context);

  @override
  Iterable<Avatar> get avatars {
    _$avatarsAtom.reportRead();
    return super.avatars;
  }

  @override
  set avatars(Iterable<Avatar> value) {
    _$avatarsAtom.reportWrite(value, super.avatars, () {
      super.avatars = value;
    });
  }

  late final _$previewAvatarAtom =
      Atom(name: '_AvatarStore.previewAvatar', context: context);

  @override
  Avatar? get previewAvatar {
    _$previewAvatarAtom.reportRead();
    return super.previewAvatar;
  }

  @override
  set previewAvatar(Avatar? value) {
    _$previewAvatarAtom.reportWrite(value, super.previewAvatar, () {
      super.previewAvatar = value;
    });
  }

  late final _$saveAvatarAsyncAction =
      AsyncAction('_AvatarStore.saveAvatar', context: context);

  @override
  Future<SaveAvatarResult> saveAvatar() {
    return _$saveAvatarAsyncAction.run(() => super.saveAvatar());
  }

  late final _$_AvatarStoreActionController =
      ActionController(name: '_AvatarStore', context: context);

  @override
  dynamic changePreview(Avatar newAvatar) {
    final _$actionInfo = _$_AvatarStoreActionController.startAction(
        name: '_AvatarStore.changePreview');
    try {
      return super.changePreview(newAvatar);
    } finally {
      _$_AvatarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
initialized: ${initialized},
avatars: ${avatars},
previewAvatar: ${previewAvatar}
    ''';
  }
}
