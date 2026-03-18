import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'utils/localization_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:plant_diagnosis_app/utils/localization_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'utils/device_id_helper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:cached_network_image/cached_network_image.dart';

//import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

import 'package:audioplayers/audioplayers.dart';
import 'local_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';



// �����

import 'package:uuid/uuid.dart';

class AppConstants {
  //static const String baseUrl = "https://mohashaher-mobile-backend.hf.space";
//static const String baseUrl = "http://localhost:8000";
  //static const String baseUrl = "https://mohashaher-plant-diag-final-server.hf.space";
 static const String baseUrl = "https://mohashaher-backend-supaspace.hf.space";
}



// ================= Database Helper =================
class DatabaseHelper {
  static Database? _db;

  static String appLanguageCode = 'en';
  static bool get isArabic => appLanguageCode == 'ar';

  static String get nameCol => isArabic ? 'name' : 'name_en';
  static String get symptomsCol => isArabic ? 'symptoms' : 'symptoms_en';
  static String get causeCol => isArabic ? 'cause' : 'cause_en';
  static String get preventiveCol =>
      isArabic ? 'preventive_measures' : 'preventive_measures_en';
  static String get chemicalCol =>
      isArabic ? 'chemical_treatment' : 'chemical_treatment_en';
  static String get alternativeCol =>
      isArabic ? 'alternative_treatment' : 'alternative_treatment_en';

  
  static Future<Database> getDatabase() async {
  if (_db != null) return _db!;
  if (kIsWeb) throw Exception("Web uses JSON, not SQLite");

  // ������ ������ ������ �������� ��� �������
  String dbPath = await getDatabasesPath();
  String path = p.join(dbPath, "plantix_final.db");

  // �� ������� �����ɿ ��� �� ������ �� assets
  bool exists = await File(path).exists();
  if (!exists) {
    print("? ��� ����� �������� ���� ���...");
    await Directory(dbPath).create(recursive: true);

    ByteData data = await rootBundle.load("assets/plantix_final.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
    print("? ��� ��� ������� �����");
  }

  // ���� �������
  _db = await openDatabase(path, readOnly: false);
  return _db!;
}


  // ================= Web JSON =================
  static Map<int, dynamic> _jsonData = {};

  static Future<void> loadJson(String assetPath) async {
    if (!kIsWeb) return;
    final data = await rootBundle.loadString(assetPath);
    final list = json.decode(data) as List<dynamic>;
    _jsonData.clear();
    for (var crop in list) {
      _jsonData[crop['id']] = crop;
    }
  }

  // ==================== Methods ====================
  static Future<List<Map<String, dynamic>>> getCrops() async {
    if (kIsWeb) return getCropsFromJson();
    final db = await getDatabase();
    return await db.query(
      'crops',
      columns: ['id', nameCol + ' as name', 'name_en'],
    );
  }

  static Future<List<Map<String, dynamic>>> getStagesByCrop(int cropId) async {
    final db = await getDatabase();
    return await db.rawQuery('''
      SELECT DISTINCT s.id, s.$nameCol AS name
      FROM stages s
      JOIN disease_crop_stage dcs ON dcs.stage_id = s.id
      WHERE dcs.crop_id = ?
      ORDER BY s.id
    ''', [cropId]);
  }

  static Future<List<Map<String, dynamic>>> getDiseasesByCropAndStage(
      int cropId, int stageId) async {
    final db = await getDatabase();
    return await db.rawQuery('''
      SELECT DISTINCT d.id,
             d.$nameCol AS name,
             d.default_image,
             d.$symptomsCol AS symptoms,
             d.$causeCol AS cause,
             d.$preventiveCol AS preventive_measures,
             d.$chemicalCol AS chemical_treatment,
             d.$alternativeCol AS alternative_treatment
      FROM diseases d
      JOIN disease_crop_stage ds ON ds.disease_id = d.id
      WHERE ds.stage_id = ? AND ds.crop_id = ?
    ''', [stageId, cropId]);
  }

  // ================= Web JSON Methods =================
  static Future<List<Map<String, dynamic>>> getCropsFromJson() async {
    return _jsonData.values.map((c) => {
          'id': c['id'],
          'name': isArabic ? c['name'] : c['name_en'],
          'name_en': c['name_en'],
        }).toList();
  }

  static Future<List<Map<String, dynamic>>> getStagesByCropFromJson(
      int cropId) async {
    final crop = _jsonData[cropId];
    if (crop == null) return [];
    final stages = crop['stages'] as List<dynamic>;
    return stages.map((s) => {
          'id': s['id'],
          'name': isArabic ? s['name'] : s['name_en'],
          'diseases': s['diseases'],
        }).toList();
  }

  static Future<List<Map<String, dynamic>>> getDiseasesByCropAndStageFromJson(
      int cropId, int stageId) async {
    final stages = await getStagesByCropFromJson(cropId);
    final stage =
        stages.firstWhere((s) => s['id'] == stageId, orElse: () => {});
    if (stage.isEmpty) return [];
    final diseases = stage['diseases'] as List<dynamic>;
    return diseases.map((d) => {
          'id': d['id'],
          'name': isArabic ? d['name'] : d['name_en'],
          'default_image': d['default_image'],
          'symptoms': isArabic ? d['symptoms'] : d['symptoms_en'],
          'cause': isArabic ? d['cause'] : d['cause_en'],
          'preventive_measures': (isArabic
                  ? d['preventive_measures']
                  : d['preventive_measures_en'])
              .join(", "),
          'chemical_treatment':
              isArabic ? d['chemical_treatment'] : d['chemical_treatment_en'],
          'alternative_treatment': isArabic
              ? d['alternative_treatment']
              : d['alternative_treatment_en'],
        }).toList();
  }

}

Future<void> _initFCM() async {
  final prefs = await SharedPreferences.getInstance();
  final farmerId = prefs.getInt('farmer_id');

  if (farmerId == null) return;

  await registerFCMToken(farmerId);
}

Future<void> registerFCMToken(int farmerId) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  String? token = await messaging.getToken();

