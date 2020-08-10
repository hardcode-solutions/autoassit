import 'package:autoassit/Models/vehicleModel.dart';
import 'package:autoassit/Providers/VehicleProvider.dart';
import 'package:autoassit/Screens/Jobs/Widgets/finished_jobList.dart';
import 'package:autoassit/Screens/Vehicle/Widgets/joblists_by_id.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobListByVehiId extends StatefulWidget {
  @override
  _JobListByVehiIdState createState() => _JobListByVehiIdState();
}

class _JobListByVehiIdState extends State<JobListByVehiId>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String state = "Followers";
  Vehicle vehicleModel;

  @override
  void initState() {
    super.initState();
    vehicleModel = Provider.of<VehicleProvider>(context, listen: false).vehicleModel;
    tabController = TabController(vsync: this, length: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomPadding: false, // this avoids the overflow error
        resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: _buildTopAppbar(context),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
              child: Container(
                  child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Center(child: _buildTabBar(context)),
            ),
            Flexible(
                  child: _buildTabView(context),
            ),
          ],
        ),
                ),
      ),
    );
  }

   Widget _buildTopAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.0),
      child: Container(
        color: Colors.transparent,
        // height: MediaQuery.of(context).size.height / 2,
        alignment: Alignment.center,
        child: _buildStack(context),
      ),
    );
  }

    Widget _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFF8E8CD8),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(75.0),
                  bottomRight: Radius.circular(75.0)),
            ),
          ),
        ),
        Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                    child: Image.asset(
                  "assets/images/jobrecords.png",
                  width: MediaQuery.of(context).size.height / 10.0,
                  height: MediaQuery.of(context).size.height / 10.0,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Center(
                    child: Text(
                      'Jobs List',
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontFamily: 'Montserrat',
                          fontSize: 25.0,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
        // Positioned(
        //     left: 20,
        //     top: MediaQuery.of(context).size.height / 5,
        //     child: Column(children: <Widget>[_buildSearchBar(context)]))
      ],
    );
  }

    Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 30.0),
      width: MediaQuery.of(context).size.width / 1.4,
      height: 45,
      // margin: EdgeInsets.only(top: 32),
      padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: TextField(
        keyboardType: TextInputType.text,
        // controller: _search,
        onTap: () {
        //   setState(() {
        //     isSearchFocused = true;
        //   });
        // },
        // onChanged: (string) {
        //   _debouncer.run(() {
        //     setState(() {
        //       filteredVehicles = vehicle
        //           .where((u) =>
        //               (u.vNumber.toLowerCase().contains(string.toLowerCase())))
        //           .toList();
        //     });
        //   });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 30,
          ),
          hintText: 'search',
        ),
      ),
    );
  }

  Widget _buildTabView(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        SingleChildScrollView(child: OngoingJobsContent()),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.transparent,
      labelColor: Color(0xFFFF6038),
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      unselectedLabelColor: Color(0xFF020433),
      isScrollable: true,
      tabs: <Widget>[
        getTabs("${vehicleModel.make} ${vehicleModel.model}'s job History"),
      ],
    );
  }

  getTabs(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}

class OngoingJobsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: JoblistWidget()
    );
  }
}

class FinishedJobContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: FinishedJobList()
    );
  }
}
