import 'package:flutter/widgets.dart';
import 'package:plant_diagnosis_app/l10n/app_localizations.dart';

class LocalizationHelper {
  static Map<String, String> getDiseaseMap(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return {
      "algal_leaf_spot_jackfruit": loc.algal_leaf_spot_jackfruit,
      "algal_leaf_spot_jackfruit_treatment": loc.algal_leaf_spot_jackfruit_treatment,

      "anthracnose_mango": loc.anthracnose_mango,
      "anthracnose_mango_treatment": loc.anthracnose_mango_treatment,

      "aphids_cotton": loc.aphids_cotton,
      "aphids_cotton_treatment": loc.aphids_cotton_treatment,

      "apple_scab_apple": loc.apple_scab_apple,
      "apple_scab_apple_treatment": loc.apple_scab_apple_treatment,

      "bacterial_blight_cotton": loc.bacterial_blight_cotton,
      "bacterial_blight_cotton_treatment": loc.bacterial_blight_cotton_treatment,

      "bacterial_canker_mango": loc.bacterial_canker_mango,
      "bacterial_canker_mango_treatment": loc.bacterial_canker_mango_treatment,

      "bacterial_leaf_spot_pumpkin": loc.bacterial_leaf_spot_pumpkin,
      "bacterial_leaf_spot_pumpkin_treatment": loc.bacterial_leaf_spot_pumpkin_treatment,

      "bacterial_spot_peach": loc.bacterial_spot_peach,
      "bacterial_spot_peach_treatment": loc.bacterial_spot_peach_treatment,

      "bacterial_spot_pepper_bell": loc.bacterial_spot_pepper_bell,
      "bacterial_spot_pepper_bell_treatment": loc.bacterial_spot_pepper_bell_treatment,

      "bacterial_spot_tomato": loc.bacterial_spot_tomato,
      "bacterial_spot_tomato_treatment": loc.bacterial_spot_tomato_treatment,

      "black_rot_cauliflower": loc.black_rot_cauliflower,
      "black_rot_cauliflower_treatment": loc.black_rot_cauliflower_treatment,

      "black_spot_jackfruit": loc.black_spot_jackfruit,
      "black_spot_jackfruit_treatment": loc.black_spot_jackfruit_treatment,

      "black_rot_apple": loc.black_rot_apple,
      "black_rot_apple_treatment": loc.black_rot_apple_treatment,

      "black_rot_grape": loc.black_rot_grape,
      "black_rot_grape_treatment": loc.black_rot_grape_treatment,

      "brown_spot_rice": loc.brown_spot_rice,
      "brown_spot_rice_treatment": loc.brown_spot_rice_treatment,

      "cedar_apple_rust_apple": loc.cedar_apple_rust_apple,
      "cedar_apple_rust_apple_treatment": loc.cedar_apple_rust_apple_treatment,

      "cercospora_leaf_spot_gray_leaf_spot_corn_maize":
          loc.cercospora_leaf_spot_gray_leaf_spot_corn_maize,
      "cercospora_leaf_spot_gray_leaf_spot_corn_maize_treatment":
          loc.cercospora_leaf_spot_gray_leaf_spot_corn_maize_treatment,

      "common_rust_corn_maize": loc.common_rust_corn_maize,
      "common_rust_corn_maize_treatment": loc.common_rust_corn_maize_treatment,

      "cutting_weevil_mango": loc.cutting_weevil_mango,
      "cutting_weevil_mango_treatment": loc.cutting_weevil_mango_treatment,

      "die_back_mango": loc.die_back_mango,
      "die_back_mango_treatment": loc.die_back_mango_treatment,

      "downy_mildew_pumpkin": loc.downy_mildew_pumpkin,
      "downy_mildew_pumpkin_treatment": loc.downy_mildew_pumpkin_treatment,

      "early_blight_potato": loc.early_blight_potato,
      "early_blight_potato_treatment": loc.early_blight_potato_treatment,

      "early_blight_tomato": loc.early_blight_tomato,
      "early_blight_tomato_treatment": loc.early_blight_tomato_treatment,

      "esca_black_measles_grape": loc.esca_black_measles_grape,
      "esca_black_measles_grape_treatment": loc.esca_black_measles_grape_treatment,

      "gall_midge_mango": loc.gall_midge_mango,
      "gall_midge_mango_treatment": loc.gall_midge_mango_treatment,

      "haunglongbing_citrus_greening_orange":
          loc.haunglongbing_citrus_greening_orange,
      "haunglongbing_citrus_greening_orange_treatment":
          loc.haunglongbing_citrus_greening_orange_treatment,

      "hispa_rice": loc.hispa_rice,
      "hispa_rice_treatment": loc.hispa_rice_treatment,

      "leaf_blast_rice": loc.leaf_blast_rice,
      "leaf_blast_rice_treatment": loc.leaf_blast_rice_treatment,

      "leaf_mold_tomato": loc.leaf_mold_tomato,
      "leaf_mold_tomato_treatment": loc.leaf_mold_tomato_treatment,

      "leaf_blight_isariopsis_leaf_spot_grape":
          loc.leaf_blight_isariopsis_leaf_spot_grape,
      "leaf_blight_isariopsis_leaf_spot_grape_treatment":
          loc.leaf_blight_isariopsis_leaf_spot_grape_treatment,

      "leaf_scorch_strawberry": loc.leaf_scorch_strawberry,
      "leaf_scorch_strawberry_treatment": loc.leaf_scorch_strawberry_treatment,

      "late_blight_potato": loc.late_blight_potato,
      "late_blight_potato_treatment": loc.late_blight_potato_treatment,

      "late_blight_tomato": loc.late_blight_tomato,
      "late_blight_tomato_treatment": loc.late_blight_tomato_treatment,

      "mosaic_sugarcane": loc.mosaic_sugarcane,
      "mosaic_sugarcane_treatment": loc.mosaic_sugarcane_treatment,

      "mosaic_pumpkin": loc.mosaic_disease_pumpkin,
      "mosaic_pumpkin_treatment": loc.mosaic_disease_pumpkin_treatment,

      "northern_leaf_blight_corn_maize": loc.northern_leaf_blight_corn_maize,
      "northern_leaf_blight_corn_maize_treatment":
          loc.northern_leaf_blight_corn_maize_treatment,

      "powdery_mildew_cotton": loc.powdery_mildew_cotton,
      "powdery_mildew_cotton_treatment": loc.powdery_mildew_cotton_treatment,

      "powdery_mildew_mango": loc.powdery_mildew_mango,
      "powdery_mildew_mango_treatment": loc.powdery_mildew_mango_treatment,

      "powdery_mildew_pumpkin": loc.powdery_mildew_pumpkin,
      "powdery_mildew_pumpkin_treatment": loc.powdery_mildew_pumpkin_treatment,

      "powdery_mildew_qaad": loc.powdery_mildew_qaad,
      "powdery_mildew_qaad_treatment": loc.powdery_mildew_qaad_treatment,

      "powdery_mildew_cherry_sour": loc.powdery_mildew_cherry_sour,
      "powdery_mildew_cherry_sour_treatment":
          loc.powdery_mildew_cherry_sour_treatment,

      "red_rot_sugarcane": loc.red_rot_sugarcane,
      "red_rot_sugarcane_treatment": loc.red_rot_sugarcane_treatment,

      "rust_sugarcane": loc.rust_sugarcane,
      "rust_sugarcane_treatment": loc.rust_sugarcane_treatment,

      "septoria_leaf_spot_tomato": loc.septoria_leaf_spot_tomato,
      "septoria_leaf_spot_tomato_treatment":
          loc.septoria_leaf_spot_tomato_treatment,

      "sooty_mould_mango": loc.sooty_mould_mango,
      "sooty_mould_mango_treatment": loc.sooty_mould_mango_treatment,

      "spider_mites_two_spotted_spider_mite_tomato":
          loc.spider_mites_two_spotted_spider_mite_tomato,
      "spider_mites_two_spotted_spider_mite_tomato_treatment":
          loc.spider_mites_two_spotted_spider_mite_tomato_treatment,

      "target_spot_tomato": loc.target_spot_tomato,
      "target_spot_tomato_treatment": loc.target_spot_tomato_treatment,

      "target_spot_cotton": loc.target_spot_cotton,
      "target_spot_cotton_treatment": loc.target_spot_cotton_treatment,

      "tomato_yellow_leaf_curl_virus_tomato":
          loc.tomato_yellow_leaf_curl_virus_tomato,
      "tomato_yellow_leaf_curl_virus_tomato_treatment":
          loc.tomato_yellow_leaf_curl_virus_tomato_treatment,

      "tomato_mosaic_virus_tomato": loc.tomato_mosaic_virus_tomato,
      "tomato_mosaic_virus_tomato_treatment":
          loc.tomato_mosaic_virus_tomato_treatment,

      "yellow_sugarcane": loc.yellow_sugarcane,
      "yellow_sugarcane_treatment": loc.yellow_sugarcane_treatment,

      // ===== Healthy =====
      "healthy_apple": loc.healthy_apple,
      "healthy_apple_treatment": loc.healthy_apple_treatment,

      "healthy_blueberry": loc.healthy_blueberry,
      "healthy_blueberry_treatment": loc.healthy_blueberry_treatment,

      "healthy_cherry_sour": loc.healthy_cherry_sour,
      "healthy_cherry_sour_treatment": loc.healthy_cherry_sour_treatment,

      "healthy_corn_maize": loc.healthy_corn_maize,
      "healthy_corn_maize_treatment": loc.healthy_corn_maize_treatment,

      "healthy_grape": loc.healthy_grape,
      "healthy_grape_treatment": loc.healthy_grape_treatment,

      "healthy_peach": loc.healthy_peach,
      "healthy_peach_treatment": loc.healthy_peach_treatment,

      "healthy_pepper_bell": loc.healthy_pepper_bell,
      "healthy_pepper_bell_treatment": loc.healthy_pepper_bell_treatment,

      "healthy_potato": loc.healthy_potato,
      "healthy_potato_treatment": loc.healthy_potato_treatment,

      "healthy_raspberry": loc.healthy_raspberry,
      "healthy_raspberry_treatment": loc.healthy_raspberry_treatment,

      "healthy_soybean": loc.healthy_soybean,
      "healthy_soybean_treatment": loc.healthy_soybean_treatment,

      "healthy_strawberry": loc.healthy_strawberry,
      "healthy_strawberry_treatment": loc.healthy_strawberry_treatment,

      "healthy_tomato": loc.healthy_tomato,
      "healthy_tomato_treatment": loc.healthy_tomato_treatment,

      // ===== Unknown =====
      "unknown_disease": loc.unknown_disease,
      "unknown_disease_treatment": loc.unknown_disease_treatment,
    };
  }

   //static String tr(BuildContext context, String key) {
    // return getLocalizationMap(context)[key] ?? key;
   //}
}
