import 'package:flutter/material.dart';

class ErrorCameraWidget extends StatelessWidget {
  const ErrorCameraWidget({super.key, required this.openAppSettings});

  final void Function() openAppSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          const Text(
            "Camera permission is required",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Please enable camera permission in settings.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: openAppSettings,
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
