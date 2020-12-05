class PlaceSuggestion {
  String placeId;
  String mainText;
  String secondaryText;

  PlaceSuggestion({
    this.mainText,
    this.placeId,
    this.secondaryText,
  });

  PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
}
