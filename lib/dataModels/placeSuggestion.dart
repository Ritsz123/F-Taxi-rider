class PlaceSuggestion {
  String placeId;
  String mainText;
  String secondaryText;

  PlaceSuggestion({
    required this.mainText,
    required this.placeId,
    required this.secondaryText,
  });

  static PlaceSuggestion fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      mainText: json['structured_formatting']['main_text'],
      placeId: json['place_id'],
      secondaryText: json['structured_formatting']['secondary_text'],
    );
  }
}
