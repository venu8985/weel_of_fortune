import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:spin/models/homeModels/homeModel.dart';
import 'package:http/http.dart' as http;

class Homecontroller extends GetxController {
  String url = "https://www.themealdb.com/api/json/v1/1/filter.php?a=Indian";
  RxList<Homemodel> ideas = <Homemodel>[].obs;
  var selectedIdea = "".obs;
  var selectedImg = "".obs;
  void setValue(value) {
    selectedIdea.value = ideas[value].meal.toString();
    selectedImg.value = ideas[value].img;
  }

  Future<void> getLunchIdeas() async {
    http.Response response;

    Uri uri = Uri.parse(url);
    response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['meals'] != null) {
        List<dynamic> meals = jsonData['meals'];

        ideas.value = meals.map((json) => Homemodel.fromJson(json)).toList();
      }
    }
  }
}
