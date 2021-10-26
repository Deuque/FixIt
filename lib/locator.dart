import 'package:fix_it/controllers/gallery_controller.dart';
import 'package:fix_it/controllers/puzzle_controller/puzzle_cubit.dart';
import 'package:fix_it/controllers/score_controller.dart';
import 'package:fix_it/data/score_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void initLocator() {
  //register repositories
  locator.registerLazySingleton<ScoreRepository>(() => ScoreRepository());

  //register controllers
  locator.registerLazySingleton<GalleryController>(() => GalleryController());
  locator.registerLazySingleton<PuzzleCubit>(() => PuzzleCubit());
  locator.registerSingleton<ScoreController>(
      ScoreController(locator.get()));


}
