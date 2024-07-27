import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu/InterviewBank/InterviewBankController.dart';
import 'InterviewBankModel.dart';
import 'InterviewDetailsScreen.dart'; // Import the detail screen

class InterviewBankscreen extends StatefulWidget {
  const InterviewBankscreen({super.key});

  @override
  State<InterviewBankscreen> createState() => _InterviewBankscreenState();
}

class _InterviewBankscreenState extends State<InterviewBankscreen> {
  InterviewBankController interviewCTR = Get.put(InterviewBankController());
  List<Interview> interviewList = [];
  List<Interview> filteredInterviewList = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInterviewData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> getInterviewData() async {
    setState(() => isLoading = true);
    try {
      interviewList = (await interviewCTR.fetchInterviewData()) ?? [];
      filteredInterviewList = interviewList;
      if (interviewList.isEmpty) {
        print("No Data found.");
      }
    } catch (error) {
      print("Error fetching Data: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged() {
    String searchQuery = searchController.text.toLowerCase();
    setState(() {
      filteredInterviewList = interviewList.where((interview) {
        return interview.title.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search by Company name",
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Column(
                  children: filteredInterviewList.map((interview) {
                    return InkWell(
                      onTap: (){Get.to(() => InterviewDetailScreen(), arguments: interview);},
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          elevation: 4,
                          color: Colors.blue[50],
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${interview.id} . ${interview.title}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                Text(
                                  'Date: ${interview.date}',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                Text('Package: ${interview.pack} LPA'),
                                Text('Category: ${interview.category}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
