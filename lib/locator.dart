import 'package:fix_it/controllers/gallery_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void initLocator() {

  //register controllers
  locator.registerSingleton<GalleryController>(GalleryController());

}
