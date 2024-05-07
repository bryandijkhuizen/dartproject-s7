class Club {
  final String name;
  final String address;
  final String postalCode;
  final String city;
  final String ownerID;
  final String bannerImageURL;

  Club({
    required this.name,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.ownerID,
    required this.bannerImageURL,
  });

  Club.fromJSON(Map<String, dynamic> dataMap)
      : name = dataMap['name'],
        address = dataMap['address'],
        postalCode = dataMap['postal_code'],
        city = dataMap['city'],
        ownerID = dataMap['owner_id'],
        bannerImageURL = dataMap['banner_image_url'];
}
