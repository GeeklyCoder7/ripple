import 'package:flutter/material.dart';
import 'package:ripple/core/constants/app_constants.dart';
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
  late List<FileSystemItem> mockItems;
  @override
  void initState() {
    super.initState();
    // Mock directories for testing
    mockItems = [
      // Mock folders
      FolderItem(
        itemName: 'Documents',
        itemPath: '/storage/emulated/0/Documents',
        itemCount: 15,
        isAccessible: true,
      ),
      FolderItem(
        itemName: 'Downloads',
        itemPath: '/storage/emulated/0/Downloads',
        itemCount: 8,
        isAccessible: true,
      ),
      FileItem(
        itemName: 'Report.pdf',
        itemPath: '/storage/emulated/0/Report.pdf',
        fileSizeBytes: 12345, // 2MB
        fileExtension: '.pdf',
        fileType: AppConstants.getFileTypeFromExtension('.pdf'),
      ),
      FileItem(
        itemName: 'Presentation.pptx',
        itemPath: '/storage/emulated/0/Presentation.pptx',
        fileSizeBytes: 87654, // 5MB
        fileExtension: '.pptx',
        fileType: AppConstants.getFileTypeFromExtension('.pptx'),
      ),
      FileItem(
        itemName: 'Photo.jpg',
        itemPath: '/storage/emulated/0/Photo.jpg',
        fileSizeBytes: 1289748, // 1MB
        fileExtension: '.jpg',
        fileType: AppConstants.getFileTypeFromExtension('.jpg'),
      ),
      FileItem(
        itemName: 'Photo.png',
        itemPath: '/storage/emulated/0/Photo.png',
        fileSizeBytes: 702545, // 1MB
        fileExtension: '.png',
        fileType: AppConstants.getFileTypeFromExtension('.png'),
      ),
      FileItem(
        itemName: 'Photo.xls',
        itemPath: '/storage/emulated/0/Photo.jpg',
        fileSizeBytes: 5746196, // 1MB
        fileExtension: '.xls',
        fileType: AppConstants.getFileTypeFromExtension('.xls'),
      ),
      FileItem(
        itemName: 'Photo.doc',
        itemPath: '/storage/emulated/0/Photo.jpg',
        fileSizeBytes: 10831790, // 1MB
        fileExtension: '.doc',
        fileType: AppConstants.getFileTypeFromExtension('.doc'),
      ),
      FileItem(
        itemName: 'Photo.apk',
        itemPath: '/storage/emulated/0/Photo.jpg',
        fileSizeBytes: 105444802, // 1MB
        fileExtension: '.apk',
        fileType: AppConstants.getFileTypeFromExtension('.apk'),
      ),
      FileItem(
        itemName: 'Video_Tutorial.mp4',
        itemPath: '/storage/emulated/0/Video_Tutorial.mp4',
        fileSizeBytes: 934155386, // ~0.87 GB
        fileExtension: '.mp4',
        fileType: AppConstants.getFileTypeFromExtension('.mp4'),
      ),
      FileItem(
        itemName: 'Game_Installer.apk',
        itemPath: '/storage/emulated/0/Game_Installer.apk',
        fileSizeBytes: 1234803097, // ~1.15 GB
        fileExtension: '.apk',
        fileType: AppConstants.getFileTypeFromExtension('.apk'),
      ),
    ];
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
              ListView.builder(
                itemCount: mockItems.length,
                itemBuilder: (context, index) {
                  return FileSystemItemTile(item: mockItems[index]);
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
