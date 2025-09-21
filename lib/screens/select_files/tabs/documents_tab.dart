import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/services/selection_manager_service.dart';
import 'package:ripple/viewmodels/fetch_folder_items_viewmodel.dart';
import 'package:ripple/widgets/file_system_item_tile.dart';
import 'package:ripple/widgets/path_breadcrumb.dart';

import '../../../core/constants/app_constants.dart';

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchFolderItemsViewModel>().loadFolder(
        AppConstants.defaultStoragePath,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer2<FetchFolderItemsViewModel, SelectionManagerService>(
      builder: (context, folderViewModel, selectionManger, child) {
        if (folderViewModel.folderContentsList.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            selectionManger.syncSelectionState(
              folderViewModel.folderContentsList,
            );
          });
        }

        if (folderViewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (folderViewModel.folderContentsList.isEmpty) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                breadCrumbText(
                  breadcrumbPaths: folderViewModel.breadcrumbPaths,
                ),
                const Spacer(),
                Center(child: const Text('No items')),
                const Spacer(),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb text
            breadCrumbText(breadcrumbPaths: folderViewModel.breadcrumbPaths),

            Expanded(
              child: ListView.builder(
                itemCount: folderViewModel.folderContentsList.length,
                itemBuilder: (context, index) {
                  final item = folderViewModel.folderContentsList[index];
                  return FileSystemItemTile(
                    item: item,
                    onTap: () {
                      if (item.isFolder) {
                        folderViewModel.loadFolder(item.itemPath);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
