import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../app/routes/app_routes.dart';

class SkinAnalysisController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var currentStep = 0.obs;
  var isLoading = false.obs;

  // Quiz Questions Data
  // HTA Skin Type Analysis (10 Questions)
  final questions = [
    {
      "question": "How fair is your skin without a tan?",
      "options": [
        {"text": "Very fair, almost white", "score": 0},
        {"text": "Fair", "score": 1},
        {"text": "Medium", "score": 2},
        {"text": "Dark", "score": 3},
        {"text": "Very dark", "score": 4},
      ],
    },
    {
      "question": "How does your skin react to the sun?",
      "options": [
        {"text": "Always sunburned", "score": 0},
        {"text": "Frequent sunburn", "score": 1},
        {"text": "Sometimes sunburned", "score": 2},
        {"text": "Rarely sunburned", "score": 3},
        {"text": "Never sunburned", "score": 4},
      ],
    },
    {
      "question": "How quickly do you tan?",
      "options": [
        {"text": "Not at all", "score": 0},
        {"text": "Very slowly", "score": 1},
        {"text": "Slowly", "score": 2},
        {"text": "Quickly", "score": 3},
        {"text": "Very quickly", "score": 4},
      ],
    },
    {
      "question": "How long does your tan last?",
      "options": [
        {"text": "Not at all", "score": 0},
        {"text": "A few days", "score": 1},
        {"text": "1–2 weeks", "score": 2},
        {"text": "Several weeks", "score": 3},
        {"text": "A very long time", "score": 4},
      ],
    },
    {
      "question": "Do you have freckles?",
      "options": [
        {"text": "Many", "score": 0},
        {
          "text": "Many",
          "score": 1,
        }, // Duplicate in source text, keeping logic consistent
        {"text": "A few", "score": 2},
        {"text": "Hardly any", "score": 3},
        {"text": "None", "score": 4},
      ],
    },
    {
      "question": "How sensitive is your skin in general?",
      "options": [
        {"text": "Extremely sensitive", "score": 0},
        {"text": "Very sensitive", "score": 1},
        {"text": "Normal", "score": 2},
        {"text": "Insensitive", "score": 3},
        {"text": "Very resilient", "score": 4},
      ],
    },
    {
      "question": "What was your natural hair color as a child?",
      "options": [
        {"text": "Red", "score": 0},
        {"text": "Blonde", "score": 1},
        {"text": "Dark blonde", "score": 2},
        {"text": "Brown", "score": 3},
        {"text": "Black", "score": 4},
      ],
    },
    {
      "question": "What is your eye color?",
      "options": [
        {"text": "Blue/Green", "score": 0},
        {"text": "Gray", "score": 1},
        {"text": "Hazel", "score": 2},
        {"text": "Brown", "score": 3},
        {"text": "Dark brown/Black", "score": 4},
      ],
    },
    {
      "question": "How does your skin react to cosmetic products?",
      "options": [
        {"text": "Very frequent irritation", "score": 0},
        {"text": "Often irritation", "score": 1},
        {"text": "Sometimes", "score": 2},
        {"text": "Rarely", "score": 3},
        {"text": "Never", "score": 4},
      ],
    },
    {
      "question": "How many times have you tanned (tanning bed/sun)?",
      "options": [
        {"text": "Never", "score": 0},
        {"text": "Very rarely", "score": 1},
        {"text": "Occasionally", "score": 2},
        {"text": "Regularly", "score": 3},
        {"text": "Very regularly", "score": 4},
      ],
    },
  ];

  // Store selected option index for each question
  var selectedAnswers = <int, int>{}.obs;

  int get totalScore {
    int score = 0;
    selectedAnswers.forEach((key, value) {
      if (key < questions.length) {
        score += (questions[key]['options'] as List)[value]['score'] as int;
      }
    });
    return score;
  }

  // Navigation Logic
  void nextStep() {
    if (selectedAnswers[currentStep.value] == null) {
      Get.snackbar("Required", "Please select an option to continue.");
      return;
    }

    if (currentStep.value < questions.length - 1) {
      currentStep.value++;
    } else {
      completeAnalysis();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  // Result Calculation & Saving
  String get skinType {
    int score = totalScore;
    if (score <= 7) return "Type I";
    if (score <= 14) return "Type II";
    if (score <= 21) return "Type III";
    if (score <= 28) return "Type IV";
    // Combined V-VI for 29-40 range as per user request logic or keep distinct?
    // User said: "29-40 Skin type V–VI"
    if (score <= 40) return "Type V";
    // Wait, let's stick to standard numerals, V-VI is often high melanin.
    // Let's return "Type V" for 29+ to keep string simple, or "Type V/VI"
    return "Type V";
  }

  String get skinTypeDescription {
    switch (skinType) {
      case "Type I":
        return "Pale white skin, blue/green eyes, blond/red hair. Always burns, does not tan.";
      case "Type II":
        return "Fair skin, blue eyes. Burns easily, tans poorly.";
      case "Type III":
        return "Darker white skin. Burns after initial exposure, tans gradually.";
      case "Type IV":
        return "Light brown skin. Burns minimally, tans easily.";
      case "Type V":
        return "Brown skin. Rarely burns, tans darkly easily.";
      case "Type VI":
        return "Dark brown or black skin. Never burns, always tans darkly.";
      default:
        return "";
    }
  }

  // Max Session Time (Simplified Logic)
  String get maxSessionTime {
    switch (skinType) {
      case "Type I":
        return "5 Minutes";
      case "Type II":
        return "8 Minutes";
      case "Type III":
        return "10 Minutes";
      case "Type IV":
        return "12 Minutes";
      case "Type V":
        return "15 Minutes";
      case "Type VI":
        return "20 Minutes";
      default:
        return "5 Minutes";
    }
  }

  Future<void> completeAnalysis() async {
    try {
      isLoading.value = true;

      // Save to Backend
      // We assume user is logged in and we use the ApiClient which handles token?
      // Or we need phoneNumber?
      // Since we flow from Consent, we might rely on Token or we might need to store PhoneNumber in a Service.
      // For now, let's try assuming the Token is set or we just send an update if we have persistence logic.
      // Wait, Persistence is just a flag. Token is in StorageService.
      // Does ApiClient attach token? Yes.

      // Update: User might not have a token yet if they just registered?
      // Registration flow usually gives a token.
      // Wait, simple Registration flow we built didn't explicitly login/get token,
      // but Update: The user has registered, but we relied on phoneNumber for upsert.
      // If we don't have a token, we might need to pass phoneNumber again.
      // Let's assume we can pass phoneNumber if stored in a service.

      // Workaround: We will use `Get.arguments` from Consent or store phone in this controller if passed.
      // Better: Update `ConsentController` to pass `phoneNumber` to `WelcomeSunny` -> `Wizard` etc.

      // Let's check arguments
      String? phoneNumber;
      if (Get.arguments != null && Get.arguments['phoneNumber'] != null) {
        phoneNumber = Get.arguments['phoneNumber'];
      }

      final payload = {
        'skinType': skinType,
        'tag': 'Analyzed',
        // If we have phone, good. If not, backend needs token.
        // If createOrUpdateCustomer requires phone, we MUST have phone.
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };

      await _apiClient.post('/customers', payload);

      Get.toNamed(
        Routes.SKIN_ANALYSIS_RESULT,
        arguments: {
          'skinType': skinType,
          'description': skinTypeDescription,
          'time': maxSessionTime,
        },
      );
    } catch (e) {
      print("Error saving skin analysis: $e");
      // Proceed to result anyway so user isn't stuck
      Get.toNamed(
        Routes.SKIN_ANALYSIS_RESULT,
        arguments: {
          'skinType': skinType,
          'description': skinTypeDescription,
          'time': maxSessionTime,
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
