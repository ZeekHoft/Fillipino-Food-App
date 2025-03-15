import 'package:flilipino_food_app/pages/upload_image.dart';
import 'package:flilipino_food_app/pages/recipe_output.dart';
import 'package:flilipino_food_app/pages/search_recipe.dart';
import 'package:flilipino_food_app/prompts/prompt_view_model.dart';
import 'package:flilipino_food_app/recipe/recipe_view_model.dart';
import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flilipino_food_app/util/recipe_stream_builder.dart';
import 'package:flilipino_food_app/util/tap_recorder.dart';
import 'package:flilipino_food_app/themse/color_themes.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flilipino_food_app/util/device_info.dart';

late CameraDescription camera;
late BaseDeviceInfo deviceInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  deviceInfo = await DeviceInfo.initialize(DeviceInfoPlugin());
  if (DeviceInfo.isPhysicalDeviceWithCamera(deviceInfo)) {
    final cameras = await availableCameras();
    camera = cameras.first;
  }
  //RecipeStreamBuilder is placed at the top of all widgets or global access
  runApp(RecipeStreamBuilder(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddImageToPromptWidget(
        height: 110,
        width: 111,
      ),
    ),
  ));
}

class Mainapp extends StatefulWidget {
  const Mainapp({super.key});

  @override
  State<Mainapp> createState() => _MainappState();
}

class _MainappState extends State<Mainapp> {
  @override
  Widget build(BuildContext context) {
    final recipesViewModel = SavedRecipesViewModel();
    return TapRecorder(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PromptViewModel(
              multiModalModel: geminiVisionProModel,
              textModel: geminiProModel,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => recipesViewModel,
          ),
        ],
        child: SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            scrollBehavior: const ScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            home: const AdaptiveRouter(),
          ),
        ),
      ),
    );
  }
}
