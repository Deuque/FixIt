import 'package:fix_it/controllers/gallery_controller.dart';
import 'package:fix_it/controllers/puzzle_controller/puzzle_cubit.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void initLocator() {
  //register controllers
  locator.registerLazySingleton<GalleryController>(() => GalleryController());
  locator.registerLazySingleton<PuzzleCubit>(() => PuzzleCubit());
}
