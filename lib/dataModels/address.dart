class Address {
  String placeName;
  double latitude;
  double longitude;
  String? formattedPlaceAddress;
  String? placeID;

  Address({
    required this.placeName,
    required this.latitude,
    required this.longitude,
    this.placeID,
    this.formattedPlaceAddress,
  });

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      placeName: json['result']['name'],
      latitude: json['result']['geometry']['location']['lat'],
      longitude: json['result']['geometry']['location']['lng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'latitude': latitude,
      'longitude': longitude,
      'formattedPlaceAddress' : formattedPlaceAddress,
      'placeId': placeID
    };
  }
}
