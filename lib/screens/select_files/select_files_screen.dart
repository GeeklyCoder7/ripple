import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/screens/select_files/tabs/files_list_tab.dart';
import 'package:ripple/viewmodels/select_files_viewmodel.dart';

import '../../core/constants/app_colors.dart';

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
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Documents',
                        style: GoogleFonts.quicksand(
                          color: AppColors.white,
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Media',
                        style: GoogleFonts.quicksand(
                          color: AppColors.white,
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Apk',
                        style: GoogleFonts.quicksand(
                          color: AppColors.white,
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
