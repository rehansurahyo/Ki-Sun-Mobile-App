import 'package:get/get.dart';
import 'app_routes.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/onboarding/bindings/onboarding_binding.dart';
import '../../modules/kyc/views/kyc_intro_view.dart';
import '../../modules/kyc/views/kyc_scan_front_view.dart';
import '../../modules/kyc/views/kyc_scan_back_view.dart';
import '../../modules/kyc/views/kyc_result_view.dart';
import '../../modules/kyc/views/kyc_completion_view.dart';
import '../../modules/auth/views/registration_view.dart';
import '../../modules/home/bindings/dashboard_binding.dart';
import '../../modules/home/views/access_qr_view.dart';
import '../../modules/home/views/studio_guide_view.dart';
import '../../modules/booking/bindings/booking_binding.dart';
import '../../modules/booking/views/booking_view.dart';
import '../../modules/booking/views/payment_view.dart';
import '../../modules/booking/views/booking_history_view.dart';
import '../../modules/booking/views/booking_confirmation_view.dart';
import '../../modules/booking/views/booking_details_view.dart';
import '../../modules/kyc/bindings/kyc_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/otp_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/consent/views/consent_view.dart';
import '../../modules/consent/views/manage_consent_view.dart';
import '../../modules/consent/bindings/consent_binding.dart';
import '../../modules/skin_analysis/views/welcome_sunny_view.dart';
import '../../modules/skin_analysis/views/skin_analysis_wizard_view.dart';
import '../../modules/skin_analysis/views/skin_type_result_view.dart';
import '../../modules/skin_analysis/bindings/skin_analysis_binding.dart';
import '../../modules/membership/views/membership_plans_view.dart';
import '../../modules/membership/bindings/membership_binding.dart';

import '../../modules/profile/bindings/profile_binding.dart';
import '../../modules/profile/views/profile_view.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.KYC_INTRO,
      page: () => const KYCIntroView(),
      binding: KYCBinding(),
    ),
    GetPage(
      name: Routes.KYC_SCAN_FRONT,
      page: () => const KYCScanFrontView(),
      binding: KYCBinding(),
    ),
    GetPage(
      name: Routes.KYC_SCAN_BACK,
      page: () => const KycScanBackView(),
      binding: KYCBinding(),
    ),
    GetPage(
      name: Routes.KYC_RESULT,
      page: () => const KYCResultView(),
      binding: KYCBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.BOOKING_HISTORY,
      page: () => const BookingHistoryView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.AUTH_LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.AUTH_OTP,
      page: () => const OtpView(),
      binding: AuthBinding(), // Reuse binding or separate
    ),
    GetPage(
      name: Routes.CONSENT,
      page: () => const ConsentView(), // Keep original entry consent
      binding: ConsentBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_CONSENT,
      page: () => const ManageConsentView(),
      binding: ConsentBinding(),
    ),
    GetPage(
      name: Routes.WELCOME_SUNNY,
      page: () => const WelcomeSunnyView(),
      binding: SkinAnalysisBinding(),
    ),
    GetPage(
      name: Routes.SKIN_ANALYSIS_WIZARD,
      page: () => const SkinAnalysisWizardView(),
      binding: SkinAnalysisBinding(),
    ),
    GetPage(
      name: Routes.SKIN_ANALYSIS_RESULT,
      page: () => const SkinTypeResultView(),
      binding: SkinAnalysisBinding(),
    ),
    GetPage(
      name: Routes.MEMBERSHIP_PLANS,
      page: () => const MembershipPlansView(),
      binding: MembershipBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.KYC_COMPLETION,
      page: () => const KYCCompletionView(),
      binding: KYCBinding(),
    ),
    GetPage(
      name: Routes.AUTH_REGISTER,
      page: () => const RegistrationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.AUTH_REGISTER,
      page: () => const RegistrationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.BOOKING_CONFIRMATION,
      page: () => const BookingConfirmationView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.BOOKING_DETAILS,
      page: () => const BookingDetailsView(),
      binding: BookingBinding(),
    ),
    GetPage(name: Routes.ACCESS_QR, page: () => const AccessQRView()),
    GetPage(name: Routes.STUDIO_GUIDE, page: () => const StudioGuideView()),
  ];
}