  if (token != null) {
    await http.post(
      Uri.parse('${AppConstants.baseUrl}/save_fcm_token'),
      body: {
        'user_id': farmerId.toString(),
        'role': 'farmer',
        'fcm_token': token,
      },
    );
  }

  // ����� ������ ��� ����
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    await http.post(
      Uri.parse('${AppConstants.baseUrl}/save_fcm_token'),
      body: {
        'user_id': farmerId.toString(),
        'role': 'farmer',
        'fcm_token': newToken,
      },
    );
  });
}

/// ����� ������ �������� �� ������� �������� ��� ����� ������
Future<int?> ensureAutoLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final existingId = prefs.getInt('farmer_id');
  if (existingId != null) {
    print("? Farmer already logged in: $existingId");
    return existingId;
  }

  try {
    final deviceId = await getDeviceId();
	//final deviceId = await DeviceIdHelper.getDeviceId();
    final uri = Uri.parse('${AppConstants.baseUrl}/auto_login'); // �� ������ ������ �����
    final response = await http.post(uri, body: {'device_id': deviceId});
    print (deviceId);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final farmerId = data['farmer_id'];
      await prefs.setInt('farmer_id', farmerId);
      print("? Farmer registered/logged in automatically: $farmerId");
      return farmerId;
    } else {
      print("?? ��� ������� �������: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("? ��� �� autoLogin: $e");
    return null;
  }
}



Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);


  if (kIsWeb) {
    await DatabaseHelper.loadJson("assets/plant_relational.json");
  } else if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
	// ����� SQLite + ������� JSON ��� ���� ������� �����
    await DatabaseHelper.getDatabase();
  }
   // ====== Android / iOS ======
  else {
    await DatabaseHelper.getDatabase(); // ��� ����� ������� + ���������
  }
  
  final farmerId = await ensureAutoLogin();

  runApp(MyApp(initialFarmerId: farmerId));
}

class MyApp extends StatefulWidget {
  final int? initialFarmerId;

