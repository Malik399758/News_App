import 'package:news_app/Models/CategoriesModel.dart';
import 'package:news_app/Models/NewsModel.dart';
import 'package:news_app/Repository/New_Repository.dart';

class NewsViewModel{
  final _rep = NewRepository();
  Future<NewsModel> getnewsapi(String channelName) async {
  final response = await _rep.getnewsapi(channelName);
  return response;
  }

  Future<CategoriesModel> getcategoriesapi(String category) async {
    final response = await _rep.getcategoriesapi(category);
    return response;
  }
}