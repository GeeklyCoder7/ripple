import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/screens/select_files/tabs/files_list_tab.dart';
import 'package:ripple/services/select_files_service.dart';
import 'package:ripple/viewmodels/select_files_viewmodel.dart';
import 'package:ripple/widgets/file_system_item_tile.dart';
import '../../models/file_system_item.dart';

class SelectFilesScreen extends StatefulWidget {
  const SelectFilesScreen({super.key});

  @override
  State<SelectFilesScreen> createState() => _SelectFilesScreenState();
}

class _SelectFilesScreenState extends State<SelectFilesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SelectFilesViewModel>().loadFolder(
        AppConstants.defaultStoragePath,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectFilesViewModel>(
      builder: (context, viewmodel, child) {
        return WillPopScope(
          onWillPop: () async {
            if (viewmodel.canNavigateBack) {
              viewmodel.loadPreviousFolder();
              return false;
            }
            return true;
          },
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Select Files'),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Documents'),
                    Tab(text: 'Install Apk'),
                    Tab(text: 'Media'),
                  ],
                ),
              ),
              body: const Padding(
                padding: EdgeInsets.all(8.0),
                child: TabBarView(
                  children: [
                    FilesListTab(),
                    Center(child: Text('Installed apps content')),
                    Center(child: Text('Media content')),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
