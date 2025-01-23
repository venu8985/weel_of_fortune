import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:spin/models/departmentModels/departmentModel.dart';
import 'package:spin/models/employeeModel/employeeModel.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class Homecontroller extends GetxController {
  RxList<String> departmentOptions = <String>[].obs;
  RxString dropdownValue = 'Choose Department'.obs;
  RxList<EmplyeeData> employeeList = <EmplyeeData>[].obs;
  RxBool isLoadingEmployees = false.obs;
  var selectedEmpName = "".obs;
  var selectedEmpId = "".obs;
  var selectedEmpImg = "".obs;
  RxString departmentCode = "".obs;
  void setValue(value) {
    selectedEmpId.value = employeeList[value].empId.toString();
    selectedEmpName.value = employeeList[value].empName.toString();
    selectedEmpImg.value = employeeList[value].image.toString();
    print('selected image is ${selectedEmpImg.value}');
  }

  Future<void> fetchDepartments(context) async {
    try {
      Uri url = Uri.parse("https://servey.tech/api/department");
      http.Response response = await http.get(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['data'] != null) {
          List<dynamic> departments = jsonData['data'];

          departmentOptions.value = departments.map((item) {
            var department = Data.fromJson(item);
            return "${department.code ?? 'Unknown'} - ${department.name ?? 'Unknown'}";
          }).toList();
          departmentOptions.insert(0, "Choose Department");

          print(departmentOptions);
        }
      } else {
        departmentOptions.clear();
        departmentOptions.insert(0, "Choose Department");
        toastification.show(
          context: context,
          title: 'Error',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          description: response.reasonPhrase.toString(),
          autoCloseDuration: const Duration(seconds: 6),
        );
      }
    } catch (e) {
      departmentOptions.clear();
      departmentOptions.insert(0, "Choose Department");
      toastification.show(
        context: context,
        title: 'Error',
        description: e.toString(),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        autoCloseDuration: const Duration(seconds: 6),
      );
      print("Error fetching departments: $e");
    }
  }

  Future<void> fetchEmployees(context, String departmentCode) async {
    isLoadingEmployees.value = true;
    employeeList.clear();
    print(departmentCode);
    try {
      Uri url = Uri.parse(
          "https://servey.tech/api/employee/${departmentCode.trim()}");
      http.Response response =
          await http.get(url, headers: {"Access-Control-Allow-Origin": "*"});

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['data'] != null) {
          employeeList.value = jsonData['data']
              .map<EmplyeeData>((item) => EmplyeeData.fromJson(item))
              .where((employee) => employee.status != 0)
              .toList();
          print(employeeList);
        } else {
          employeeList.clear();
        }
      } else {
        print("Failed to load employees");
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: 'Error',
        description: e.toString(),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        autoCloseDuration: const Duration(seconds: 6),
      );
      print("Error fetching employees: $e");
    } finally {
      isLoadingEmployees.value = false;
    }
  }

  Future<void> deleteEmployee(context, String employeeCode) async {
    isLoadingEmployees.value = true;

    print(employeeCode);
    try {
      Uri url = Uri.parse(
          "https://servey.tech/api/remove-employee/${employeeCode.trim()}");
      http.Response response = await http.get(url);
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonData['status'] == true) {
          fetchEmployees(context, departmentCode.value);
        } else {
          employeeList.clear();
          toastification.show(
            context: context,
            title: 'Error',
            description: jsonData['message'].toString(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            autoCloseDuration: const Duration(seconds: 6),
          );
        }
      } else {
        toastification.show(
          context: context,
          title: 'Error',
          description: response.reasonPhrase ?? jsonData['message'].toString(),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          autoCloseDuration: const Duration(seconds: 6),
        );
        print("Failed to load employees");
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: 'Error',
        description: e.toString(),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        autoCloseDuration: const Duration(seconds: 6),
      );
      print("Error fetching employees: $e");
    } finally {
      isLoadingEmployees.value = false;
    }
  }
}
