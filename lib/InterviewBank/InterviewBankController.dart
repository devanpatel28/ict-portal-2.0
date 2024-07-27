import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ict_mu/API/api.dart';
import 'InterviewBankModel.dart';


class InterviewBankController extends GetxController  {

  List<Interview> InterviewList = [];

  Future<List<Interview>?> fetchInterviewData() async {
    try {
      final response = await http.get(
        Uri.parse(fetchAllInterview),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body); // Parse as List<dynamic>
        print("$responseData Interview data obtained");
        InterviewList = responseData.map((item) => Interview.fromJson(item)).toList(); // Map to UserTransaction objects
        return InterviewList;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
