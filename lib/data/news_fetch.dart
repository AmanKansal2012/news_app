import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/config/api_key.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/strings.dart';

class NewsFetch extends ChangeNotifier {

  Future<ArticleModel> getNews(String q,{String country="in"}) async {
    try {
      isLoading = !searching;
      final queryParameters = {'country': country, 'apiKey': apiKey, 'q': q};
      final response = await http.get(
        Uri.https(url, "/v2/top-headlines", queryParameters),
      );
      final responseData=json.decode(response.body);
      if (response.statusCode != 200&&responseData["status"]=="error") {
        isLoading = false;
        throw const HttpException('Something went wrong!');
      }
      isLoading = false;
      return articleModelFromJson(response.body);
    } catch (error, stack) {
      isLoading = false;
      print(error);
    throw error;
  }
  }


  bool loading = false;
  bool get isLoading => loading;
  set isLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool searching = false;
  bool get isSearching => searching;
  set isSearching(bool value) {
    searching = value;
    notifyListeners();
  }

  bool connected = true;
  bool get isConnected => connected;
  set isConnected(bool value) {
    connected = value;
    notifyListeners();
  }

  bool oldest = false;
  bool get isOldest => oldest;
  set isOldest(bool value) {
    oldest = value;
    notifyListeners();
  }

  String country = "India";
  String get selCountry => country;
  set selCountry(String value) {
    country = value;
    notifyListeners();
  }
}
