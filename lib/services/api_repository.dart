import '../model/SearchBox.dart';
import 'api_services.dart';

class ApiRepository {
  ///fetchSearchApi
  Future<List<SearchBox>> getSearchIdList(index) {
    return SearchService().fetchSearchIdList(index);
  }
}
