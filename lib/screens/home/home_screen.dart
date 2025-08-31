import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ripple/viewmodels/permission_viewmodel.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              // Top section with app name
              SizedBox(
                width: double.infinity,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: AppColors.appNameTextColor,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    AppConstants.appName,
                    style: GoogleFonts.quicksand(
                      fontSize: AppConstants.fontSizeExtraLarge,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 6,
                    ),
                  ),
                ),
              ),

              // Rest of content with flex
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Decorative illustration
                    Container(
                      margin: EdgeInsets.only(top: AppConstants.paddingSmall),
                      child: Center(
                        child: Image(
                          image: AssetImage(
                            'assets/images/decorative/home_screen_illustration.png',
                          ),
                          width: 300,
                        ),
                      ),
                    ),

                    // Send and Receive buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Send button
                        Container(
                          height: 100,
                          width: 150,
                          padding: EdgeInsets.all(AppConstants.paddingSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                            gradient: AppColors.sendButtonGradient,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 13,
                                offset: Offset(3.5, 5),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () async {
                              final permissionViewModel = Provider.of<PermissionViewModel>(context, listen: false);
                              await permissionViewModel.initializePermissions();
                              await permissionViewModel.requestAllPermissions();
                              Navigator.pushNamed(context, '/select_files');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Icon image
                                Image.asset(
                                  'assets/images/icons/send_button_icon.png',
                                  width: 50,
                                  height: 50,
                                  color: AppColors.white,
                                ),
                                // Button text
                                Text(
                                  'Send',
                                  style: GoogleFonts.quicksand(
                                    fontSize: AppConstants.fontSizeMedium,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Receive button
                        Container(
                          height: 100,
                          width: 150,
                          padding: EdgeInsets.all(AppConstants.paddingSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                            gradient: AppColors.receiveButtonGradient,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 13,
                                offset: Offset(3.5, 5),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Receive Button Clicked'),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Icon image
                                Image.asset(
                                  'assets/images/icons/receive_button_icon.png',
                                  width: 50,
                                  height: 50,
                                  color: AppColors.white,
                                ),
                                // Button text
                                Text(
                                  'Receive',
                                  style: GoogleFonts.quicksand(
                                    fontSize: AppConstants.fontSizeMedium,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Settings and history buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Settings button
                        Card(
                          color: AppColors.utilityButtonsBackground.withOpacity(
                            0.5,
                          ),
                          child: Container(
                            height: 60,
                            width: 150,
                            padding: EdgeInsets.all(AppConstants.paddingSmall),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon
                                Icon(
                                  Clarity.settings_line,
                                  color: AppColors.waveBlue,
                                  size: 30,
                                ),
                                Text(
                                  'Settings',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: AppConstants.fontSizeDefault,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // History button
                        Card(
                          color: AppColors.utilityButtonsBackground.withOpacity(
                            0.5,
                          ),
                          child: Container(
                            height: 60,
                            width: 150,
                            padding: EdgeInsets.all(AppConstants.paddingSmall),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon
                                Icon(
                                  Clarity.history_line,
                                  color: AppColors.waveBlue,
                                  size: 30,
                                ),
                                Text(
                                  'History',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: AppConstants.fontSizeDefault,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
