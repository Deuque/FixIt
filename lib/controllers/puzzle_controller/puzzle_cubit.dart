import 'dart:io';
import 'dart:math';

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
  double _puzzleBoxSize = 0;
  late IndexedImage wildCard;
  late int _emptyPosition;

  void startGame() async {
    _createEmptyPlayBox();
    await Future.delayed(Duration(milliseconds: 500));
    final currentState = (state as PuzzleImagesSet);
    emit(currentState.copyWith(playStarted: true, moves: 0));
    shuffle();
  }

  void stopGame() {
    final currentState = (state as PuzzleImagesSet);
    emit(currentState.copyWith(
        playStarted: false, puzzleSolved: false, moves: 0));
  }

  void _createEmptyPlayBox() {
    // remove the last box to create play space
    wildCard = _puzzleImages[8];
    _emptyPosition = 8;
    _puzzleImages = _puzzleImages.take(8).toList();
    final currentState = (state as PuzzleImagesSet);
    emit(currentState.copyWith(
      puzzleImages: _puzzleImages,
    ));
  }

  void clearLists() {
    _puzzlePositions.clear();
    _puzzleImages.clear();
  }

  void shuffle() {
    return;
    final currentState = (state as PuzzleImagesSet);
    for (int i = 0; i < 8; i++) {
      // shuffle images, generate random number and swap
      var random = Random().nextInt(9);
      while (random == i) {
        random = Random().nextInt(9);
      }

      var image1 = _getImageOfIndex(i);
      if (image1 != null) {
        image1 = image1.copyWith(
            offset: _puzzlePositions[random], currentPosition: random);
      }

      var image2 = _getImageOfIndex(random);
      if (image2 != null) {
        image2 =
            image2.copyWith(offset: _puzzlePositions[i], currentPosition: i);
      }

      if (image1 != null) _updatePuzzleImageInList(image1);
      if (image2 != null) _updatePuzzleImageInList(image2);

      emit(currentState.copyWith(
        puzzleImages: _puzzleImages,
        boxSize: _puzzleBoxSize,
      ));
    }
    _setEmptyPosition();
  }

  IndexedImage? _getImageOfIndex(int index) {
    if (_puzzleImages.map((e) => e.currentPosition).toList().contains(index)) {
      return _puzzleImages
          .firstWhere((element) => element.currentPosition == index);
    }
    return null;
  }

  void _updatePuzzleImageInList(IndexedImage? newImage) {
    _puzzleImages = [
      for (final item in _puzzleImages)
        if (item.realIndex == newImage!.realIndex) newImage else item
    ];
  }

  void moveImage(IndexedImage image) {
    final diff = (image.currentPosition - _emptyPosition).abs();
    if (diff == 1 || diff == 3) {
      _updatePuzzleImageInList(image.copyWith(
          offset: _puzzlePositions[_emptyPosition],
          currentPosition: _emptyPosition));

      bool isSolved = checkIfSolved();
      if (isSolved) _puzzleImages = [..._puzzleImages, wildCard];
      final currentState = (state as PuzzleImagesSet);
      emit(currentState.copyWith(
          puzzleImages: _puzzleImages,
          moves: currentState.moves + 1,
          puzzleSolved: isSolved));
      _setEmptyPosition();
    }
  }

  void _setEmptyPosition() {
    for (int i = 0; i < 9; i++) {
      bool found = false;
      for (final image in _puzzleImages) {
        if (image.offset == _puzzlePositions[i]) found = true;
      }
      if (!found) {
        _emptyPosition = i;
        break;
      }
    }
  }

  bool checkIfSolved() {
    bool hasWon = true;
    for (final item in _puzzleImages) {
      hasWon = hasWon && (item.currentPosition == item.realIndex);
    }
    return hasWon;
  }

  void setPuzzlePositions(
      {required double puzzleFrameSize, required double boxInnerPadding}) {
    emit(PuzzleCreatingPositions());
    clearLists();
    _puzzleBoxSize = (puzzleFrameSize - (2 * boxInnerPadding)) / 3;
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

      double top = row * boxInnerPadding + row * _puzzleBoxSize;
      double positionInRow = realIndex - (row * 3) - 1;
      double left =
          positionInRow * boxInnerPadding + positionInRow * _puzzleBoxSize;
      offset = Offset(left, top);
      _puzzlePositions.add(offset);
    }

    emit(PuzzlePositionsSet());
  }

  void setPuzzleImages(dynamic assetOrFile) async {
    emit(PuzzleFramingImages(message: 'Framing Image'));
    _puzzleImages.clear();
    late List<int> initialImage;
    if (assetOrFile is String) {
      var data = await rootBundle.load(assetOrFile);
      initialImage = data.buffer.asUint8List().toList();
    } else if (assetOrFile is File) {
      initialImage = await assetOrFile.readAsBytes();
    } else {
      throw UnimplementedError();
    }

    // split image
    final imageSplitter = ImageSplitter(initialImage);
    imageSplitter.init();
    // listen for percentage done
    final imageSubscription =
        imageSplitter.resolvedImagesStream.listen((processedImage) {
      int newIndex = _puzzleImages.length;
      _puzzleImages = [
        ..._puzzleImages,
        IndexedImage(
            realIndex: newIndex,
            currentPosition: newIndex,
            image: processedImage,
            offset: _puzzlePositions[newIndex])
      ];
      emit(PuzzleImagesSet(_puzzleImages, _puzzleBoxSize,
          doneSettingUp: newIndex == 8));
    });

    // check when splitting is done and dispose isolate
    await imageSplitter.splitImagesReady;
    imageSubscription.cancel();
    imageSplitter.dispose();
  }
}

class IndexedImage extends Equatable {
  final int realIndex;
  final Image image;
  final int currentPosition;
  final Offset offset;

  @override
  List<Object?> get props => [realIndex, image, currentPosition, offset];

  IndexedImage(
      {required this.realIndex,
      required this.image,
      required this.currentPosition,
      required this.offset});

  IndexedImage copyWith({Offset? offset, int? currentPosition}) => IndexedImage(
      image: this.image,
      realIndex: this.realIndex,
      offset: offset ?? this.offset,
      currentPosition: currentPosition ?? this.currentPosition);
}
