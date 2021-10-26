import 'package:fix_it/components/loader.dart';
import 'package:fix_it/components/puzzle_button.dart';
import 'package:fix_it/components/puzzle_solved_dialog.dart';
import 'package:fix_it/controllers/puzzle_controller/puzzle_cubit.dart';
import 'package:fix_it/controllers/score_controller.dart';
import 'package:fix_it/locator.dart';
import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuzzleFrame extends StatefulWidget {
  final dynamic assetOrFile;

  PuzzleFrame({Key? key, this.assetOrFile}) : super(key: key);

  @override
  _PuzzleFrameState createState() => _PuzzleFrameState();
}

class _PuzzleFrameState extends State<PuzzleFrame> {
  final _puzzleCubit = locator<PuzzleCubit>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _puzzleCubit.emit(PuzzleInitial());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _puzzleCubit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defHorPadding / 2),
        child: LayoutBuilder(builder: (context, constraint) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: primary, width: .7),
                borderRadius: BorderRadius.circular(defPuzzleRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: constraint.maxWidth,
                    width: constraint.maxWidth,
                    child: widget.assetOrFile == null
                        ? _emptyPuzzler(constraint)
                        : Stack(
                            children: [
                              _backgroundPuzzleHint(),
                              BlocConsumer<PuzzleCubit, PuzzleState>(
                                  listener: (context, state) =>
                                      _puzzleBlocListener(
                                          context, state, constraint),
                                  builder: (context, state) {
                                    if (state is PuzzleCreatingImages)
                                      return _createPuzzleLoader(
                                          state, constraint);
                                    if (state is PuzzleImagesSet)
                                      return _setImagesInPosition(state);
                                    return SizedBox.shrink();
                                  })
                            ],
                          ),
                  ),
                  PuzzleControls()
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _puzzleBlocListener(context, state, BoxConstraints constraint) {
    if (state is PuzzleInitial) {
      _puzzleCubit.setPuzzlePositions(
          puzzleFrameSize: constraint.maxWidth, boxInnerPadding: 1.5);
    } else if (state is PuzzlePositionsSet) {
      _puzzleCubit.setPuzzleImages(widget.assetOrFile);
    } else if (state is PuzzleImagesSet && state.puzzleSolved) {
      Future.delayed(Duration(milliseconds: 600),
          () => showPuzzleSolvedDialog(state.moves));
      locator<ScoreController>().checkAndUpdateScore(state.moves);
    }
  }

  Widget _setImagesInPosition(PuzzleImagesSet state) => ClipRRect(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(defPuzzleRadius)),
        child: Stack(
          children: state.puzzleImages
              .map((e) => AnimatedPositioned(
                    top: e.offset.dy,
                    left: e.offset.dx,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.decelerate,
                    child: GestureDetector(
                      onTap: () {
                        if (state.playStarted && !state.puzzleSolved) {
                          locator<PuzzleCubit>().moveImage(e);
                        }
                      },
                      child: Container(
                        height: state.boxSize,
                        width: state.boxSize,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: e.image.image, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );

  Widget _backgroundPuzzleHint() => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(widget.assetOrFile), fit: BoxFit.fill),
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(defPuzzleRadius)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: background.withOpacity(.9),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(defPuzzleRadius)),
          ),
        ),
      );

  Widget _createPuzzleLoader(
          PuzzleCreatingImages state, BoxConstraints constraint) =>
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Loader(
              size: constraint.maxWidth * .05,
            ),
            if (state.message != null) ...[
              SizedBox(
                height: 5,
              ),
              Text(
                '${state.message}',
                style: TextStyle(color: white),
              )
            ]
          ],
        ),
      );

  Widget _emptyPuzzler(BoxConstraints constraint) =>
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              emptyPuzzleIcon,
              height: constraint.maxWidth * .14,
              color: primary,
            ),

              SizedBox(
                height: 5,
              ),
              Text(
                'Select an Image',
                style: TextStyle(color: white.withOpacity(.7)),
              )

          ],
        ),
      );

  void showPuzzleSolvedDialog(int moves) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: PuzzleSolvedDialog(
                onCloseDialog: () {
                  Navigator.pop(context);
                  _puzzleCubit.stopGame();
                },
                onPlayAgain: () {
                  Navigator.pop(context);
                  _puzzleCubit.startGame();
                },
                moves: moves,
              ),
            ));
  }
}

class PuzzleControls extends StatelessWidget {
  const PuzzleControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuzzleCubit, PuzzleState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
                child: PuzzleButton.left(
              title: (state is PuzzleImagesSet && state.playStarted)
                  ? '${state.moves}'
                  : 'START',
              enabled: state is PuzzleImagesSet && !(state.playStarted),
              onPressed: () {
                locator<PuzzleCubit>().startGame();
              },
            )),
            SizedBox(
              width: 2,
            ),
            Expanded(
                child: PuzzleButton.right(
              title: 'SHUFFLE',
              enabled: (state is PuzzleImagesSet && state.playStarted),
              onPressed: () {
                locator<PuzzleCubit>().shuffle();
              },
            )),
          ],
        );
      },
    );
  }
}
