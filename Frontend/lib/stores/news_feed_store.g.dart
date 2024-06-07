// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsFeedStore on _NewsFeedStore, Store {
  Computed<List<ClubPost>>? _$postsComputed;

  @override
  List<ClubPost> get posts =>
      (_$postsComputed ??= Computed<List<ClubPost>>(() => super.posts,
              name: '_NewsFeedStore.posts'))
          .value;
  Computed<int>? _$limitComputed;

  @override
  int get limit => (_$limitComputed ??=
          Computed<int>(() => super.limit, name: '_NewsFeedStore.limit'))
      .value;
  Computed<int>? _$offsetComputed;

  @override
  int get offset => (_$offsetComputed ??=
          Computed<int>(() => super.offset, name: '_NewsFeedStore.offset'))
      .value;
  Computed<List<int>>? _$clubIdsComputed;

  @override
  List<int> get clubIds =>
      (_$clubIdsComputed ??= Computed<List<int>>(() => super.clubIds,
              name: '_NewsFeedStore.clubIds'))
          .value;

  late final _$loadingAtom =
      Atom(name: '_NewsFeedStore.loading', context: context);

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

  late final _$_postsAtom =
      Atom(name: '_NewsFeedStore._posts', context: context);

  @override
  List<ClubPost> get _posts {
    _$_postsAtom.reportRead();
    return super._posts;
  }

  @override
  set _posts(List<ClubPost> value) {
    _$_postsAtom.reportWrite(value, super._posts, () {
      super._posts = value;
    });
  }

  late final _$_limitAtom =
      Atom(name: '_NewsFeedStore._limit', context: context);

  @override
  int get _limit {
    _$_limitAtom.reportRead();
    return super._limit;
  }

  @override
  set _limit(int value) {
    _$_limitAtom.reportWrite(value, super._limit, () {
      super._limit = value;
    });
  }

  late final _$_offsetAtom =
      Atom(name: '_NewsFeedStore._offset', context: context);

  @override
  int get _offset {
    _$_offsetAtom.reportRead();
    return super._offset;
  }

  @override
  set _offset(int value) {
    _$_offsetAtom.reportWrite(value, super._offset, () {
      super._offset = value;
    });
  }

  late final _$_clubIdsAtom =
      Atom(name: '_NewsFeedStore._clubIds', context: context);

  @override
  List<int> get _clubIds {
    _$_clubIdsAtom.reportRead();
    return super._clubIds;
  }

  @override
  set _clubIds(List<int> value) {
    _$_clubIdsAtom.reportWrite(value, super._clubIds, () {
      super._clubIds = value;
    });
  }

  late final _$_loadClubPostsAsyncAction =
      AsyncAction('_NewsFeedStore._loadClubPosts', context: context);

  @override
  Future<void> _loadClubPosts({bool append = false}) {
    return _$_loadClubPostsAsyncAction
        .run(() => super._loadClubPosts(append: append));
  }

  late final _$reloadPostsAsyncAction =
      AsyncAction('_NewsFeedStore.reloadPosts', context: context);

  @override
  Future<void> reloadPosts() {
    return _$reloadPostsAsyncAction.run(() => super.reloadPosts());
  }

  late final _$loadMorePostsAsyncAction =
      AsyncAction('_NewsFeedStore.loadMorePosts', context: context);

  @override
  Future<void> loadMorePosts() {
    return _$loadMorePostsAsyncAction.run(() => super.loadMorePosts());
  }

  @override
  String toString() {
    return '''
loading: ${loading},
posts: ${posts},
limit: ${limit},
offset: ${offset},
clubIds: ${clubIds}
    ''';
  }
}
