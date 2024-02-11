// lib/services/song_api.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/search_response.dart';

class SongAPI {
  Future<SearchResponseModel> getSearchMusics(String term) async {
    final dio = Dio();
    final res =
        await dio.get('https://itunes.apple.com/search', queryParameters: {
      'term': term.replaceAll(RegExp(r'\s+'), ' ').replaceAll(' ', '+'),
      'media': 'music'
    });
    dio.close();

    SearchResponseModel response =
        SearchResponseModel.fromJson(jsonDecode(res.data));
    return response;
  }
}
