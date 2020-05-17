import 'package:backgrounds/services/AuthService.dart';
import 'package:backgrounds/services/ImageService.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [...indepenedet, ...dependent, ...ui];

List<SingleChildWidget> indepenedet = [
  ChangeNotifierProvider(
    create: (_) => locator<AuthService>(),
  )
];
List<SingleChildWidget> dependent = [
  ChangeNotifierProvider<ImageService>(
    create: (_) => locator<ImageService>(),
  )
];
List<SingleChildWidget> ui = [];

final locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ImageService());
}
