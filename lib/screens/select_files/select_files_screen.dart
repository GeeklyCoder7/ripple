import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/viewmodels/permission_viewmodel.dart';

class SelectFilesScreen extends StatefulWidget {
  const SelectFilesScreen({super.key});

  @override
  State<SelectFilesScreen> createState() => _SelectFilesScreenState();
}

class _SelectFilesScreenState extends State<SelectFilesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Files'
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Documents',),
              Tab(text: 'Install Apk',),
              Tab(text: 'Media',),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              Center(child: Text('Documents content',),),
              Center(child: Text('Installed apps content',),),
              Center(child: Text('Media content',),),
            ],
          ),
        ),
      ),
    );
  }
}