  const MyApp({super.key, this.initialFarmerId});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');
  int? farmerId;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }
  Future<void> _initFCM() async {

    final farmerId = widget.initialFarmerId;
    if (farmerId == null) return;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await messaging.getToken();

    if (token != null) {
      await _sendTokenToServer(farmerId, token);
    }

    // ����� ������ ��� ����
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await _sendTokenToServer(farmerId, newToken);
    });

    // ������� ����� ����� ��� �������
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message.notification!.title ?? "����� ����",
            ),
          ),
        );
      }
    });
  }

  Future<void> _sendTokenToServer(int farmerId, String token) async {
    await http.post(
      Uri.parse('${AppConstants.baseUrl}/save_fcm_token'),
      body: {
        'user_id': farmerId.toString(),
        'role': 'farmer',
        'fcm_token': token,
      },
    );
  }
  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      DatabaseHelper.appLanguageCode = locale.languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Diagnosis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Arial'),
      locale: _locale,
      supportedLocales: const [Locale('ar', ''), Locale('en', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(onLocaleChange: _setLocale,initialFarmerId: widget.initialFarmerId),
    );
  }
}
// ================== Splash Screen ==================
class SplashScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  final int? initialFarmerId;

  const SplashScreen({
    required this.onLocaleChange,
    required this.initialFarmerId,
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late AnimationController _buttonsController;
  late List<Animation<Offset>> _slideAnimations;
  late int? farmerId;

  @override
  void initState() {
    super.initState();
    // ✅ Logo Animation
    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoController.forward();

    // ✅ Buttons Animation
    _buttonsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      final end = start + 0.5;
      return Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _buttonsController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));
    });

    _buttonsController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedButton(
      {required String text,
      required IconData icon,
      required VoidCallback onPressed,
      required Animation<Offset> animation}) {
    return SlideTransition(
      position: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[200], // ✅ لون موحّد
            foregroundColor: Colors.black87,
            minimumSize: const Size(double.infinity, 55),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(text, style: const TextStyle(fontSize: 17)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)], // 🌿 خلفية مريحة
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Logo
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset("assets/logo.png", fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ✅ Welcome text
                    Text(
                      t.welcomeText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 35),

                    // ✅ Buttons with slide animation
                    _buildAnimatedButton(
                      text: t.diagnosePlant,
                      icon: Icons.search,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => DiagnosisPage()));
                      },
                      animation: _slideAnimations[0],
                    ),
                    _buildAnimatedButton(
                      text: t.contactExperts,
                      icon: Icons.person,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => FarmerQuestionsPage()));
                      },
                      animation: _slideAnimations[1],
                    ),
                    _buildAnimatedButton(
                      text: t.pestsDiseases, // ✅ مترجم بدل النص الثابت
                      icon: Icons.bug_report,
                      onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PestsDiseasesPage()),
                        );
                        },
                      animation: _slideAnimations[2],
                    ),

                    _buildAnimatedButton(
                      text: t.awarenessGuide,
                      icon: Icons.menu_book,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AwarenessPage()));
                      },
                      animation: _slideAnimations[3],
                    ),
                    _buildAnimatedButton(
                      text: t.changeLanguage,
                      icon: Icons.language,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(t.changeLanguage),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.language),
                                  title: const Text('English'),
                                  onTap: () {
                                    widget.onLocaleChange(const Locale('en'));
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.language),
                                  title: const Text('العربية'),
                                  onTap: () {
                                    widget.onLocaleChange(const Locale('ar'));
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      animation: _slideAnimations[4],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ================== Diagnosis Page ==================
class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({Key? key}) : super(key: key);

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  File? _imageFile;
  Uint8List? _webImage;
  bool _loading = false;
  String? _disease;
  double? _confidence;
  String? _treatment;
  final picker = ImagePicker();

  List<Map<String, dynamic>> previousDiagnoses = [];

  @override
  void initState() {
    super.initState();
    _loadPreviousDiagnoses();
  }
  
 
  Future<Uint8List> _compressImage(Uint8List bytes) async {
  // ����� ����� ��� Windows (��� �����)
  if (kIsWeb || Platform.isWindows) {
    return bytes;
  }

  return await FlutterImageCompress.compressWithList(
    bytes,
    minWidth: 512,
    minHeight: 512,
    quality: 75,
    );
  }


  Future<void> _loadPreviousDiagnoses() async {
    try {
      final data = await fetchPreviousDiagnoses();
      setState(() => previousDiagnoses = data);
    } catch (e) {
      print("?? Error fetching previous diagnoses: $e");
    }
  }

 
   Future<void> pickImage() async {
  try {
    // ============ 1) WEB ============
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null) return;

      final fileBytes = result.files.first.bytes!;
      final fileName = result.files.first.name;

      setState(() {
        _webImage = fileBytes;
        _imageFile = null;
      });

      await diagnoseAndSave(fileBytes, fileName);
      return;
    }

    // ============ 2) ANDROID + iOS ============
    if (Platform.isAndroid || Platform.isIOS) {
      // ����� �������� �� �������� �� ������
	  final loc = AppLocalizations.of(context)!;
      final option = await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(loc.takephoto),
                onTap: () => Navigator.pop(ctx, "camera"),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(loc.selectimages),
                onTap: () => Navigator.pop(ctx, "gallery"),
              ),
            ],
          ),
        ),
      );

      if (option == null) return;

      XFile? pickedFile;

      if (option == "camera") {
        pickedFile = await picker.pickImage(source: ImageSource.camera);
      } else {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedFile == null) return;

      Uint8List imageBytes = await pickedFile.readAsBytes();

      setState(() {
        _imageFile = File(pickedFile!.path);
        _webImage = null;
      });

      await diagnoseAndSave(imageBytes, pickedFile.name);
      return;
    }

    // ============ 3) WINDOWS / MAC / LINUX ============
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) return;

    final file = File(result.files.first.path!);
    final fileBytes = await file.readAsBytes();
    final fileName = file.path.split('/').last;

    setState(() {
      _imageFile = file;
      _webImage = null;
    });

    await diagnoseAndSave(fileBytes, fileName);
  } catch (e) {
    print("Error picking image: $e");
  }
}

  Future<void> diagnoseAndSave(Uint8List imageBytes, String filename) async {
    setState(() {
      _loading = true;
      _disease = null;
      _confidence = null;
      _treatment = null;
    });

    try {
	  imageBytes = await _compressImage(imageBytes);

      final prefs = await SharedPreferences.getInstance();
      final farmerId = prefs.getInt('farmer_id') ?? 0;

      final uri = Uri.parse('${AppConstants.baseUrl}/predict');
      final request = http.MultipartRequest('POST', uri);
      request.fields['farmer_id'] = farmerId.toString();
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: filename));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode != 200) throw Exception('Failed to diagnose');

      final data = json.decode(respStr);
      final diseaseId = data['disease_name'];
      final confidence = data['confidence'];

      final diseaseMap = LocalizationHelper.getDiseaseMap(context);
      final localizedDisease = diseaseMap[diseaseId] ?? diseaseId;
      final treatment = diseaseMap["${diseaseId}_treatment"] ?? "";

      setState(() {
        _disease = localizedDisease;
        _confidence = confidence != null ? (confidence) : null;
        _treatment = treatment;
      });

      

      await _loadPreviousDiagnoses();
  //  } 
	//catch (e) {
    //  print("?? Error diagnosing or saving: $e");
    //  setState(() => _disease = "��� ��� ����� �������");
    //} 
	}catch (e, st) {
      print("? Diagnose error: $e");
      print(st);
           }

	finally {
      setState(() => _loading = false);
    }
  }

  Future<List<Map<String, dynamic>>> fetchPreviousDiagnoses() async {
    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getInt('farmer_id');
    if (farmerId == null) return [];

    final uri = Uri.parse('${AppConstants.baseUrl}/previous_diagnoses/$farmerId');
    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('Failed to fetch previous diagnoses');

    final List data = json.decode(response.body);
    final filtered = data.where((e) {
      final expertId = e['expert_id'] ?? 0;
      return expertId == 0;
    }).toList();

    return filtered.map((e) => e as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.diagnosePlant), backgroundColor: Colors.green[700]),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ?? ����� ���� �����
            const WeatherWidget(),
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ?? ������ ������ (������� ������)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.add_a_photo),
                        label: Text(loc.selectImage),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_imageFile != null || _webImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _imageFile != null
                              ? Image.file(_imageFile!, height: 300, fit: BoxFit.cover)
                              : Image.memory(_webImage!, height: 300, fit: BoxFit.cover),
                        ),
                      const SizedBox(height: 20),

                      if (_loading) const CircularProgressIndicator(color: Colors.green),

                      if (_disease != null && !_loading)
                        Card(
                          color: Colors.green[50],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${loc.result}: $_disease",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _disease!.toLowerCase().contains("���")
                                            ? Colors.red
                                            : Colors.green[800])),
                                const SizedBox(height: 10),
                                if (_confidence != null)
                                  Text(
                                    "${_confidence!.toStringAsFixed(1)}% ${loc.confidence}",
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                const SizedBox(height: 10),
                                if (_treatment != null && _treatment!.isNotEmpty)
                                  Text("${loc.treatment}: $_treatment",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // ?? ������ ������ (��������� �������)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.previousDiagnos,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700])),
                      const SizedBox(height: 10),
                      if (previousDiagnoses.isEmpty)
                        Text(loc.noPreviousDiagnoses,
                            style: TextStyle(color: Colors.grey[600])),
                      ...previousDiagnoses.map((diag) {
                        
                        final diseaseId = diag['disease'];
                        final confidence = diag['confidence'] ?? 0.0;
                        final diseaseMap = LocalizationHelper.getDiseaseMap(context);
                        final localizedDisease = diseaseMap[diseaseId] ?? diseaseId;
                        final treatment = diseaseMap["${diseaseId}_treatment"] ?? "";

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             ClipRRect(
                               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                               child: CachedNetworkImage(
                               imageUrl:
                                '${AppConstants.baseUrl}/diagnosis_image/${diag['id']}',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SizedBox(
                                height: 120,
                                child: Center(child: CircularProgressIndicator()),
                                 ),
                                errorWidget: (context, url, error) => const SizedBox(
                                height: 120,
                                child: Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                 ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${loc.result}: $localizedDisease",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800])),
                                    const SizedBox(height: 4),
                                    Text("${(confidence).toStringAsFixed(1)}% ${loc.confidence}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black54)),
                                    if (treatment.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text("${loc.treatment}: $treatment",
                                          style: const TextStyle(
                                              fontSize: 13, color: Colors.black87)),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================== Weather Widget ==================

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  bool _loading = true;
  String _city = "";
  String _description = "";
  double _temp = 0.0;
  String _mainWeather = "";
  String _dateString = "";

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _description = "���� ������ ��� ������");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _description = "�� ��� ��� ������");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = position.latitude;
      final lon = position.longitude;

      // ?? ����� �� ������� �������
      final locale = Localizations.localeOf(context).languageCode;
      final langParam = locale == "ar" ? "ar" : "en";

      const apiKey = "e04da9dcf248d89ed0105343de3270bd";
      final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather"
        "?lat=$lat&lon=$lon&units=metric&lang=$langParam&appid=$apiKey",
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      final now = DateTime.now();
      final formatter = DateFormat('EEEE� d MMMM', locale == "ar" ? 'ar' : 'en');
      final dateStr = formatter.format(now);

      setState(() {
        _city = data["name"];
        _temp = data["main"]["temp"].toDouble();
        _description = data["weather"][0]["description"];
        _mainWeather = data["weather"][0]["main"];
        _dateString = dateStr;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _description = "���� ��� ���� �����";
        _loading = false;
      });
    }
  }

  // ?? ����� ����� ��� ���� �����
  Color _backgroundColor() {
    switch (_mainWeather.toLowerCase()) {
      case "clear":
        return Colors.orangeAccent;
      case "clouds":
        return Colors.blueGrey;
      case "rain":
      case "drizzle":
        return Colors.indigo;
      case "thunderstorm":
        return Colors.deepPurple;
      case "snow":
        return Colors.lightBlueAccent;
      default:
        return Colors.teal;
    }
  }

  // ??? ������ �����
  IconData _weatherIcon() {
    switch (_mainWeather.toLowerCase()) {
      case "clear":
        return Icons.wb_sunny;
      case "clouds":
        return Icons.cloud;
      case "rain":
      case "drizzle":
        return Icons.grain;
      case "thunderstorm":
        return Icons.flash_on;
      case "snow":
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
@override
Widget build(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: _backgroundColor(),
    elevation: 6,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // �������
                Text(
                  _dateString,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),

                // ��������
                Icon(_weatherIcon(), size: 25, color: Colors.white),
                const SizedBox(width: 8),

                // ���� �������
               Text(
                 "${_temp.toStringAsFixed(1)}\u00B0C",
                 style: const TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
                 color: Colors.white,
                 ),
),

                const SizedBox(width: 8),

                // �����
                Text(
                  _description,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(width: 8),

                // �������
                Text(
                  _city,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    ),
  );
}

}
// ================== Pests & Diseases Page ==================

class PestsDiseasesPage extends StatefulWidget {
  const PestsDiseasesPage({Key? key}) : super(key: key);

  @override
  State<PestsDiseasesPage> createState() => _PestsDiseasesPageState();
}

class _PestsDiseasesPageState extends State<PestsDiseasesPage> {
  List<Map<String, dynamic>> crops = [];
  int? selectedCropId;
  List<Map<String, dynamic>> stages = [];
  Map<int, List<Map<String, dynamic>>> stageDiseases = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // ������ ���: ������� SQLite �������� ��������
    if (!kIsWeb) {
      await DatabaseHelper.getDatabase();
    }

    // ����� �������� (SQLite ��� �����ݡ JSON ��� �����)
    await _loadCrops();
  }

  Future<void> _loadCrops() async {
    final data = kIsWeb
        ? await DatabaseHelper.getCropsFromJson()
        : await DatabaseHelper.getCrops();
    setState(() => crops = data);
  }

  Future<void> _loadStages(int cropId) async {
    final data = kIsWeb
        ? await DatabaseHelper.getStagesByCropFromJson(cropId)
        : await DatabaseHelper.getStagesByCrop(cropId);

    setState(() {
      stages = data;
      stageDiseases.clear();
    });

    for (var stage in data) {
      final diseases = kIsWeb
          ? await DatabaseHelper.getDiseasesByCropAndStageFromJson(
              cropId, stage['id'])
          : await DatabaseHelper.getDiseasesByCropAndStage(cropId, stage['id']);
      setState(() => stageDiseases[stage['id']] = diseases);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.pestsDiseases)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: t.selectCrop,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: selectedCropId,
              items: crops.map((crop) {
                final imageName = crop['name_en']?.toString() ?? '';
                final cropName = Localizations.localeOf(context).languageCode ==
                        'ar'
                    ? crop['name']
                    : crop['name_en'] ?? crop['name'];

                return DropdownMenuItem<int>(
                  value: crop['id'],
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/plantix_icons/$imageName.jpg',
                        width: 32,
                        height: 32,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(cropName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCropId = value);
                  _loadStages(value);
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: selectedCropId == null
                  ? Center(child: Text(t.noCropSelected))
                  : ListView(
                      children: stages.map((stage) {
                        final diseases = stageDiseases[stage['id']] ?? [];
                        return ExpansionTile(
                          title: Text("${t.stage}: ${stage['name']}"),
                          children: diseases.isEmpty
                              ? [ListTile(title: Text(t.noDiseases))]
                              : diseases.map((disease) {
                                  return Card(
                                    margin: const EdgeInsets.all(8),
                                    child: ListTile(
                                      leading: disease['default_image'] != null
                                          ? Image.asset(
                                              "assets/disease_images/${disease['default_image']}",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.bug_report),
                                            )
                                          : const Icon(Icons.bug_report),
                                      title: Text(disease['name'] ?? ""),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DiseaseDetailsPage(
                                              disease: disease,
                                              details: disease,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== Disease Details ==================
class DiseaseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> disease;
  final Map<String, dynamic> details;

  const DiseaseDetailsPage({
    Key? key,
    required this.disease,
    required this.details,
  }) : super(key: key);

  Widget _buildDetailSection(String title, String? content) {
    if (content == null || content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(disease['name'] ?? t.diseaseDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (disease['default_image'] != null)
              Center(
                child: Image.asset(
                  "assets/disease_images/${disease['default_image']}",
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 16),
            _buildDetailSection(t.symptoms, disease['symptoms']),
			_buildDetailSection(
                t.alternativeTreatment, disease['alternative_treatment']),
			_buildDetailSection(
                t.chemicalTreatment, disease['chemical_treatment']),	
            _buildDetailSection(t.cause, disease['cause']),
            _buildDetailSection(
                t.preventiveMeasures, disease['preventive_measures']),
           
           
          ],
        ),
      ),
    );
  }
}

// ================== Awareness Page ==================

class AwarenessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.awarenessGuide)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTile(
            icon: Icons.eco,
            title: t.basicFarming,
            imagePath: 'assets/images/soil.jpg',
            content: [
              t.soilAdvice,
              t.sunAdvice,
              t.wateringAdvice,
            ],
          ),
          _buildTile(
            icon: Icons.shield,
            title: t.diseasePrevention,
            imagePath: 'assets/images/protection.jpg',
            content: [
              t.toolSanitation,
              t.cropRotation,
              t.seedSelection,
            ],
          ),
          _buildTile(
            icon: Icons.bug_report,
            title: t.naturalPestControl,
            imagePath: 'assets/images/pests.jpg',
            content: [
              t.plantRepellents,
              t.organicSprays,
              t.beneficialInsects,
            ],
          ),
          _buildTileWithWidget(
            icon: Icons.medical_information,
            title: t.commonDiseases,
            imagePath: 'assets/images/diseases.jpg',
            child: _diseaseTable(t),
          ),
          _buildTileWithWidget(
            icon: Icons.calendar_month,
            title: t.seasonalTips,
            imagePath: 'assets/images/seasons.jpg',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _subSection('🌸 ${t.spring}', [t.spring1, t.spring2]),
                _subSection('☀️ ${t.summer}', [t.summer1, t.summer2]),
                _subSection('🍂 ${t.autumn}', [t.autumn1, t.autumn2]),
                _subSection('❄️ ${t.winter}', [t.winter1, t.winter2]),
              ],
            ),
          ),
          _buildTile(
            icon: Icons.menu_book,
            title: t.resources,
            imagePath: 'assets/images/books.jpg',
            content: [
              'FAO: https://www.fao.org',
              'PlantVillage: https://plantvillage.psu.edu',
              t.youtubeChannels,
            ],
          ),
          _buildTile(
            icon: Icons.support_agent,
            title: t.needHelp,
            imagePath: 'assets/images/support.jpg',
            content: [t.contactExpertsInfo],
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String imagePath,
    required List<String> content,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: [
        const SizedBox(height: 8),
        Image.asset(imagePath, height: 150, fit: BoxFit.cover),
        const SizedBox(height: 8),
        ...content.map((item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(item, style: const TextStyle(fontSize: 16)),
            )),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTileWithWidget({
    required IconData icon,
    required String title,
    required String imagePath,
    required Widget child,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: [
        const SizedBox(height: 8),
        Image.asset(imagePath, height: 150, fit: BoxFit.cover),
        const SizedBox(height: 8),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: child),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _subSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('• $item', style: const TextStyle(fontSize: 15)),
              )),
        ],
      ),
    );
  }

  Widget _diseaseTable(AppLocalizations t) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FractionColumnWidth(0.25),
        1: FractionColumnWidth(0.35),
        2: FractionColumnWidth(0.4),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFDEFDE0)),
          children: [
            _tableCell(t.disease),
            _tableCell(t.symptoms),
            _tableCell(t.treatment),
          ],
        ),
        _diseaseRow('البياض الدقيقي', 'طبقة بيضاء على الأوراق', 'تهوية جيدة + رش بالكبريت'),
        _diseaseRow('اللفحة المتأخرة', 'بقع سوداء على الطماطم', 'مبيد نحاسي + إزالة المصاب'),
        _diseaseRow('التعفن الجذري', 'اصفرار وموت تدريجي', 'تحسين التصريف + تقليل الري'),
        _diseaseRow('المن', 'حشرات صغيرة تمتص العصارة', 'بخاخ النيم + ماء وصابون'),
      ],
    );
  }

  TableRow _diseaseRow(String a, String b, String c) {
    return TableRow(
      children: [
        _tableCell(a),
        _tableCell(b),
        _tableCell(c),
      ],
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }
}


// ================== Experts Page ==================
// ================== Farmer Questions Page (Final - With Unanswered Section) ==================

class FarmerQuestionsPage extends StatefulWidget {
  const FarmerQuestionsPage({Key? key}) : super(key: key);

  @override
  State<FarmerQuestionsPage> createState() => _FarmerQuestionsPageState();
}

class _FarmerQuestionsPageState extends State<FarmerQuestionsPage> {
  File? _imageFile;
  Uint8List? _webImage;
  
  File? _audioQuestionFile;   // ��� �������
  bool _recording = false;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer(); // ����� ��� ������
  
  bool _loading = false;
  double _progress = 0;
  final picker = ImagePicker();
  final TextEditingController _questionController = TextEditingController();

  List<Map<String, dynamic>> answered = [];
  List<Map<String, dynamic>> unanswered = [];
  int? _farmerId;

  @override
  void initState() {
    super.initState();
    _loadFarmerIdAndData();
  }
  
  Future<void> _downloadAnswerAudio(int questionId) async {
  try {

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/answer_$questionId.mp3');

    if (await file.exists()) return;

    final url = "${AppConstants.baseUrl}/expert_answer_audio/$questionId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {

      await file.writeAsBytes(response.bodyBytes);

      await LocalDB.updateAnswerAudioPath(
        questionId,
        file.path,
      );
    }

  } catch (e) {
    debugPrint("Answer audio download error: $e");
  }
}
  
  
  Future<void> _loadFarmerIdAndData() async {
    final prefs = await SharedPreferences.getInstance();
    _farmerId = prefs.getInt('farmer_id') ?? 0;
    await _fetchQuestions();
  }
  
  void Function(void Function())? _setStateDialog;
Future<void> _fetchQuestions() async {

  // تحميل البيانات المحلية أولاً (عرض سريع)
  final localData = await LocalDB.getQuestions();

  setState(() {
    answered = localData.where((q) => q['status'] == 1).toList();
    unanswered = localData.where((q) => q['status'] == 0).toList();
  });

  if (_farmerId == null) return;

  try {

    final uri = Uri.parse(
      "${AppConstants.baseUrl}/get_farmer_questions/$_farmerId"
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) return;

    final List data = json.decode(response.body);

    for (var q in data) {

      final existing =
          await LocalDB.getQuestionById(q["id"]);

      await LocalDB.insertQuestion({

        "id": q["id"],
        "question": q["question"],
        "answer": q["answer"],

        "image_path": existing?["image_path"],
        "question_audio_path": existing?["question_audio_path"],
        "answer_audio_path": (q["answer_has_audio"] == 1 && existing?["answer_audio_path"] != null)
           ? existing!["answer_audio_path"] as String
           : null,
        "has_image": q["has_image"],
        "question_has_audio": q["question_has_audio"],
        "answer_has_audio": q["answer_has_audio"],

        "status": q["status"]

      });

      // ===== تحميل صورة السؤال =====
      if (q["has_image"] == 1) {

        final localImage = existing?["image_path"];

        if (localImage == null ||
            !await File(localImage).exists()) {

          await _downloadQuestionImage(q["id"]);
        }
      }

      // ===== تحميل صوت السؤال =====
      if (q["question_has_audio"] == 1) {

        final localAudio =
            existing?["question_audio_path"];

        if (localAudio == null ||
            !await File(localAudio).exists()) {

          await _downloadQuestionAudio(q["id"]);
        }
      }

      // ===== تحميل صوت الإجابة =====
      if (q["answer_has_audio"] == 1) {

        final question =
            await LocalDB.getQuestionById(q["id"]);

        final localAnswerAudio =
            question?["answer_audio_path"];

        if (localAnswerAudio == null ||
            !await File(localAnswerAudio).exists()) {

          await _downloadAnswerAudio(q["id"]);
        }
      }

    } // ← هذا القوس كان مفقود (إغلاق for)

    // إعادة تحميل البيانات من SQLite بعد التحديث
    final updatedLocal = await LocalDB.getQuestions();

    setState(() {

      answered = updatedLocal
          .where((q) => q['status'] == 1)
          .toList();

      unanswered = updatedLocal
          .where((q) => q['status'] == 0)
          .toList();

    });

  } catch (e) {

    debugPrint("Fetch error: $e");

  }
}

Future<String?> _getOrDownloadImage(int questionId) async {

  final localPath = await LocalDB.getImagePath(questionId);

  if (localPath != null && await File(localPath).exists()) {
    return localPath;
  }

  final downloadedPath = await _downloadQuestionImage(questionId);

  if (downloadedPath != null) {
    return downloadedPath;
  }

  return null;
}

  Future<void> _pickImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    Uint8List imageBytes = await pickedFile.readAsBytes();

    setState(() {
      if (kIsWeb)
        _webImage = imageBytes;
      else
        _imageFile = File(pickedFile.path);
    });
  }
  
   // ================= AUDIO =================
Future<void> _startRecording() async {
  final hasPermission = await _recorder.hasPermission();
  if (!hasPermission) return;

 if (kIsWeb) {
  await _recorder.start(
    const RecordConfig(
      encoder: AudioEncoder.opus,
    ),
    path: 'audio.webm',
  );
}
else {
    // ===== Android / iOS =====
    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );
  }

  setState(() {
    _recording = true;
  });
}

Future<void> _stopRecording() async {
  final path = await _recorder.stop();

  if (!kIsWeb && path != null) {

    final dir = await getApplicationDocumentsDirectory();

    final savedPath =
        '${dir.path}/question_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    final savedFile = await File(path).copy(savedPath);

    // ? ���� �� �������
    _audioQuestionFile = savedFile;

    // ? ��� ����: ���� ������ ������
    debugPrint("Saved audio path: ${savedFile.path}");
  }

  setState(() {
    _recording = false;
  });
}

Future<String?> _downloadQuestionAudio(int questionId) async {

  try {

    final url =
        "${AppConstants.baseUrl}/expert_question_audio/$questionId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200 ||
        response.bodyBytes.isEmpty) {
      return null;
    }

    final dir = await getApplicationDocumentsDirectory();

    final path = "${dir.path}/question_$questionId.m4a";

    final file = File(path);

    await file.writeAsBytes(response.bodyBytes);

    await LocalDB.updateQuestionAudioPath(
        questionId,
        path);

    return path;

  } catch (e) {

    debugPrint("Question audio download error: $e");

    return null;
  }
}
Future<void> _sendQuestion() async {
  final loc = AppLocalizations.of(context)!;

  if (_farmerId == null) return;

  if (_imageFile == null &&
      _webImage == null &&
      _questionController.text.trim().isEmpty &&
      _audioQuestionFile == null) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.enterQuestion)),
    );
    return;
  }

  Uint8List? imageBytes;
  String imageName = "question_image.png";

  if (_webImage != null) {
    imageBytes = _webImage!;
  } else if (_imageFile != null) {
    imageBytes = await _imageFile!.readAsBytes();
    imageName = _imageFile!.path.split("/").last;
  }

  setState(() {
    _loading = true;
    _progress = 0;
  });
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) {
    return StatefulBuilder(
      builder: (context, setStateDialog) {

        _setStateDialog = setStateDialog;

        return AlertDialog(
          title: Text(loc.uploading),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
              ),
              const SizedBox(height: 10),
              Text("${(_progress * 100).toStringAsFixed(0)} %"),
            ],
          ),
        );
      },
    );
  },
);
  try {

    final dio = Dio();

    FormData formData = FormData.fromMap({
      "farmer_id": _farmerId.toString(),
      "question": _questionController.text.trim().isEmpty
       ? " "
       : _questionController.text.trim(),
    });

    if (imageBytes != null) {
      formData.files.add(
        MapEntry(
          "file",
          MultipartFile.fromBytes(
            imageBytes,
            filename: imageName,
          ),
        ),
      );
    }

    if (_audioQuestionFile != null &&
        await _audioQuestionFile!.exists()) {

      formData.files.add(
        MapEntry(
          "question_audio",
          await MultipartFile.fromFile(
            _audioQuestionFile!.path,
          ),
        ),
      );
    }

    final response = await dio.post(
      "${AppConstants.baseUrl}/send_question",
      data: formData,

      onSendProgress: (sent, total) {

      if (total <= 0) return;

      _setStateDialog?.call(() {
      _progress = sent / total;
      });

      },
    );

    if (response.statusCode == 200) {

      final data = response.data;
      final questionId = data["id"];

      if (questionId != null) {

        final dir = await getApplicationDocumentsDirectory();
        String imagePath;

       if (imageBytes != null) {

        imagePath = '${dir.path}/question_$questionId.png';

        await File(imagePath).writeAsBytes(imageBytes);

       } else {

        final bytes = await rootBundle.load('assets/images/no_image.png');

         imagePath = '${dir.path}/question_$questionId.png';

         await File(imagePath).writeAsBytes(bytes.buffer.asUint8List());

        }

        String? audioPath;

        if (_audioQuestionFile != null &&
            await _audioQuestionFile!.exists()) {

          final newAudioPath =
              '${dir.path}/question_$questionId.m4a';

          final newFile =
              await _audioQuestionFile!.copy(newAudioPath);

          audioPath = newFile.path;
        }

        await LocalDB.insertQuestion({
          "id": questionId,
          "question": _questionController.text.trim(),
          "answer": "",
          "image_path": imagePath ?? "",
          "question_audio_path": audioPath,
          "answer_audio_path": null,
          "status": 0
        });
      }

      _questionController.clear();

      setState(() {
        _imageFile = null;
        _webImage = null;
        _audioQuestionFile = null;
      });

      await _fetchQuestions();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.snackbar_question_sent)),
      );
    }

  } finally {

    Navigator.pop(context);

    setState(() {
      _loading = false;
      _progress = 0;
    });
  }
}

