import 'package:flutter/material.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/services/select_files_service.dart';
import 'package:ripple/widgets/file_system_item_tile.dart';

import '../../models/file_item.dart';
import '../../models/file_system_item.dart';
import '../../models/folder_item.dart';

class SelectFilesScreen extends StatefulWidget {
  const SelectFilesScreen({super.key});

  @override
  State<SelectFilesScreen> createState() => _SelectFilesScreenState();
}

class _SelectFilesScreenState extends State<SelectFilesScreen> {
  late Future<List<FileSystemItem>> _filesList;
  @override
  void initState() {
    super.initState();
    _filesList = SelectFilesService().getFolderContents(AppConstants.testingPath);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Files'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Documents'),
              Tab(text: 'Install Apk'),
              Tab(text: 'Media'),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              FutureBuilder<List<FileSystemItem>>(
                future: _filesList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No items found'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FileSystemItemTile(item: snapshot.data![index]);
                    },
                  );
                },
              ),
              Center(child: Text('Installed apps content')),
              Center(child: Text('Media content')),
            ],
          ),
        ),
      ),
    );
  }
}
