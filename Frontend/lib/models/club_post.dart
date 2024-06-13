class ClubPost {
  final int id;
  final String title;
  final String? imageUrl;
  final String body;
  final int clubId;

  ClubPost({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.body,
    required this.clubId,
  });

  factory ClubPost.fromJson(Map<String, dynamic> dataMap) {
    return ClubPost(
        id: dataMap['id'],
        title: dataMap['title'].toString(),
        imageUrl: dataMap['image_url']?.toString() ?? '',
        body: dataMap['body'].toString(),
        clubId: dataMap['club_id']);
  }
}
