import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ripple/widgets/installed_app_card.dart';
import '../../../viewmodels/fetch_apk_viewmodel.dart';

class InstalledAppsTab extends StatefulWidget {
  const InstalledAppsTab({super.key});

  @override
  State<InstalledAppsTab> createState() => _InstalledAppsTabState();
}

class _InstalledAppsTabState extends State<InstalledAppsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchApkViewModel>().loadInstalledApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<FetchApkViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(viewModel.errorMessage ?? 'Unknown error'),
              ElevatedButton(
                onPressed: viewModel.refresh,
                child: const Text('Retry'),
              ),
            ],
          );
        }

        if (!viewModel.hasData) {
          return const Center(child: Text('No apps found'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: viewModel.installedApps.length,
          itemBuilder: (context, index) {
            final app = viewModel.installedApps[index];
            return InstalledAppCard(item: app);
          },
        );
      },
    );
  }
}
