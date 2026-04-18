import 'package:get/get.dart';
import '../controllers/skin_analysis_controller.dart';

class SkinAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkinAnalysisController>(() => SkinAnalysisController());
  }
}
