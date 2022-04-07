import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../res/common_functions.dart';
import '../../res/strings.dart';
import '../models/api_model.dart';
import '../models/exceptions.dart';

abstract class NetworkArticlesRepository {
  Future<ApiResultModel> getArticles(int page, int itemsPerPage);
}

class NetworkArticlesRepositoryImpl implements NetworkArticlesRepository {
  @override
  Future<ApiResultModel> getArticles(int page, int itemsPerPage) async {
    printData('sent requset');
    var response = await http.get(Uri.parse(AppStrings.url +
        "?country=sa&page=$page&pageSize=$itemsPerPage&apiKey=${AppStrings.apiKey}#"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      ApiResultModel result = ApiResultModel.fromJson(data);
      return result;
    } else {
      throw CustomNetworkException(
          massage:
              'Response Failed, statues code = ${response.statusCode} ,body = ${response.body} ');
    }
  }
}
