
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/util/image_splitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'puzzle_state.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(PuzzleInitial());

  List<Offset> _puzzlePositions = [];
  List<IndexedImage> _puzzleImages = [];
  bool initPositions = false;

  void tet() {
    emit(PuzzleInitial());
  }

  void resetPuzzle() {
    _puzzleImages = [];
    _puzzlePositions = [];
    emit(PuzzleInitial());
  }

  void shuffle() {
    _puzzleImages = [
      for (final item in _puzzleImages)
        if (item.index == 4)
          item.copyWith(offset: _puzzlePositions[5])
        else
          item
    ];
    emit(PuzzleImagesSet(_puzzleImages, (state as PuzzleImagesSet).boxSize));
  }

  void setPuzzlePositions(
      {required double puzzleFrameSize, required double boxInnerPadding}) {
    emit(PuzzleCreatingPositions());

    double boxSize = (puzzleFrameSize - (2 * boxInnerPadding)) / 3;
    for (int i = 0; i < 9; i++) {
      late Offset offset;
      int realIndex = i + 1;

      double row;

      if (realIndex - 3 <= 0) {
        // first row
        row = 0;
      } else if (realIndex - 3 <= 3) {
        // second row
        row = 1;
      } else {
        // third row
        row = 2;
      }

      double top = row * boxInnerPadding + row * boxSize;
      double positionInRow = realIndex - (row * 3) - 1;
      double left = positionInRow * boxInnerPadding + positionInRow * boxSize;
      offset = Offset(left, top);
      _puzzlePositions.add(offset);
    }

    emit(PuzzlePositionsSet(boxSize));
  }

  void setPuzzleImages(dynamic assetOrFile, double imageSize) async {
    emit(PuzzleCreatingImages());
    late List<int> initialImage;
    if (assetOrFile is String) {
      var data = await rootBundle.load(assetOrFile);
      initialImage = data.buffer.asUint8List().toList();
    } else {
      throw UnimplementedError();
    }

    // split image
    final imageSplitter = ImageSplitter(initialImage);
    imageSplitter.init();
    // listen for percentage done
    imageSplitter.resolvedImagesStream.listen((processed) {
      double percentageDone = (processed / 9) * 100;
      emit(PuzzleCreatingImages(percentage: percentageDone));
    });

    // get split images and dispose isolate
    List<Image> splitImages = await imageSplitter.splitImagesReady;
    imageSplitter.dispose();

    _puzzleImages = List.generate(
        splitImages.length,
        (index) => IndexedImage(
            index: index,
            image: splitImages[index],
            offset: _puzzlePositions[index]));
    emit(PuzzleImagesSet(_puzzleImages, imageSize));
  }
}

class IndexedImage extends Equatable {
  final int index;
  final Image image;
  final Offset offset;

  @override
  List<Object?> get props => [index, image, offset];

  IndexedImage(
      {required this.index, required this.image, required this.offset});

  IndexedImage copyWith({Offset? offset}) => IndexedImage(
      image: this.image, index: this.index, offset: offset ?? this.offset);
}
