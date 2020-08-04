import 'dart:convert' as convert;
import 'dart:convert';

import 'package:autoassit/Controllers/ApiServices/Job_services/create_job_service.dart';
import 'package:autoassit/Controllers/ApiServices/variables.dart';
import 'package:autoassit/Models/jobModel.dart';
import 'package:autoassit/Models/userModel.dart';
import 'package:autoassit/Providers/AuthProvider.dart';
import 'package:autoassit/Providers/JobProvider.dart';
import 'package:autoassit/Screens/Jobs/Widgets/addTask_page.dart';
import 'package:autoassit/Screens/Jobs/Widgets/add_task_modelbox.dart';
import 'package:autoassit/Screens/Jobs/Widgets/change_task_page.dart';
import 'package:autoassit/Utils/jobCreatingLoader.dart';
import 'package:flutter/material.dart';
import 'package:autoassit/Screens/Jobs/Widgets/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'additems.dart';
import 'package:http/http.dart' as http;

class CreateJob extends StatefulWidget {
  final vnumber;
  final vehicle_name;
  final customer_name;
  final cusId;
  CreateJob(
      {Key key,
      this.vnumber,
      this.vehicle_name,
      this.customer_name,
      this.cusId})
      : super(key: key);

  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  String currentDate;
  int jobval;
  UserModel userModel;
  Job jobModel;
  bool isJobCreating = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDate = Utils.getDate();
    print(currentDate);
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    startCreateJobbbbbb();
    // jobModel = Provider.of<JobProvider>(context, listen: false).jobModel;
  }

  void updateInformation(Job jobb) {
    setState(() {
      jobModel.taskCount = jobb.taskCount;
      jobModel.total = jobb.total;
      jobModel.procerCharge = jobb.procerCharge;
      jobModel.labourCharge = jobb.labourCharge;
    });
    print(jobModel.total);
    startUpdateJobDetails(jobb.taskCount,jobb.total);
  }

  void startUpdateJobDetails(String taskCount,String total) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    final body = {
      '_id': jobModel.jobId,
      'taskCount': jobModel.taskCount,
      'total': jobModel.total,
      'procerCharge': jobModel.procerCharge,
      'labourCharge': jobModel.labourCharge
    };

    await http.post('${URLS.BASE_URL}/job/updateTaskCountAndTot',
        body: jsonEncode(body),headers: requestHeaders);
 
    Provider.of<JobProvider>(context, listen: false).updateTaskCountAndJobtot(taskCount, total);
    print("updateddddddddd ${jobModel.labourCharge}-----$total");
  }

  void startCreateJobbbbbb() async {
     SharedPreferences job = await SharedPreferences.getInstance();

    final body = {
      "jobNo": job.getString("jobno"),
      "date": DateTime.now().toString(),
      "vnumber": widget.vnumber,
      "vName": widget.vehicle_name,
      "cusId": widget.cusId,
      "cusName": widget.customer_name,
      "taskCount": "0",
      "procerCharge": "0",
      "labourCharge": "0",
      "total": "0",
      "status": "onGoing",
      "token": userModel.token
    };

    print(body);

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post('${URLS.BASE_URL}/job/newjob',
        body: jsonEncode(body), headers: requestHeaders);
    print("workingggggggggggg");
    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> res_data = jsonDecode(data);

    try {
      if (response.statusCode == 200) {
        // clearcontrollers();
        print("job created successfully !");
        setState(() {
          isJobCreating = false;
        });
        int no = int.parse(job.getString("jobno"));
        setState(() {
          no++;
        });
        job.setString("jobno", no.toString());
        print(job.getString("jobno"));
        jobModel = Job.fromJson(res_data);
        Provider.of<JobProvider>(context, listen: false).jobModel = jobModel;
        print("hutto");
         Provider.of<JobProvider>(context, listen: false).startGetJobs();
        // Dialogs.successDialog(context, "Done", "Job Created Successfully !");
      } else {
        // Dialogs.errorDialog(context, "F", "Something went wrong !");
        print("job coudlnt create !");
        setState(() {
          isJobCreating = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isJobCreating
          ? JobLoader()
          : Stack(children: <Widget>[
              Container(
                height: 25,
                color: Color(0xFFef5350),
              ),
              _mainContent(context),
            ]),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFFef5350),
        onPressed: () {
          print(jobModel.jobno);
        },
        label: Text('Create Invoice'),
        icon: Icon(Icons.receipt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 25,
        ),
        _jobDetails(),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: _buttons(),
        ),
        Expanded(
            child: Center(
          child: Text(
            "No Taks Added yet",
            style: TextStyle(fontSize: 30),
          ),
        )
            // AddJobTaskPage()
            )
      ],
    );
  }

  Widget _jobDetails() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Job NO ${jobModel.jobno}",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              _buildFields('Date - $currentDate'),
              _buildFields('Vehicle No - ${jobModel.vNumber}'),
              _buildFields('Vehicle Name - ${jobModel.vName}'),
              _buildFields('Customer Name - ${jobModel.cusName}'),
              _buildFields('Supervisor Name - ${userModel.userName}'),
              _buildFields('Service/Product Cost - Rs.${jobModel.procerCharge}0'),
              _buildFields('Labour Charge - Rs.${jobModel.labourCharge}0'), 
            ],
          ),
          Column(
            children: [
              Text(
                "${userModel.garageName}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(5.0),
                // height: MediaQuery.of(context).size.height / 13,
                // width: MediaQuery.of(context).size.width / 4.5,
                decoration: BoxDecoration(
                    color: Color(0xFF66BB6A),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Task Count",
                      style: TextStyle(color:Colors.white,fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${jobModel.taskCount}",
                      softWrap: true,
                      style: TextStyle(
                          color:Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Color(0xFFef5350),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Text(
                        "Rs.${jobModel.total}0",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color:Colors.white,
                          fontWeight: FontWeight.w800
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFields(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
    );
  }

  Widget _buttons() {
    return Row(children: <Widget>[
      Expanded(
        child: MaterialButton(
          color: Color(0xFFef5350),
          textColor: Colors.white,
          onPressed: () async {
            Job jobeka = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      child: AddTasksModel(
                        vnumber: widget.vnumber,
                        vehicle_name: widget.vehicle_name,
                        cusId: widget.cusId,
                        customer_name: widget.customer_name,
                        jobmodel: jobModel,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))));
                });
                print("issssssssssss ${jobeka.procerCharge}");
                print("issssssssssss ${jobeka.total}");
                updateInformation(jobeka);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(14.0),
          child: Text('Add Job Tasks'),
        ),
      ),
      SizedBox(
        width: 32,
      ),
      Expanded(
        child: MaterialButton(
          color: Colors.white,
          textColor: Color(0xFFef5350),
          onPressed: () async {
            SharedPreferences job = await SharedPreferences.getInstance();
            job.remove("jobno");
            print("cleared");
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFFef5350)),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(14.0),
          child: Text('Cancel job'),
        ),
      )
    ]);
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.settings), onPressed: () {}),
              IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
            ]));
  }
}
