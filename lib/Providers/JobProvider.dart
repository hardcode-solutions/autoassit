import 'dart:convert';

import 'package:autoassit/Controllers/ApiServices/variables.dart';
import 'package:autoassit/Models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:autoassit/Models/jobModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class JobProvider with ChangeNotifier {

  Job _jobModel;
  List<Job> _jobList = [];
  List<Job> _jobListFinished = [];

  // ignore: unnecessary_getters_setters
  Job get jobModel => _jobModel;

  List<Job> get listJobs => _jobList;
  List<Job> get listJobsFinished => _jobListFinished;

  // ignore: unnecessary_getters_setters
  set jobModel(Job value) {
    _jobModel = value;
  }

  

  Future<List<Job>> startGetJobs() async {
    _jobList = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {
        "token": initializeToken.getString("authtoken")
      };

      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
      
     String _url = "${URLS.BASE_URL}/job/getOngoingJobs";
    return http.post(_url,body: jsonEncode(body),headers: requestHeaders).then((res) async {
      print("getting jobssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
        List data = convertedData;

        _jobList = data.map((item) => Job.fromJson(item)).toList();

         
      notifyListeners();
      return _jobList;
    }).catchError((onError){
      print(onError);
    });
  }

   void updateTaskCountAndJobtot(String taskCount, String jobTot) {
   _jobModel.taskCount = taskCount;
   _jobModel.total = jobTot;
   print("job tot is ${_jobModel.total}");
    notifyListeners();
  }

   void updateComTaskCount(String taskCount) {
   _jobModel.completeTaskCount = taskCount;
   print("job tot is ${_jobModel.completeTaskCount}");
    notifyListeners();
  }

  Future<List<Job>> startGetFinishedJobs() async {
    _jobListFinished = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {
        "token": initializeToken.getString("authtoken")
      };

      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
      
     String _url = "${URLS.BASE_URL}/job/getFinishedJobs";
    return http.post(_url,body: jsonEncode(body),headers: requestHeaders).then((res) async {
      print("getting finished jobssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
        List data = convertedData;

        _jobListFinished = data.map((item) => Job.fromJson(item)).toList();
        


      notifyListeners();
      return _jobListFinished;
    }).catchError((onError){
      print(onError);
    });
  }


}