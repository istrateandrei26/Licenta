class PlaceAutocompleteSuggestion {
  String description;
  String placeId;
  List<dynamic> matchedSubstrings;

  PlaceAutocompleteSuggestion({
    required this.description,
    required this.placeId,
    required this.matchedSubstrings,
  });

  factory PlaceAutocompleteSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteSuggestion(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
      matchedSubstrings: json['matched_substrings'] as List<dynamic>,
    );
  }
}