class Club {
  final int id;
  final String name;
  final String address;
  final String postalCode;
  final String city;
  final String? ownerID;
  final String bannerImageURL;

  Club({
    required this.id,
    required this.name,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.ownerID,
    required this.bannerImageURL,
  });

  Club.fromJson(Map<String, dynamic> dataMap)
      : id = dataMap['id'],
        name = dataMap['name'],
        address = dataMap['address'],
        postalCode = dataMap['postal_code'],
        city = dataMap['city'],
        ownerID = dataMap['owner_id'],
        bannerImageURL = dataMap['banner_image_url'];
}
