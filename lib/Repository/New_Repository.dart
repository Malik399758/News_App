import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:news_app/Models/CategoriesModel.dart';
import 'package:news_app/Models/NewsModel.dart';
class NewRepository{

  Future<NewsModel> getnewsapi (String channelName) async {
    String Url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=cc03415c9718497bbd184cdf98b057bd';
    final response = await http.get(Uri.parse(Url));
    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesModel> getcategoriesapi (String category) async {
    String Url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=cc03415c9718497bbd184cdf98b057bd';
    final response = await http.get(Uri.parse(Url));
    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesModel.fromJson(body);
    }
    throw Exception('Error');
  }
}