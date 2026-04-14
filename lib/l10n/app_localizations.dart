import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Plant Diagnosis App!'**
  String get welcomeText;

  /// No description provided for @diagnosePlant.
  ///
  /// In en, this message translates to:
  /// **'Diagnose Plant'**
  String get diagnosePlant;

  /// No description provided for @contactExperts.
  ///
  /// In en, this message translates to:
  /// **'Contact Experts'**
  String get contactExperts;

  /// No description provided for @ourProducts.
  ///
  /// In en, this message translates to:
  /// **'Our Products'**
  String get ourProducts;

  /// No description provided for @awarenessGuide.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Awareness'**
  String get awarenessGuide;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @plantDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Plant Diagnosis'**
  String get plantDiagnosis;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select an image'**
  String get selectImage;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get result;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @experts.
  ///
  /// In en, this message translates to:
  /// **'Experts'**
  String get experts;

  /// No description provided for @expertsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Expert support will be available soon.'**
  String get expertsPlaceholder;

  /// No description provided for @productsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Products list coming soon.'**
  String get productsPlaceholder;

  /// No description provided for @awarenessPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Awareness content will be added.'**
  String get awarenessPlaceholder;

  /// No description provided for @basicFarming.
  ///
  /// In en, this message translates to:
  /// **'Basic Farming'**
  String get basicFarming;

  /// No description provided for @soilAdvice.
  ///
  /// In en, this message translates to:
  /// **'• Choose the right soil: Test every 2 years.'**
  String get soilAdvice;

  /// No description provided for @sunAdvice.
  ///
  /// In en, this message translates to:
  /// **'• Ensure sunlight exposure: 6-8 hours daily.'**
  String get sunAdvice;

  /// No description provided for @wateringAdvice.
  ///
  /// In en, this message translates to:
  /// **'• Water regularly: When top 2–3 cm of soil is dry.'**
  String get wateringAdvice;

  /// No description provided for @diseasePrevention.
  ///
  /// In en, this message translates to:
  /// **'Plant Disease Prevention'**
  String get diseasePrevention;

  /// No description provided for @toolSanitation.
  ///
  /// In en, this message translates to:
  /// **'• Disinfect tools before planting.'**
  String get toolSanitation;

  /// No description provided for @cropRotation.
  ///
  /// In en, this message translates to:
  /// **'• Practice crop rotation yearly.'**
  String get cropRotation;

  /// No description provided for @seedSelection.
  ///
  /// In en, this message translates to:
  /// **'• Use certified healthy seeds.'**
  String get seedSelection;

  /// No description provided for @naturalPestControl.
  ///
  /// In en, this message translates to:
  /// **'Natural Pest Control'**
  String get naturalPestControl;

  /// No description provided for @plantRepellents.
  ///
  /// In en, this message translates to:
  /// **'• Grow pest-repelling plants (e.g., mint, basil).'**
  String get plantRepellents;

  /// No description provided for @organicSprays.
  ///
  /// In en, this message translates to:
  /// **'• Use organic sprays like neem oil.'**
  String get organicSprays;

  /// No description provided for @beneficialInsects.
  ///
  /// In en, this message translates to:
  /// **'• Encourage beneficial insects (e.g., ladybugs).'**
  String get beneficialInsects;

  /// No description provided for @commonDiseases.
  ///
  /// In en, this message translates to:
  /// **'Common Plant Diseases and Treatment'**
  String get commonDiseases;

  /// No description provided for @disease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get disease;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @seasonalTips.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Farming Tips'**
  String get seasonalTips;

  /// No description provided for @spring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get spring;

  /// No description provided for @summer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get summer;

  /// No description provided for @autumn.
  ///
  /// In en, this message translates to:
  /// **'Autumn'**
  String get autumn;

  /// No description provided for @winter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get winter;

  /// No description provided for @spring1.
  ///
  /// In en, this message translates to:
  /// **'Prune flowering plants.'**
  String get spring1;

  /// No description provided for @spring2.
  ///
  /// In en, this message translates to:
  /// **'Add organic compost.'**
  String get spring2;

  /// No description provided for @summer1.
  ///
  /// In en, this message translates to:
  /// **'Water early in the morning.'**
  String get summer1;

  /// No description provided for @summer2.
  ///
  /// In en, this message translates to:
  /// **'Use mulch to retain moisture.'**
  String get summer2;

  /// No description provided for @autumn1.
  ///
  /// In en, this message translates to:
  /// **'Plant winter crops.'**
  String get autumn1;

  /// No description provided for @autumn2.
  ///
  /// In en, this message translates to:
  /// **'Clean up old crop residues.'**
  String get autumn2;

  /// No description provided for @winter1.
  ///
  /// In en, this message translates to:
  /// **'Protect sensitive plants with greenhouses.'**
  String get winter1;

  /// No description provided for @winter2.
  ///
  /// In en, this message translates to:
  /// **'Reduce watering to avoid root rot.'**
  String get winter2;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Trusted Resources'**
  String get resources;

  /// No description provided for @youtubeChannels.
  ///
  /// In en, this message translates to:
  /// **'• YouTube channels: \'Garden Answer\', \'Epic Gardening\''**
  String get youtubeChannels;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get needHelp;

  /// No description provided for @contactExpertsInfo.
  ///
  /// In en, this message translates to:
  /// **'• Use the \'Contact Experts\' feature in the app.'**
  String get contactExpertsInfo;

  /// No description provided for @powderyMildew.
  ///
  /// In en, this message translates to:
  /// **'Powdery mildew'**
  String get powderyMildew;

  /// No description provided for @powderyMildewSymptoms.
  ///
  /// In en, this message translates to:
  /// **'White layer on leaves'**
  String get powderyMildewSymptoms;

  /// No description provided for @powderyMildewTreatment.
  ///
  /// In en, this message translates to:
  /// **'Good ventilation + sulfur spray'**
  String get powderyMildewTreatment;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @pick_camera.
  ///
  /// In en, this message translates to:
  /// **'Pick from Camera'**
  String get pick_camera;

  /// No description provided for @lateBlight.
  ///
  /// In en, this message translates to:
  /// **'Late blight'**
  String get lateBlight;

  /// No description provided for @lateBlightSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Black spots on tomatoes'**
  String get lateBlightSymptoms;

  /// No description provided for @lateBlightTreatment.
  ///
  /// In en, this message translates to:
  /// **'Copper fungicide + remove infected'**
  String get lateBlightTreatment;

  /// No description provided for @rootRot.
  ///
  /// In en, this message translates to:
  /// **'Root rot'**
  String get rootRot;

  /// No description provided for @rootRotSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Yellowing and gradual death'**
  String get rootRotSymptoms;

  /// No description provided for @rootRotTreatment.
  ///
  /// In en, this message translates to:
  /// **'Improve drainage + reduce watering'**
  String get rootRotTreatment;

  /// No description provided for @aphids.
  ///
  /// In en, this message translates to:
  /// **'Aphids'**
  String get aphids;

  /// No description provided for @aphidsSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Small insects sucking sap'**
  String get aphidsSymptoms;

  /// No description provided for @aphidsTreatment.
  ///
  /// In en, this message translates to:
  /// **'Neem spray + soap water'**
  String get aphidsTreatment;

  /// No description provided for @takephoto.
  ///
  /// In en, this message translates to:
  /// **'Take an image'**
  String get takephoto;

  /// No description provided for @selectimages.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectimages;

  /// No description provided for @algal_leaf_spot_jackfruit.
  ///
  /// In en, this message translates to:
  /// **'Algal leaf spot on jackfruit'**
  String get algal_leaf_spot_jackfruit;

  /// No description provided for @algal_leaf_spot_jackfruit_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected leaves and improve air circulation.'**
  String get algal_leaf_spot_jackfruit_treatment;

  /// No description provided for @anthracnose_mango.
  ///
  /// In en, this message translates to:
  /// **'Anthracnose on mango'**
  String get anthracnose_mango;

  /// No description provided for @anthracnose_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply copper-based fungicide and prune infected parts.'**
  String get anthracnose_mango_treatment;

  /// No description provided for @aphids_cotton.
  ///
  /// In en, this message translates to:
  /// **'Aphids on cotton'**
  String get aphids_cotton;

  /// No description provided for @aphids_cotton_treatment.
  ///
  /// In en, this message translates to:
  /// **'Use neem oil or a suitable insecticide.'**
  String get aphids_cotton_treatment;

  /// No description provided for @apple_scab_apple.
  ///
  /// In en, this message translates to:
  /// **'Apple scab'**
  String get apple_scab_apple;

  /// No description provided for @apple_scab_apple_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply preventive fungicide sprays.'**
  String get apple_scab_apple_treatment;

  /// No description provided for @bacterial_blight_cotton.
  ///
  /// In en, this message translates to:
  /// **'Bacterial blight on cotton'**
  String get bacterial_blight_cotton;

  /// No description provided for @bacterial_blight_cotton_treatment.
  ///
  /// In en, this message translates to:
  /// **'Use resistant varieties and avoid overhead irrigation.'**
  String get bacterial_blight_cotton_treatment;

  /// No description provided for @bacterial_canker_mango.
  ///
  /// In en, this message translates to:
  /// **'Bacterial canker on mango'**
  String get bacterial_canker_mango;

  /// No description provided for @bacterial_canker_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'Prune infected branches and apply copper spray.'**
  String get bacterial_canker_mango_treatment;

  /// No description provided for @bacterial_leaf_spot_pumpkin.
  ///
  /// In en, this message translates to:
  /// **'Bacterial leaf spot on pumpkin'**
  String get bacterial_leaf_spot_pumpkin;

  /// No description provided for @bacterial_leaf_spot_pumpkin_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected plants and rotate crops.'**
  String get bacterial_leaf_spot_pumpkin_treatment;

  /// No description provided for @bacterial_spot_peach.
  ///
  /// In en, this message translates to:
  /// **'Bacterial spot on peach'**
  String get bacterial_spot_peach;

  /// No description provided for @bacterial_spot_peach_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply bactericide and remove infected leaves.'**
  String get bacterial_spot_peach_treatment;

  /// No description provided for @bacterial_spot_pepper_bell.
  ///
  /// In en, this message translates to:
  /// **'Bacterial spot on bell pepper'**
  String get bacterial_spot_pepper_bell;

  /// No description provided for @bacterial_spot_pepper_bell_treatment.
  ///
  /// In en, this message translates to:
  /// **'Use clean seeds and copper-based sprays.'**
  String get bacterial_spot_pepper_bell_treatment;

  /// No description provided for @bacterial_spot_tomato.
  ///
  /// In en, this message translates to:
  /// **'Bacterial spot on tomato'**
  String get bacterial_spot_tomato;

  /// No description provided for @bacterial_spot_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Avoid wetting leaves and apply copper spray.'**
  String get bacterial_spot_tomato_treatment;

  /// No description provided for @black_rot_cauliflower.
  ///
  /// In en, this message translates to:
  /// **'Black rot on cauliflower'**
  String get black_rot_cauliflower;

  /// No description provided for @black_rot_cauliflower_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected plants and improve drainage.'**
  String get black_rot_cauliflower_treatment;

  /// No description provided for @black_spot_jackfruit.
  ///
  /// In en, this message translates to:
  /// **'Black spot on jackfruit'**
  String get black_spot_jackfruit;

  /// No description provided for @black_spot_jackfruit_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected leaves and apply fungicide.'**
  String get black_spot_jackfruit_treatment;

  /// No description provided for @black_rot_apple.
  ///
  /// In en, this message translates to:
  /// **'Black rot on apple'**
  String get black_rot_apple;

  /// No description provided for @black_rot_apple_treatment.
  ///
  /// In en, this message translates to:
  /// **'Prune infected parts and apply fungicide.'**
  String get black_rot_apple_treatment;

  /// No description provided for @black_rot_grape.
  ///
  /// In en, this message translates to:
  /// **'Black rot on grape'**
  String get black_rot_grape;

  /// No description provided for @black_rot_grape_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected clusters and apply fungicide.'**
  String get black_rot_grape_treatment;

  /// No description provided for @brown_spot_rice.
  ///
  /// In en, this message translates to:
  /// **'Brown spot on rice'**
  String get brown_spot_rice;

  /// No description provided for @brown_spot_rice_treatment.
  ///
  /// In en, this message translates to:
  /// **'Balanced fertilization and fungicide application.'**
  String get brown_spot_rice_treatment;

  /// No description provided for @cedar_apple_rust_apple.
  ///
  /// In en, this message translates to:
  /// **'Cedar apple rust'**
  String get cedar_apple_rust_apple;

  /// No description provided for @cedar_apple_rust_apple_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove nearby hosts and apply fungicide.'**
  String get cedar_apple_rust_apple_treatment;

  /// No description provided for @cercospora_leaf_spot_gray_leaf_spot_corn_maize.
  ///
  /// In en, this message translates to:
  /// **'Cercospora leaf spot / Gray leaf spot on maize'**
  String get cercospora_leaf_spot_gray_leaf_spot_corn_maize;

  /// No description provided for @cercospora_leaf_spot_gray_leaf_spot_corn_maize_treatment.
  ///
  /// In en, this message translates to:
  /// **'Plant resistant varieties and apply fungicide.'**
  String get cercospora_leaf_spot_gray_leaf_spot_corn_maize_treatment;

  /// No description provided for @common_rust_corn_maize.
  ///
  /// In en, this message translates to:
  /// **'Common rust on maize'**
  String get common_rust_corn_maize;

  /// No description provided for @common_rust_corn_maize_treatment.
  ///
  /// In en, this message translates to:
  /// **'Use resistant hybrids.'**
  String get common_rust_corn_maize_treatment;

  /// No description provided for @cutting_weevil_mango.
  ///
  /// In en, this message translates to:
  /// **'Cutting weevil on mango'**
  String get cutting_weevil_mango;

  /// No description provided for @cutting_weevil_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected branches and apply insecticide.'**
  String get cutting_weevil_mango_treatment;

  /// No description provided for @die_back_mango.
  ///
  /// In en, this message translates to:
  /// **'Dieback on mango'**
  String get die_back_mango;

  /// No description provided for @die_back_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'Prune affected parts and improve nutrition.'**
  String get die_back_mango_treatment;

  /// No description provided for @downy_mildew_pumpkin.
  ///
  /// In en, this message translates to:
  /// **'Downy mildew on pumpkin'**
  String get downy_mildew_pumpkin;

  /// No description provided for @downy_mildew_pumpkin_treatment.
  ///
  /// In en, this message translates to:
  /// **'Improve ventilation and apply fungicide.'**
  String get downy_mildew_pumpkin_treatment;

  /// No description provided for @early_blight_potato.
  ///
  /// In en, this message translates to:
  /// **'Early blight on potato'**
  String get early_blight_potato;

  /// No description provided for @early_blight_potato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected leaves and apply fungicide.'**
  String get early_blight_potato_treatment;

  /// No description provided for @early_blight_tomato.
  ///
  /// In en, this message translates to:
  /// **'Early blight on tomato'**
  String get early_blight_tomato;

  /// No description provided for @early_blight_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Use mulch and preventive spraying.'**
  String get early_blight_tomato_treatment;

  /// No description provided for @esca_black_measles_grape.
  ///
  /// In en, this message translates to:
  /// **'Esca (Black measles) on grape'**
  String get esca_black_measles_grape;

  /// No description provided for @esca_black_measles_grape_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected vines and protect pruning wounds.'**
  String get esca_black_measles_grape_treatment;

  /// No description provided for @gall_midge_mango.
  ///
  /// In en, this message translates to:
  /// **'Gall midge on mango'**
  String get gall_midge_mango;

  /// No description provided for @gall_midge_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply insecticide during flowering.'**
  String get gall_midge_mango_treatment;

  /// No description provided for @haunglongbing_citrus_greening_orange.
  ///
  /// In en, this message translates to:
  /// **'Citrus greening (HLB) on orange'**
  String get haunglongbing_citrus_greening_orange;

  /// No description provided for @haunglongbing_citrus_greening_orange_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected trees and control insect vectors.'**
  String get haunglongbing_citrus_greening_orange_treatment;

  /// No description provided for @healthy_cauliflower.
  ///
  /// In en, this message translates to:
  /// **'Healthy cauliflower plant'**
  String get healthy_cauliflower;

  /// No description provided for @healthy_cauliflower_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_cauliflower_treatment;

  /// No description provided for @healthy_cotton.
  ///
  /// In en, this message translates to:
  /// **'Healthy cotton plant'**
  String get healthy_cotton;

  /// No description provided for @healthy_cotton_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_cotton_treatment;

  /// No description provided for @healthy_jackfruit.
  ///
  /// In en, this message translates to:
  /// **'Healthy jackfruit plant'**
  String get healthy_jackfruit;

  /// No description provided for @healthy_jackfruit_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_jackfruit_treatment;

  /// No description provided for @healthy_mango.
  ///
  /// In en, this message translates to:
  /// **'Healthy mango plant'**
  String get healthy_mango;

  /// No description provided for @healthy_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_mango_treatment;

  /// No description provided for @healthy_rice.
  ///
  /// In en, this message translates to:
  /// **'Healthy rice plant'**
  String get healthy_rice;

  /// No description provided for @healthy_rice_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_rice_treatment;

  /// No description provided for @healthy_sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Healthy sugarcane plant'**
  String get healthy_sugarcane;

  /// No description provided for @healthy_sugarcane_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_sugarcane_treatment;

  /// No description provided for @healthy_leaf_pumpkin.
  ///
  /// In en, this message translates to:
  /// **'Healthy pumpkin leaf'**
  String get healthy_leaf_pumpkin;

  /// No description provided for @healthy_leaf_pumpkin_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_leaf_pumpkin_treatment;

  /// No description provided for @hispa_rice.
  ///
  /// In en, this message translates to:
  /// **'Rice hispa insect'**
  String get hispa_rice;

  /// No description provided for @hispa_rice_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply recommended insecticide.'**
  String get hispa_rice_treatment;

  /// No description provided for @late_blight_potato.
  ///
  /// In en, this message translates to:
  /// **'Late blight on potato'**
  String get late_blight_potato;

  /// No description provided for @late_blight_potato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected plants and apply fungicide.'**
  String get late_blight_potato_treatment;

  /// No description provided for @late_blight_tomato.
  ///
  /// In en, this message translates to:
  /// **'Late blight on tomato'**
  String get late_blight_tomato;

  /// No description provided for @late_blight_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Avoid overhead irrigation and apply fungicide.'**
  String get late_blight_tomato_treatment;

  /// No description provided for @leaf_mold_tomato.
  ///
  /// In en, this message translates to:
  /// **'Leaf mold on tomato'**
  String get leaf_mold_tomato;

  /// No description provided for @leaf_mold_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Reduce humidity and improve ventilation.'**
  String get leaf_mold_tomato_treatment;

  /// No description provided for @leaf_blight_isariopsis_leaf_spot_grape.
  ///
  /// In en, this message translates to:
  /// **'Leaf blight on grape'**
  String get leaf_blight_isariopsis_leaf_spot_grape;

  /// No description provided for @leaf_blight_isariopsis_leaf_spot_grape_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected leaves and apply fungicide.'**
  String get leaf_blight_isariopsis_leaf_spot_grape_treatment;

  /// No description provided for @leaf_scorch_strawberry.
  ///
  /// In en, this message translates to:
  /// **'Leaf scorch on strawberry'**
  String get leaf_scorch_strawberry;

  /// No description provided for @leaf_scorch_strawberry_treatment.
  ///
  /// In en, this message translates to:
  /// **'Improve fertilization and remove infected leaves.'**
  String get leaf_scorch_strawberry_treatment;

  /// No description provided for @leaf_blast_rice.
  ///
  /// In en, this message translates to:
  /// **'Leaf blast on rice'**
  String get leaf_blast_rice;

  /// No description provided for @leaf_blast_rice_treatment.
  ///
  /// In en, this message translates to:
  /// **'Plant resistant varieties and apply fungicide.'**
  String get leaf_blast_rice_treatment;

  /// No description provided for @mosaic_sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Mosaic disease on sugarcane'**
  String get mosaic_sugarcane;

  /// No description provided for @mosaic_sugarcane_treatment.
  ///
  /// In en, this message translates to:
  /// **'Use healthy planting material.'**
  String get mosaic_sugarcane_treatment;

  /// No description provided for @mosaic_disease_pumpkin.
  ///
  /// In en, this message translates to:
  /// **'Mosaic disease on pumpkin'**
  String get mosaic_disease_pumpkin;

  /// No description provided for @mosaic_disease_pumpkin_treatment.
  ///
  /// In en, this message translates to:
  /// **'Control aphids and remove infected plants.'**
  String get mosaic_disease_pumpkin_treatment;

  /// No description provided for @northern_leaf_blight_corn_maize.
  ///
  /// In en, this message translates to:
  /// **'Northern leaf blight on maize'**
  String get northern_leaf_blight_corn_maize;

  /// No description provided for @northern_leaf_blight_corn_maize_treatment.
  ///
  /// In en, this message translates to:
  /// **'Plant resistant hybrids and apply fungicide.'**
  String get northern_leaf_blight_corn_maize_treatment;

  /// No description provided for @powdery_mildew_cotton.
  ///
  /// In en, this message translates to:
  /// **'Powdery mildew on cotton'**
  String get powdery_mildew_cotton;

  /// No description provided for @powdery_mildew_cotton_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply sulfur-based fungicide.'**
  String get powdery_mildew_cotton_treatment;

  /// No description provided for @powdery_mildew_mango.
  ///
  /// In en, this message translates to:
  /// **'Powdery mildew on mango'**
  String get powdery_mildew_mango;

  /// No description provided for @powdery_mildew_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'Spray fungicide during flowering.'**
  String get powdery_mildew_mango_treatment;

  /// No description provided for @powdery_mildew_pumpkin.
  ///
  /// In en, this message translates to:
  /// **'Powdery mildew on pumpkin'**
  String get powdery_mildew_pumpkin;

  /// No description provided for @powdery_mildew_pumpkin_treatment.
  ///
  /// In en, this message translates to:
  /// **'Improve ventilation and spray fungicide.'**
  String get powdery_mildew_pumpkin_treatment;

  /// No description provided for @powdery_mildew_qaad.
  ///
  /// In en, this message translates to:
  /// **'Powdery mildew'**
  String get powdery_mildew_qaad;

  /// No description provided for @powdery_mildew_qaad_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply suitable fungicide.'**
  String get powdery_mildew_qaad_treatment;

  /// No description provided for @powdery_mildew_cherry_sour.
  ///
  /// In en, this message translates to:
  /// **'Powdery mildew on cherry'**
  String get powdery_mildew_cherry_sour;

  /// No description provided for @powdery_mildew_cherry_sour_treatment.
  ///
  /// In en, this message translates to:
  /// **'Prune infected parts and spray fungicide.'**
  String get powdery_mildew_cherry_sour_treatment;

  /// No description provided for @red_rot_sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Red rot on sugarcane'**
  String get red_rot_sugarcane;

  /// No description provided for @red_rot_sugarcane_treatment.
  ///
  /// In en, this message translates to:
  /// **'Use resistant varieties.'**
  String get red_rot_sugarcane_treatment;

  /// No description provided for @rust_sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Rust on sugarcane'**
  String get rust_sugarcane;

  /// No description provided for @rust_sugarcane_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply fungicide and improve field hygiene.'**
  String get rust_sugarcane_treatment;

  /// No description provided for @septoria_leaf_spot_tomato.
  ///
  /// In en, this message translates to:
  /// **'Septoria leaf spot on tomato'**
  String get septoria_leaf_spot_tomato;

  /// No description provided for @septoria_leaf_spot_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected leaves and apply fungicide.'**
  String get septoria_leaf_spot_tomato_treatment;

  /// No description provided for @sooty_mould_mango.
  ///
  /// In en, this message translates to:
  /// **'Sooty mould on mango'**
  String get sooty_mould_mango;

  /// No description provided for @sooty_mould_mango_treatment.
  ///
  /// In en, this message translates to:
  /// **'Control honeydew-producing insects.'**
  String get sooty_mould_mango_treatment;

  /// No description provided for @spider_mites_two_spotted_spider_mite_tomato.
  ///
  /// In en, this message translates to:
  /// **'Two-spotted spider mites on tomato'**
  String get spider_mites_two_spotted_spider_mite_tomato;

  /// No description provided for @spider_mites_two_spotted_spider_mite_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Apply acaricide.'**
  String get spider_mites_two_spotted_spider_mite_tomato_treatment;

  /// No description provided for @target_spot_tomato.
  ///
  /// In en, this message translates to:
  /// **'Target spot on tomato'**
  String get target_spot_tomato;

  /// No description provided for @target_spot_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Remove infected leaves and apply fungicide.'**
  String get target_spot_tomato_treatment;

  /// No description provided for @target_spot_cotton.
  ///
  /// In en, this message translates to:
  /// **'Target spot on cotton'**
  String get target_spot_cotton;

  /// No description provided for @target_spot_cotton_treatment.
  ///
  /// In en, this message translates to:
  /// **'Crop rotation and fungicide application.'**
  String get target_spot_cotton_treatment;

  /// No description provided for @tomato_yellow_leaf_curl_virus_tomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato yellow leaf curl virus'**
  String get tomato_yellow_leaf_curl_virus_tomato;

  /// No description provided for @tomato_yellow_leaf_curl_virus_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Control whiteflies.'**
  String get tomato_yellow_leaf_curl_virus_tomato_treatment;

  /// No description provided for @tomato_mosaic_virus_tomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato mosaic virus'**
  String get tomato_mosaic_virus_tomato;

  /// No description provided for @tomato_mosaic_virus_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'Disinfect tools and remove infected plants.'**
  String get tomato_mosaic_virus_tomato_treatment;

  /// No description provided for @yellow_sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Yellowing disease of sugarcane'**
  String get yellow_sugarcane;

  /// No description provided for @yellow_sugarcane_treatment.
  ///
  /// In en, this message translates to:
  /// **'Improve fertilization and drainage.'**
  String get yellow_sugarcane_treatment;

  /// No description provided for @healthy_apple.
  ///
  /// In en, this message translates to:
  /// **'Healthy apple plant'**
  String get healthy_apple;

  /// No description provided for @healthy_apple_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_apple_treatment;

  /// No description provided for @healthy_blueberry.
  ///
  /// In en, this message translates to:
  /// **'Healthy blueberry plant'**
  String get healthy_blueberry;

  /// No description provided for @healthy_blueberry_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_blueberry_treatment;

  /// No description provided for @healthy_cherry_sour.
  ///
  /// In en, this message translates to:
  /// **'Healthy cherry plant'**
  String get healthy_cherry_sour;

  /// No description provided for @healthy_cherry_sour_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_cherry_sour_treatment;

  /// No description provided for @healthy_corn_maize.
  ///
  /// In en, this message translates to:
  /// **'Healthy maize plant'**
  String get healthy_corn_maize;

  /// No description provided for @healthy_corn_maize_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_corn_maize_treatment;

  /// No description provided for @healthy_grape.
  ///
  /// In en, this message translates to:
  /// **'Healthy grape plant'**
  String get healthy_grape;

  /// No description provided for @healthy_grape_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_grape_treatment;

  /// No description provided for @healthy_peach.
  ///
  /// In en, this message translates to:
  /// **'Healthy peach plant'**
  String get healthy_peach;

  /// No description provided for @healthy_peach_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_peach_treatment;

  /// No description provided for @healthy_pepper_bell.
  ///
  /// In en, this message translates to:
  /// **'Healthy bell pepper plant'**
  String get healthy_pepper_bell;

  /// No description provided for @healthy_pepper_bell_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_pepper_bell_treatment;

  /// No description provided for @healthy_potato.
  ///
  /// In en, this message translates to:
  /// **'Healthy potato plant'**
  String get healthy_potato;

  /// No description provided for @healthy_potato_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_potato_treatment;

  /// No description provided for @healthy_raspberry.
  ///
  /// In en, this message translates to:
  /// **'Healthy raspberry plant'**
  String get healthy_raspberry;

  /// No description provided for @healthy_raspberry_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_raspberry_treatment;

  /// No description provided for @healthy_soybean.
  ///
  /// In en, this message translates to:
  /// **'Healthy soybean plant'**
  String get healthy_soybean;

  /// No description provided for @healthy_soybean_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_soybean_treatment;

  /// No description provided for @healthy_strawberry.
  ///
  /// In en, this message translates to:
  /// **'Healthy strawberry plant'**
  String get healthy_strawberry;

  /// No description provided for @healthy_strawberry_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_strawberry_treatment;

  /// No description provided for @healthy_tomato.
  ///
  /// In en, this message translates to:
  /// **'Healthy tomato plant'**
  String get healthy_tomato;

  /// No description provided for @healthy_tomato_treatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment needed.'**
  String get healthy_tomato_treatment;

  /// No description provided for @unknown_disease.
  ///
  /// In en, this message translates to:
  /// **'Unknown disease / non-plant image'**
  String get unknown_disease;

  /// No description provided for @unknown_disease_treatment.
  ///
  /// In en, this message translates to:
  /// **'Please capture a clear plant leaf image with good lighting.'**
  String get unknown_disease_treatment;

  /// No description provided for @diagnosis_failed.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis failed'**
  String get diagnosis_failed;

  /// No description provided for @pestsDiseases.
  ///
  /// In en, this message translates to:
  /// **'Pests & Diseases'**
  String get pestsDiseases;

  /// No description provided for @pestsDiseases1.
  ///
  /// In en, this message translates to:
  /// **'Pests and Diseases'**
  String get pestsDiseases1;

  /// No description provided for @selectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get selectCrop;

  /// No description provided for @noCropSelected.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop'**
  String get noCropSelected;

  /// No description provided for @stage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stage;

  /// No description provided for @noDiseases.
  ///
  /// In en, this message translates to:
  /// **'No diseases found'**
  String get noDiseases;

  /// No description provided for @diseaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Disease Details'**
  String get diseaseDetails;

  /// No description provided for @cause.
  ///
  /// In en, this message translates to:
  /// **'Cause'**
  String get cause;

  /// No description provided for @preventiveMeasures.
  ///
  /// In en, this message translates to:
  /// **'Preventive Measures'**
  String get preventiveMeasures;

  /// No description provided for @chemicalTreatment.
  ///
  /// In en, this message translates to:
  /// **'Chemical Treatment'**
  String get chemicalTreatment;

  /// No description provided for @alternativeTreatment.
  ///
  /// In en, this message translates to:
  /// **'Alternative Treatment'**
  String get alternativeTreatment;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Diagnosis'**
  String get appTitle;

  /// No description provided for @awareness.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get awareness;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @selectCropFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop first'**
  String get selectCropFirst;

  /// No description provided for @noDiseasesFound.
  ///
  /// In en, this message translates to:
  /// **'No diseases found for this stage'**
  String get noDiseasesFound;

  /// No description provided for @selectStage.
  ///
  /// In en, this message translates to:
  /// **'Select Stage'**
  String get selectStage;

  /// No description provided for @causes.
  ///
  /// In en, this message translates to:
  /// **'Causes'**
  String get causes;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading data'**
  String get errorLoadingData;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noPreviousDiagnoses.
  ///
  /// In en, this message translates to:
  /// **'No items to display currently'**
  String get noPreviousDiagnoses;

  /// No description provided for @previousDiagnos.
  ///
  /// In en, this message translates to:
  /// **'Previous Diagnoses'**
  String get previousDiagnos;

  /// No description provided for @farmer_page_title.
  ///
  /// In en, this message translates to:
  /// **'Farmer Questions'**
  String get farmer_page_title;

  /// No description provided for @tab_unanswered.
  ///
  /// In en, this message translates to:
  /// **'unanswerd question'**
  String get tab_unanswered;

  /// No description provided for @tab_answered.
  ///
  /// In en, this message translates to:
  /// **'answerd question'**
  String get tab_answered;

  /// No description provided for @label_write_question.
  ///
  /// In en, this message translates to:
  /// **'Write your question here'**
  String get label_write_question;

  /// No description provided for @button_pick_image.
  ///
  /// In en, this message translates to:
  /// **'Pick an Image'**
  String get button_pick_image;

  /// No description provided for @button_send_question.
  ///
  /// In en, this message translates to:
  /// **'Send Query'**
  String get button_send_question;

  /// No description provided for @snackbar_question_sent.
  ///
  /// In en, this message translates to:
  /// **'Your Query has been sent successfully!'**
  String get snackbar_question_sent;

  /// No description provided for @label_question.
  ///
  /// In en, this message translates to:
  /// **'Question:'**
  String get label_question;

  /// No description provided for @label_answer.
  ///
  /// In en, this message translates to:
  /// **'Answer:'**
  String get label_answer;

  /// No description provided for @filter_comment.
  ///
  /// In en, this message translates to:
  /// **'Filter by current farmer'**
  String get filter_comment;

  /// No description provided for @previousQuestions.
  ///
  /// In en, this message translates to:
  /// **'Answered Questions'**
  String get previousQuestions;

  /// No description provided for @pendingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Pending Questions'**
  String get pendingQuestions;

  /// No description provided for @button_record_audio.
  ///
  /// In en, this message translates to:
  /// **'Record Audio'**
  String get button_record_audio;

  /// No description provided for @button_stop_recording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get button_stop_recording;

  /// No description provided for @label_audio_attached.
  ///
  /// In en, this message translates to:
  /// **'Audio attached'**
  String get label_audio_attached;

  /// No description provided for @label_play_question_audio.
  ///
  /// In en, this message translates to:
  /// **'play question audio'**
  String get label_play_question_audio;

  /// No description provided for @label_play_answer_audio.
  ///
  /// In en, this message translates to:
  /// **'play answer audio'**
  String get label_play_answer_audio;

  /// No description provided for @label_question_audio.
  ///
  /// In en, this message translates to:
  /// **'question'**
  String get label_question_audio;

  /// No description provided for @label_answer_audio.
  ///
  /// In en, this message translates to:
  /// **'expert reply'**
  String get label_answer_audio;

  /// No description provided for @label_delete_audio.
  ///
  /// In en, this message translates to:
  /// **'Delet'**
  String get label_delete_audio;

  /// No description provided for @label_no_image.
  ///
  /// In en, this message translates to:
  /// **'no image found'**
  String get label_no_image;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'enter question'**
  String get enterQuestion;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'upload file'**
  String get uploading;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use the app'**
  String get howToUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @howToUseApp.
  ///
  /// In en, this message translates to:
  /// **'How the App Works'**
  String get howToUseApp;

  /// No description provided for @help_intro.
  ///
  /// In en, this message translates to:
  /// **'The main screen consists of five buttons:'**
  String get help_intro;

  /// No description provided for @help_diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Opens AI diagnosis using plant images.\n\nThe app may request location permission.\n\nTo diagnose:\n- Pick image\n- Camera or gallery (recommended)\n\nYou can send the same image to experts.\n\nResult appears instantly with accuracy and treatment.'**
  String get help_diagnosis;

  /// No description provided for @help_experts.
  ///
  /// In en, this message translates to:
  /// **'Farmers can send:\n- Text\n- Image\n- Voice\n\nYou can review or delete audio.\n\nAfter sending:\n- Appears in pending\n- Notification on reply\n- Reply appears (text or audio)'**
  String get help_experts;

  /// No description provided for @help_pests.
  ///
  /// In en, this message translates to:
  /// **'Contains detailed info:\n\nSymptoms - Causes - Organic control - Chemical control - Prevention\n\nSelect crop → stage → disease.'**
  String get help_pests;

  /// No description provided for @help_awareness.
  ///
  /// In en, this message translates to:
  /// **'Provides short awareness content.'**
  String get help_awareness;

  /// No description provided for @help_language.
  ///
  /// In en, this message translates to:
  /// **'Supports Arabic and English with instant switch.'**
  String get help_language;

  /// No description provided for @help_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings button to open privacy policy and help.'**
  String get help_settings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
