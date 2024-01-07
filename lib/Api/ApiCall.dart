import 'package:intership_task/Api/ApiGet.dart';
import 'package:intership_task/Api/ApiModel.dart';

class NewsViewModel {

  final apiGet = ApiGet() ;
  Future<ApiModel> fetchHeadline ()async{
    final response = await apiGet.fetchData();
    return response ;

  }
}