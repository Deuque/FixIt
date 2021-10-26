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
  final bool puzzleSolved;
  final int moves;
  final bool doneSettingUp;

  PuzzleImagesSet(this.puzzleImages, this.boxSize,
      {this.playStarted = false,
      this.puzzleSolved = false,
      this.moves = 0,
      this.doneSettingUp = false});

  PuzzleImagesSet copyWith(
          {List<IndexedImage>? puzzleImages,
          double? boxSize,
          bool? playStarted,
          bool? puzzleSolved,
          int? moves}) =>
      PuzzleImagesSet(
          puzzleImages ?? this.puzzleImages, boxSize ?? this.boxSize,
          playStarted: playStarted ?? this.playStarted,
          puzzleSolved: puzzleSolved ?? this.puzzleSolved,
          moves: moves ?? this.moves,
          doneSettingUp: this.doneSettingUp);

  @override
  List<Object> get props =>
      [puzzleImages, boxSize, playStarted, puzzleSolved, moves, doneSettingUp];
}