Future<String?> _getLocalAnswerAudioPath(int questionId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("answer_audio_$questionId");
}

Future<void> _saveAnswerAudioLocally(
    int questionId, Uint8List bytes) async {

  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/answer_$questionId.m4a';

  final file = File(filePath);
  await file.writeAsBytes(bytes);

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("answer_audio_$questionId", filePath);
  
  // ?? ��� ������ ����� �� ����� �������� �������
  //await LocalDB.updateAnswer(
  //  questionId,
  //  "",        // �� ����� �� ����
  //  filePath,  // ���� �����
 // );
  await LocalDB.updateAnswerAudioPath(
    questionId,
    filePath,
  );
}


Future<void> _playExpertAudio(int questionId) async {

  // ===== WEB =====
  if (kIsWeb) {
    final url =
        "${AppConstants.baseUrl}/expert_answer_audio/$questionId";

    await _audioPlayer.stop();
    await _audioPlayer.setSource(UrlSource(url));
    await _audioPlayer.resume();
    return;
  }

  // ===== ANDROID / IOS =====

  // الحصول على السؤال من SQLite
  final question = await LocalDB.getQuestionById(questionId);

  final path = question?['answer_audio_path'];

  // إذا كان الصوت موجود محلياً
  if (path != null && await File(path).exists()) {
    await _audioPlayer.stop();
    await _audioPlayer.setSource(DeviceFileSource(path));
    await _audioPlayer.resume();
    return;
  }

  // تحميل الصوت من السيرفر
  final url =
      "${AppConstants.baseUrl}/expert_answer_audio/$questionId";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
    debugPrint("No answer audio for $questionId");
    return;
  }

  // حفظ الصوت محلياً بامتداد m4a
  await _saveAnswerAudioLocally(
    questionId,
    response.bodyBytes,
  );

  // إعادة قراءة المسار بعد الحفظ
  final updatedQuestion =
      await LocalDB.getQuestionById(questionId);

  final newPath = updatedQuestion?['answer_audio_path'];

  if (newPath != null && await File(newPath).exists()) {
    await _audioPlayer.stop();
    await _audioPlayer.setSource(
        DeviceFileSource(newPath));
    await _audioPlayer.resume();
  }
}
Future<String?> _downloadQuestionImage(int questionId) async {
  try {
    final url =
        "${AppConstants.baseUrl}/expert_question_image/$questionId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      debugPrint("No image for question $questionId");
      return null;
    }

    if (response.bodyBytes.isEmpty) {
      debugPrint("Empty image for question $questionId");
      return null;
    }

    final dir = await getApplicationDocumentsDirectory();
    final imagePath = '${dir.path}/question_$questionId.jpg';

    final file = File(imagePath);
    await file.writeAsBytes(response.bodyBytes);

    await LocalDB.updateQuestionImagePath(
      questionId,
      imagePath,
    );

    return imagePath;

  } catch (e) {
    debugPrint("Image download error: $e");
    return null;
  }
}
Widget _buildQuestionCard(Map<String, dynamic> q, {bool answered = false}) {
  final loc = AppLocalizations.of(context)!;

  final questionId = q["id"];
  final questionText = q["question"] ?? "";
  final answerText = q["answer"] ?? "";

  return Card(
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "${loc.label_question} $questionText",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),


// ===== عرض الصورة =====
(q["image_path"] != null && q["image_path"].toString().isNotEmpty)

    ? Image.file(
        File(q["image_path"]),
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
      )

    : (q["has_image"] == 1 || q["has_image"] == true)

        ? FutureBuilder<String?>(
            future: _getOrDownloadImage(questionId),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 130,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                return Image.file(
                  File(snapshot.data!),
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }

              return SizedBox(
                height: 130,
                child: Center(
                  child: Text(loc.label_no_image),
                ),
              );
            },
          )

        : SizedBox(
            height: 130,
            child: Center(
              child: Text(loc.label_no_image),
            ),
          ),
          const SizedBox(height: 6),
         if ((q["question_audio_path"] != null &&
            q["question_audio_path"].toString().isNotEmpty) ||
            q["question_has_audio"] == 1 ||
            q["question_has_audio"] == true) ...[
          Row(
            children: [
              Text(
                loc.label_question_audio,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: loc.label_play_question_audio,
                onPressed: () async {

                  final prefs = await SharedPreferences.getInstance();

                  final question =
                      await LocalDB.getQuestionById(questionId);

                  final localPath =
                      question?['question_audio_path'];

                  if (kIsWeb) {

                    final url =
                        "${AppConstants.baseUrl}/expert_question_audio/$questionId";

                    await _audioPlayer.stop();
                    await _audioPlayer.play(UrlSource(url));
                    return;

                  } else {

                    if (localPath != null &&
                        await File(localPath).exists()) {

                      await _audioPlayer.stop();
                      await _audioPlayer.play(
                        DeviceFileSource(localPath),
                      );

                    } else {

                      final url =
                          "${AppConstants.baseUrl}/expert_question_audio/$questionId";

                      final response = await http.get(Uri.parse(url));

                      if (response.statusCode != 200 ||
                          response.bodyBytes.isEmpty) {

                        debugPrint("No question audio for $questionId");
                        return;
                      }

                      final dir =
                          await getApplicationDocumentsDirectory();

                      final filePath =
                          '${dir.path}/question_$questionId.m4a';

                      final file = File(filePath);
                      await file.writeAsBytes(response.bodyBytes);

                      await prefs.setString(
                        "question_audio_$questionId",
                        filePath,
                      );

                      await LocalDB.updateQuestionAudioPath(
                        questionId,
                        filePath,
                      );

                      await _audioPlayer.stop();
                      await _audioPlayer.play(
                        DeviceFileSource(filePath),
                      );
                    }
                  }
                },
              ),
            ],
			
          ),
		  ],
