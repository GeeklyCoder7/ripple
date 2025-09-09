import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_colors.dart';

import '../core/constants/app_constants.dart';
import '../viewmodels/fetch_folder_items_viewmodel.dart';

class breadCrumbText extends StatefulWidget {
  final List<String> breadcrumbPaths;
  const breadCrumbText({super.key, required this.breadcrumbPaths});

  @override
  State<breadCrumbText> createState() => _breadCrumbTextState();
}

class _breadCrumbTextState extends State<breadCrumbText> {
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller for starting the scrollview to the end by default

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Row(
          children: [
            // Individual breadcrumb segments
            ...widget.breadcrumbPaths.asMap().entries.map((entry) {
              int index = entry.key;
              String segment = entry.value;
              bool isLast = index == widget.breadcrumbPaths.length - 1;
              return Row(
                children: [
                  InkWell(
                    onTap: () async {
                      String targetPath =
                          '/${widget.breadcrumbPaths.sublist(0, index + 1).join('/')}';
                      await context.read<FetchFolderItemsViewModel>().loadFolder(
                        targetPath,
                      );
                    },
                    child: Text(
                      segment,
                      style: GoogleFonts.quicksand(
                        fontSize: AppConstants.fontSizeSmall,
                        color: isLast ? Colors.black : AppColors.breadCrumbTextColor,
                        fontWeight: isLast
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Text(
                      '/',
                      style: TextStyle(fontSize: AppConstants.fontSizeDefault),
                    ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
