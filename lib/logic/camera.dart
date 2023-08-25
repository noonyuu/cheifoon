import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../component/appbar.dart';
import '../constant/color_constant.dart';
import '../page/addalert.dart';

class CameraApp extends StatelessWidget {
  const CameraApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Camera(camera: camera),
    );
  }
}

// カメラ画面
class Camera extends StatefulWidget {
  const Camera({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _initializeCameraController();
  }

  void _initializeCameraController() async {
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
          // appBar: AppBarComponentWidget(
          //   isInfoIconEnabled: true,
          // ),
          body: CameraPreview(_controller),
          floatingActionButton: FloatingActionButton(
            child: GestureDetector(
              // タップした時
              onTap: () async {
                // 写真撮影
                final image = await _controller.takePicture();
                // 表示用の画面に遷移
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImagePreview(imagePath: image.path),
                    fullscreenDialog: true,
                  ),
                );
              },

              child: const Icon(Icons.add_a_photo),
            ),
            onPressed: () {},
          )),
    );
  }
}

// 撮影した写真を表示する画面
class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(File(imagePath)),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorConst.mainColor, // 枠線の色
                    width: 5.0, // 枠線の幅
                  ),
                  color: ColorConst.paleYellow,
                  borderRadius: BorderRadius.circular(24.0), // 角の丸みを設定
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    imagePaths.setFilePath(imagePath);
                    int count = 0;
                    Navigator.popUntil(context, (_) => count++ >= 2);
                  },
                  child: Text('OK'),
                  style: ElevatedButton.styleFrom(backgroundColor: ColorConst.mainColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class imagePaths {
  static String filePath = '';

  static void setFilePath(String path) {
    filePath = path;
  }

  static String getFilePath() {
    return filePath;
  }
}