if (answered &&
   (answerText.isNotEmpty ||
    q["answer_has_audio"] == 1 ||
    (q["answer_audio_path"] != null &&
     q["answer_audio_path"].toString().isNotEmpty))) ...[

  const SizedBox(height: 6),

  // عرض نص الرد فقط إذا كان موجود
  if (answerText.isNotEmpty)
    Text(
      "${loc.label_answer} $answerText",
      style: const TextStyle(color: Colors.green),
    ),

  // عرض صوت الرد إذا كان موجود
  if (q["answer_has_audio"] == 1 ||
      (q["answer_audio_path"] != null &&
       q["answer_audio_path"].toString().isNotEmpty)) ...[

    Row(
      children: [
        Text(
          loc.label_answer_audio,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),

        const SizedBox(width: 8),

        IconButton(
          icon: const Icon(Icons.play_circle_fill),
          tooltip: loc.label_play_answer_audio,
          onPressed: () => _playExpertAudio(questionId),
        ),
      ],
    ),

  ],

],
        ],
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {

  final loc = AppLocalizations.of(context)!;

  return Scaffold(

    appBar: AppBar(
      title: Text(loc.farmer_page_title),
      backgroundColor: Colors.green[700],
    ),

    backgroundColor: Colors.grey[100],

    body: _loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          )

        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 1,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        loc.tab_answered,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (answered.isEmpty)
                        Text(
                          loc.noPreviousDiagnoses,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),

                      ...answered
                          .map((q) =>
                              _buildQuestionCard(q, answered: true))
                          .toList(),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  flex: 2,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      TextField(
                        controller: _questionController,
                        decoration: InputDecoration(
                          labelText: loc.label_write_question,
                          border: const OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_a_photo),
                        label: Text(loc.button_pick_image),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(

                        onPressed:
                            _recording
                                ? _stopRecording
                                : _startRecording,

                        icon: Icon(
                            _recording
                                ? Icons.stop
                                : Icons.mic),

                        label: Text(
                          _recording
                              ? loc.button_stop_recording
                              : loc.button_record_audio,
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                      ),

                      if (_audioQuestionFile != null) ...[

                        const SizedBox(height: 10),

                       Row(
                        children: [

                        const Icon(Icons.mic, color: Colors.green),

                       const SizedBox(width: 8),

                       Expanded(
                        child: Text(loc.label_audio_attached),
                       ),

                      // تشغيل الصوت
                       IconButton(
                       icon: const Icon(Icons.play_arrow, color: Colors.blue),
                       tooltip: loc.label_play_question_audio,
                       onPressed: () async {
                       await _audioPlayer.stop();
                       await _audioPlayer.play(
                       DeviceFileSource(_audioQuestionFile!.path),
                       );
                      },
                      ),

                     // حذف الصوت
                     IconButton(
                     icon: const Icon(Icons.delete, color: Colors.red),
                     tooltip: loc.label_delete_audio,
                     onPressed: () {
                     setState(() {
                      _audioQuestionFile = null;
                       });
                      },
                     ),
                    ],
                   ),
                  ],
                      const SizedBox(height: 10),

                      if (_imageFile != null ||
                          _webImage != null)

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(16),

                          child: _imageFile != null
                              ? Image.file(
                                  _imageFile!,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  _webImage!,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                        ),

                      const SizedBox(height: 10),

                      ElevatedButton(

                        onPressed: _sendQuestion,

                        child:
                            Text(loc.button_send_question),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        loc.tab_unanswered,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (unanswered.isEmpty)
                        Text(
                          loc.noPreviousDiagnoses,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),

                      ...unanswered
                          .map((q) =>
                              _buildQuestionCard(q))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
  );
}
}