import 'package:darts_application/models/club_post.dart';
import 'package:darts_application/services/post_service.dart';
import 'package:mobx/mobx.dart';

part 'news_feed_store.g.dart';

class NewsFeedStore = _NewsFeedStore with _$NewsFeedStore;

abstract class _NewsFeedStore with Store {
  final PostService _postService;

  @observable
  bool loading = true;

  @observable
  List<ClubPost> _posts = [];

  @computed
  List<ClubPost> get posts => _posts;

  @observable
  int _limit = 3;

  @observable
  int _offset = 0;

  @observable
  List<int> _clubIds = [];

  @computed
  int get limit => _limit;

  @computed
  int get offset => _offset;

  @computed
  List<int> get clubIds => _clubIds;

  _NewsFeedStore(this._postService) {
    _init();
  }

  Future<void> _init() async {
    await _loadClubPosts();
    loading = false;
  }

  @action
  Future<void> _loadClubPosts({bool append = false}) async {
    final posts = await _postService.getLastClubPosts(
      limit: _limit,
      offset: _offset,
      clubIds: _clubIds,
    );
    if (append) {
      _posts = [..._posts, ...posts];
    } else {
      _posts = posts;
    }
  }

  @action
  Future<void> reloadPosts() async {
    loading = true;
    _offset = 0; // Reset offset for fresh reload
    await _loadClubPosts();
    loading = false;
  }

  @action
  Future<void> loadMorePosts() async {
    _offset += _limit;
    await _loadClubPosts(append: true);
  }

  set limit(int newLimit) {
    _limit = newLimit;
    reloadPosts();
  }

  set offset(int newOffset) {
    _offset = newOffset;
    reloadPosts();
  }

  set clubIds(List<int> newClubIds) {
    _clubIds = newClubIds;
    reloadPosts();
  }
}
