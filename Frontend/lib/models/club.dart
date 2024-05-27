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

  factory Club.fromJson(Map<String, dynamic> dataMap) {
    return Club(
      id: dataMap['id'],
      name: dataMap['name']?.toString() ?? '',
      address: dataMap['address']?.toString() ?? '',
      postalCode: dataMap['postal_code']?.toString() ?? '',
      city: dataMap['city']?.toString() ?? '',
      ownerID: dataMap['owner_id']?.toString(),
      bannerImageURL: dataMap['banner_image_url']?.toString() ?? '',
    );
  }
}
