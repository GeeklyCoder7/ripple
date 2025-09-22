import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/services/selection_manager_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController mobileScannerController = MobileScannerController();
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<SelectionManagerService>(
        builder: (context, selectionManager, child) {
          return Stack(
            children: [
              // Camera preview
              MobileScanner(
                controller: mobileScannerController,
                onDetect: (capture) =>
                    _onQrCodeDetected(capture, selectionManager),
              ),

              // Scanning overlay
              _buildScanningOverlay(selectionManager),
            ],
          );
        },
      ),
    );
  }

  // Handles QR code detected state
  void _onQrCodeDetected(
    BarcodeCapture capture,
    SelectionManagerService selectionManger,
  ) {
    if (isScanned) return;

    final List<Barcode> barCodes = capture.barcodes;

    for (final barcode in barCodes) {
      if (barcode.rawValue != null) {
        setState(() => isScanned = true);

        // Handling scanned QR code data
        _handleConnectionData(barcode.rawValue!, selectionManger);
        break;
      }
    }
  }

  Widget _buildScanningOverlay(SelectionManagerService selectionManager) {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Scanning viewfinder square
          Center(
            child: Container(
              width: 250,
              height: 250,
              // decoration: BoxDecoration(
              //   border: Border.all(color: AppColors.cyanSplash, width: 3),
              //   borderRadius: BorderRadius.circular(20),
              // ),
              child: Stack(
                children: [
                  // Corner indicators
                  ...List.generate(4, (index) => _buildCornerIndicator(index)),

                  if (!isScanned)
                    Center(
                      child: const Text(
                        'Point camera at receivers\'s QR code',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildCornerIndicator(int index) {
    const double size = 20;
    const double thickness = 3;

    return Positioned(
      top: index < 2 ? 0 : null,
      bottom: index >= 2 ? 0 : null,
      left: index % 2 == 0 ? 0 : null,
      right: index % 2 == 1 ? 0 : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border(
            top: index < 2
                ? BorderSide(color: AppColors.cyanSplash, width: thickness)
                : BorderSide.none,
            bottom: index >= 2
                ? BorderSide(color: AppColors.cyanSplash, width: thickness)
                : BorderSide.none,
            left: index % 2 == 0
                ? BorderSide(color: AppColors.cyanSplash, width: thickness)
                : BorderSide.none,
            right: index % 2 == 1
                ? BorderSide(color: AppColors.cyanSplash, width: thickness)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Handles the connection data from the QR code
  void _handleConnectionData(
    String qrData,
    SelectionManagerService selectionManager,
  ) {
    // Todo: Parse QR data (receiver's IP, port, session, etc.)

    // Closing scanner after parsing
    Navigator.pop(context);

    // Todo: Navigate to transfer screen with connection details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Connected! Starting transfer of ${selectionManager.totalSelectedCount} files...',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
