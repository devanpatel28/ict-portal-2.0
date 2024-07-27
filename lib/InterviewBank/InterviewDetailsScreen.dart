import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'InterviewBankModel.dart';

class InterviewDetailScreen extends StatefulWidget {
  @override
  State<InterviewDetailScreen> createState() => _InterviewDetailScreenState();
}

class _InterviewDetailScreenState extends State<InterviewDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the interview data passed via Get.to
    final Interview interview = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Interview Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.circle_notifications_outlined),
            onPressed: (){_searchGoogle();},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${interview.id}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 10),
              Text('Company: ${interview.title}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Date: ${interview.date}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Package: ${interview.pack} LPA',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Category: ${interview.category}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Divider(),
              Divider(),
              SelectionArea(
                child: HtmlWidget(
                  interview.disc,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _searchGoogle() async {
    ClipboardData? clipboardContent = await Clipboard.getData(
        Clipboard.kTextPlain);
    final searchQuery = clipboardContent?.text ?? '';
    if (searchQuery.isNotEmpty) {
      final encodedQuery = Uri.encodeFull(searchQuery);
      final url = 'https://www.google.com/search?q=$encodedQuery';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    } else {
      print('No text found in clipboard');
    }
  }
}