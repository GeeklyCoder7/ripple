import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/screens/select_files/tabs/installed_apps_tab.dart';
import 'package:ripple/screens/select_files/tabs/documents_tab.dart';
import 'package:ripple/screens/select_files/tabs/media_tab.dart';
import 'package:ripple/services/selection_manager_service.dart';
import 'package:ripple/viewmodels/fetch_apk_viewmodel.dart';
import 'package:ripple/viewmodels/fetch_folder_items_viewmodel.dart';
import 'package:ripple/widgets/selection_bottom_bar.dart';

import '../../core/constants/app_colors.dart';

class SelectFilesScreen extends StatefulWidget {
  const SelectFilesScreen({super.key});

  @override
  State<SelectFilesScreen> createState() => _SelectFilesScreenState();
}

class _SelectFilesScreenState extends State<SelectFilesScreen> {
  SelectionManagerService selectionManagerService = SelectionManagerService();
  @override
  Widget build(BuildContext context) {
    return Consumer<FetchFolderItemsViewModel>(
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
              body: Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TabBarView(
                      children: [
                        DocumentsTab(),
                        MediaTab(),
                        InstalledAppsTab(),
                      ],
                    ),
                  ),

                  // Bottom bar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: const SelectionBottomBar(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
