part of 'puzzle_cubit.dart';

abstract class PuzzleState extends Equatable {
  const PuzzleState();
}

class PuzzleInitial extends PuzzleState {
  @override
  List<Object> get props => [];
}

class PuzzleCreatingPositions extends PuzzleState {
  @override
  List<Object> get props => [];
}

class PuzzlePositionsSet extends PuzzleState {
  @override
  List<Object> get props => [];
}

class PuzzleCreatingImages extends PuzzleState {
  final String? message;

  PuzzleCreatingImages({this.message});

  @override
  List<Object> get props => [(message ?? '')];
}

class PuzzleImagesSet extends PuzzleState {
  final List<IndexedImage> puzzleImages;
  final double boxSize;
  final bool playStarted;
  final bool hasWon;

  PuzzleImagesSet(this.puzzleImages, this.boxSize,
      {this.playStarted = false, this.hasWon = false});

  PuzzleImagesSet copyWith({List<IndexedImage>? puzzleImages,
    double? boxSize, bool? playStarted, bool? hasWon}) =>
      PuzzleImagesSet(puzzleImages ?? this.puzzleImages, boxSize??this.boxSize,
     playStarted: playStarted ??this.playStarted,hasWon: hasWon??this.hasWon );

  @override
  List<Object> get props => [puzzleImages, boxSize, playStarted, hasWon];
}
