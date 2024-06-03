class Avatar {
  final int id;
  final String url;

  Avatar({required this.id, required this.url});

  Avatar.fromJSON(Map<String, dynamic> dataMap)
      : id = dataMap['id'],
        url = dataMap['url'];
}
