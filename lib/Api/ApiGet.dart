import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as htpps;
import 'package:intership_task/Api/ApiCall.dart';
import 'package:intership_task/Api/ApiModel.dart';

class ApiGet {
  Future<ApiModel> fetchData() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=cddbf35d643f4029bd0badc611e1d3c4";
    final response = await htpps.get(Uri.parse(url));

   // print(response.body);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return ApiModel.fromJson(body);
    }
    throw Exception( " error ");

  }
}
