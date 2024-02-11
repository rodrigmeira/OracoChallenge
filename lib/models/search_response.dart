class SearchResponseModel {
  List<SearchResultModel> results;

  SearchResponseModel({required this.results});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      results: List<SearchResultModel>.from(
          json['results'].map((result) => SearchResultModel.fromJson(result))),
    );
  }
}

class SearchResultModel {
  String trackName;
  String artistName;

  SearchResultModel({required this.trackName, required this.artistName});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      trackName: json['trackName'] ?? "",
      artistName: json['artistName'] ?? "",
    );
  }

  get artworkUrl => null;
}
