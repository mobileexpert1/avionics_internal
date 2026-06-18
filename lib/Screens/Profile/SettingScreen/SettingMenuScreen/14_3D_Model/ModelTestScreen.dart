import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class ModelTestScreen extends StatefulWidget {
  const ModelTestScreen({super.key});

  @override
  State<ModelTestScreen> createState() => _ModelTestScreenState();
}

class _ModelTestScreenState extends State<ModelTestScreen> {
  final Flutter3DController controller = Flutter3DController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Model Test'),
      ),
      body: Flutter3DViewer(
        controller: controller,
        src: 'assets/3d_models/Airplane1.glb',
      ),
    );
  }
}