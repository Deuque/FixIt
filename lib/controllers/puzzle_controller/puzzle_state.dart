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
  final double boxSize;

  PuzzlePositionsSet(this.boxSize);
  @override
  List<Object> get props => [boxSize];
}
class PuzzleCreatingImages extends PuzzleState {
  final String? message;

  PuzzleCreatingImages({this.message});
  @override
  List<Object> get props => [(message??'')];
}
class PuzzleImagesSet extends PuzzleState {
  final List<IndexedImage> puzzleImages;
  final double boxSize;

  PuzzleImagesSet(this.puzzleImages,this.boxSize);
  @override
  List<Object> get props => [puzzleImages, boxSize];
}
