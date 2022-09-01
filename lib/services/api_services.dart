import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:search_book_flutter_demo/constant/size_config.dart';
import 'package:search_book_flutter_demo/constant/string_config.dart';
import 'package:search_book_flutter_demo/model/SearchBox.dart';

abstract class ApiProvider {
  Future<List<SearchBox>> fetchSearchIdList(int index);
}

class SearchService extends ApiProvider {
  @override
  Future<List<SearchBox>> fetchSearchIdList(int index) async {
    var response = await http.get(Uri.parse(apiSearchUrl(index)));
    List<SearchBox> responseBody = [];
    if (response.statusCode == statue200) {
      responseBody.add(SearchBox.fromJson(json.decode(response.body)));
      return responseBody;
    } else {
      throw Exception(errorString);
    }
  }
}
