import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;
import 'package:flutter/material.dart';

class ImageSplitter {
  final List<int> initialImage;

  ImageSplitter(this.initialImage);

  Completer<List<Image>> _splitImagesCompleter = Completer();
  late Isolate _isolate;

  StreamController<int> _resolvedImages = StreamController();
  Stream<int> get resolvedImagesStream =>_resolvedImages.stream;
  Future<List<Image>> get splitImagesReady => _splitImagesCompleter.future;


  void init() async {
    ReceivePort imagesPort = ReceivePort();

    imagesPort.listen((message) {
      if (message is List<Image>) {
        _splitImagesCompleter.complete(message);
      }else if(message is int){
        _resolvedImages.sink.add(message);
      }
    });

    _isolate = await Isolate.spawn(
        splitImage,
        ImageSlitProcess(
            imageBuffer: initialImage, responsePort: imagesPort.sendPort));
  }

  void dispose() {
    _isolate.kill();
    _resolvedImages.close();
  }

  static void splitImage(ImageSlitProcess imageSlitProcess) {
    List<int> inputImage = imageSlitProcess.imageBuffer;
    int horizontalPieceCount = 3;
    int verticalPieceCount = 3;
    imglib.Image? image = imglib.decodeImage(inputImage);

    int x = 0, y = 0;
    int width = (image!.width / horizontalPieceCount).round();
    int height = (image.height / verticalPieceCount).round();

    // split image to parts
    List<imglib.Image> parts = [];
    for (int i = 0; i < horizontalPieceCount; i++) {
      for (int j = 0; j < verticalPieceCount; j++) {
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    //Convert image from image package to Image Widget to display
    List<Image> outputImageList = [];
    for (imglib.Image img in parts) {
      outputImageList.add(Image.memory(
        Uint8List.fromList(
          imglib.encodeJpg(img),
        ),
      ));
      imageSlitProcess.responsePort.send(outputImageList.length);
    }
    imageSlitProcess.responsePort.send(outputImageList);
  }
}

class ImageSlitProcess {
  List<int> imageBuffer;
  SendPort responsePort;

  ImageSlitProcess({required this.imageBuffer, required this.responsePort});
}
