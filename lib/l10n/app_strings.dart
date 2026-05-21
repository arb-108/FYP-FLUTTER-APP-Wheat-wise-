class AppStrings {
  static const String en = 'en';
  static const String ur = 'ur';

  static final Map<String, Map<String, String>> _strings = {
    // ─── General ───────────────────────────────────────────
    'appTitle': {
      en: 'WheatWise - Plant Disease Detection',
      ur: 'WheatWise - پودوں کی بیماری کا پتہ',
    },
    'error': {en: 'Error', ur: 'خرابی'},
    'pageNotFound': {en: 'Page not found', ur: 'صفحہ نہیں ملا'},

    // ─── Profile Header ───────────────────────────────────
    'welcomeBack': {en: 'Welcome Back!', ur: '!خوش آمدید'},

    // ─── Home Tab ──────────────────────────────────────────
    'recentDiagnose': {en: 'Recent Diagnose', ur: 'حالیہ تشخیص'},
    'seeAll': {en: 'See All', ur: 'سب دیکھیں'},
    'noDiagnosesYet': {en: 'No Diagnoses Yet', ur: 'ابھی تک کوئی تشخیص نہیں'},
    'startScanningHistory': {
      en: 'Start scanning plants to see your history',
      ur: 'تاریخ دیکھنے کے لیے پودوں کو اسکین کریں',
    },

    // ─── History Tab ───────────────────────────────────────
    'diagnosisHistory': {en: 'Diagnosis History', ur: 'تشخیص کی تاریخ'},
    'totalScans': {en: 'total scans', ur: 'کل اسکینز'},
    'noHistoryYet': {en: 'No History Yet', ur: 'ابھی تک کوئی تاریخ نہیں'},
    'startScanningHistoryDesc': {
      en: 'Start scanning plants to see\nyour diagnosis history here',
      ur: 'تشخیص کی تاریخ دیکھنے کے لیے\nپودوں کو اسکین کریں',
    },
    'startScanning': {en: 'Start Scanning', ur: 'اسکیننگ شروع کریں'},
    'clearHistory': {en: 'Clear History', ur: 'تاریخ صاف کریں'},
    'clearHistoryConfirm': {
      en: 'Are you sure you want to clear all diagnosis history? This cannot be undone.',
      ur: 'کیا آپ واقعی تمام تشخیص کی تاریخ صاف کرنا چاہتے ہیں؟ یہ واپس نہیں ہو سکتا۔',
    },
    'cancel': {en: 'Cancel', ur: 'منسوخ'},
    'clear': {en: 'Clear', ur: 'صاف کریں'},
    'historyCleared': {en: 'History cleared', ur: 'تاریخ صاف ہو گئی'},
    'totalScansLabel': {en: 'Total Scans', ur: 'کل اسکینز'},
    'healthy': {en: 'Healthy', ur: 'صحت مند'},
    'diseased': {en: 'Diseased', ur: 'بیمار'},

    // ─── Profile Tab ───────────────────────────────────────
    'profile': {en: 'Profile', ur: 'پروفائل'},
    'abdulrehman':{en:'Abdul Rehman',ur:'عبدالرحمٰن'},
    'plantEnthusiast': {en: 'A PUCIT Student', ur: 'PUCIT کا ایک طالب علم'},
    'memberSince': {en: 'Member Since', ur: 'رکنیت کی تاریخ'},
    'scansPerformed': {en: 'Scans Performed', ur: 'اسکینز مکمل'},

    // ─── Scan Section ──────────────────────────────────────
    'scanTitle': {
      en: 'Know plant disease with WheatWise AI',
      ur: 'WheatWise AI سے پودوں کی بیماری جانیں',
    },
    'scanSubtitle': {
      en: 'Take a photo or upload an image to identify diseases',
      ur: 'بیماریوں کی شناخت کے لیے تصویر لیں یا اپ لوڈ کریں',
    },
    'scanNow': {en: 'Scan Now', ur: 'ابھی اسکین کریں'},
    'scanPlant': {en: 'Scan Plant', ur: 'پودا اسکین کریں'},
    'chooseOption': {
      en: 'Choose an option to scan your plant',
      ur: 'اپنا پودا اسکین کرنے کا طریقہ منتخب کریں',
    },
    'camera': {en: 'Camera', ur: 'کیمرہ'},
    'gallery': {en: 'Gallery', ur: 'گیلری'},
    'scanDisclaimer': {
      en: 'For the most accurate results, ensure the photo is clear and specifically of wheat. Poor quality or irrelevant images may lead to unpredictable findings.',
      ur: 'درست نتائج کے لیے، یقینی بنائیں کہ تصویر واضح ہے اور صرف گندم کی ہے۔ غیر واضح یا غیر متعلقہ تصاویر سے نتائج غلط ہو سکتے ہیں۔',
    },

    // ─── Banner Carousel ───────────────────────────────────
    'banner1Title': {
      en: 'Learn how WheatWise helps\n10,000+ farmers',
      ur: 'جانیں WheatWise کیسے\n10,000+ کسانوں کی مدد کرتا ہے',
    },
    'banner1Subtitle': {
      en: 'Detect diseases quickly and protect your crops',
      ur: 'بیماریوں کا جلد پتہ لگائیں اور فصلوں کی حفاظت کریں',
    },
    'banner2Title': {
      en: 'Get Treatment Tips\nfor Every Disease',
      ur: 'ہر بیماری کے لیے\nعلاج کی تجاویز حاصل کریں',
    },
    'banner2Subtitle': {
      en: 'Learn how to treat and prevent crop diseases',
      ur: 'فصل کی بیماریوں کا علاج اور روک تھام سیکھیں',
    },
    'banner3Title': {
      en: 'Track Your Plants\nHealth Over Time',
      ur: 'وقت کے ساتھ اپنے پودوں\nکی صحت ٹریک کریں',
    },
    'banner3Subtitle': {
      en: 'Keep a history of all your diagnoses',
      ur: 'اپنی تمام تشخیصات کی تاریخ رکھیں',
    },

    // ─── Bottom Nav Bar ────────────────────────────────────
    'home': {en: 'Home', ur: 'ہوم'},
    'scan': {en: 'Scan', ur: 'اسکین'},
    'history': {en: 'History', ur: 'تاریخ'},

    // ─── Diagnose List Item ────────────────────────────────
    'confidence': {en: 'Confidence', ur: 'اعتماد'},
    'wheat': {en: 'Wheat', ur: 'گندم'},
    'description': {en: 'Description', ur: 'تفصیل'},
    'severity': {en: 'Severity', ur: 'شدت'},
    'close': {en: 'Close', ur: 'بند کریں'},
    'mAgo': {en: 'm ago', ur: 'منٹ پہلے'},
    'hAgo': {en: 'h ago', ur: 'گھنٹے پہلے'},
    'dAgo': {en: 'd ago', ur: 'دن پہلے'},

    // ─── Result Screen ─────────────────────────────────────
    'result': {en: 'Result', ur: 'نتیجہ'},
    'onWheat': {en: 'on Wheat', ur: 'گندم پر'},
    'noDetailedInfo': {
      en: 'No detailed information available for this disease.',
      ur: 'اس بیماری کے بارے میں تفصیلی معلومات دستیاب نہیں۔',
    },
    'treatmentAndPrevention': {
      en: 'Treatment and Prevention',
      ur: 'علاج اور روک تھام',
    },
    'maintenance': {en: 'Maintenance', ur: 'دیکھ بھال'},
    'maintenanceDesc': {
      en: 'Continue regular watering and monitoring for early signs of disease.',
      ur: 'باقاعدہ پانی دینا اور بیماری کی ابتدائی علامات کی نگرانی جاری رکھیں۔',
    },
    'prevention': {en: 'Prevention', ur: 'روک تھام'},
    'preventionDesc': {
      en: 'Use crop rotation and ensure proper spacing between plants.',
      ur: 'فصل کی تبدیلی استعمال کریں اور پودوں کے درمیان مناسب فاصلہ رکھیں۔',
    },
    'fungicides': {en: 'Fungicides', ur: 'پھپھوندی کش ادویات'},
    'fungicidesDesc': {
      en: 'Consult local agricultural experts for recommended fungicides and application timing.',
      ur: 'تجویز کردہ پھپھوندی کش ادویات اور استعمال کے وقت کے لیے مقامی زرعی ماہرین سے مشورہ کریں۔',
    },
    'resistantVarieties': {en: 'Resistant Varieties', ur: 'مزاحم اقسام'},
    'resistantVarietiesDesc': {
      en: 'Planting varieties with resistance can significantly reduce the risk of infection.',
      ur: 'مزاحمت والی اقسام کاشت کرنے سے انفیکشن کا خطرہ نمایاں طور پر کم ہو سکتا ہے۔',
    },
    'cropRotation': {en: 'Crop Rotation', ur: 'فصل کی تبدیلی'},
    'cropRotationDesc': {
      en: 'Avoid planting in the same location year after year to break disease cycles.',
      ur: 'بیماری کے چکر کو توڑنے کے لیے ہر سال ایک ہی جگہ پر کاشت سے بچیں۔',
    },
    'riskLifePrediction': {
      en: 'Risk life prediction',
      ur: 'خطرے کی پیشن گوئی',
    },
    'low': {en: 'Low', ur: 'کم'},
    'high': {en: 'High', ur: 'زیادہ'},
    'note': {en: 'Note:', ur: ':نوٹ'},
    'noteDesc': {
      en: 'Early detection and prompt action are crucial. Consult a local agricultural extension agent for specific recommendations.',
      ur: 'جلد پتہ لگانا اور فوری اقدام بہت ضروری ہے۔ مخصوص سفارشات کے لیے مقامی زرعی ماہر سے مشورہ کریں۔',
    },
    'sharing': {en: 'Sharing', ur: 'شیئر ہو رہا ہے'},
    'resultText': {en: 'result', ur: 'نتیجہ'},
    'reGenerate': {en: 'Re-generate', ur: 'دوبارہ بنائیں'},
    'share': {en: 'Share', ur: 'شیئر کریں'},
    'wheatPlant': {en: 'Wheat Plant', ur: 'گندم کا پودا'},

    // ─── Disease List Screen ───────────────────────────────
    'diseaseLibrary': {en: 'Disease Library', ur: 'بیماریوں کی لائبریری'},
    'wheatDiseasesCatalogued': {
      en: 'wheat diseases catalogued',
      ur: 'گندم کی بیماریاں درج',
    },
    'searchDiseases': {en: 'Search diseases...', ur: '...بیماریاں تلاش کریں'},
    'all': {en: 'All', ur: 'سب'},
    'medium': {en: 'Medium', ur: 'درمیانی'},
    'noDiseaseFound': {en: 'No diseases found', ur: 'کوئی بیماری نہیں ملی'},

    // ─── Severity Labels ───────────────────────────────────
    'severityLow': {en: 'Low', ur: 'کم'},
    'severityMedium': {en: 'Medium', ur: 'درمیانی'},
    'severityHigh': {en: 'High', ur: 'زیادہ'},
  };

  // ─── Disease Names ─────────────────────────────────────
  static final Map<String, Map<String, String>> diseaseNames = {
    'Aphid': {en: 'Aphid', ur: 'ایفڈ (تیلا)'},
    'Black Rust': {en: 'Black Rust', ur: 'کالی کنگی'},
    'Blast': {en: 'Blast', ur: 'بلاسٹ'},
    'Brown Rust': {en: 'Brown Rust', ur: 'بھوری کنگی'},
    'Common Root Rot': {en: 'Common Root Rot', ur: 'جڑ کی سڑاند'},
    'Fusarium Head Blight': {en: 'Fusarium Head Blight', ur: 'فیوزیریم سر جھلساؤ'},
    'Healthy': {en: 'Healthy', ur: 'صحت مند'},
    'Leaf Blight': {en: 'Leaf Blight', ur: 'پتوں کا جھلساؤ'},
    'Mildew': {en: 'Mildew', ur: 'پھپھوندی'},
    'Mite': {en: 'Mite', ur: 'مائٹ (کیڑا)'},
    'Septoria': {en: 'Septoria', ur: 'سیپٹوریا'},
    'Smut': {en: 'Smut', ur: 'کانگیاری'},
    'Stem Fly': {en: 'Stem Fly', ur: 'تنے کی مکھی'},
    'Tan Spot': {en: 'Tan Spot', ur: 'ٹین سپاٹ'},
  };

  // ─── Disease Descriptions ──────────────────────────────
  static final Map<String, Map<String, String>> diseaseDescriptions = {
    'Aphid': {
      en: 'Small sap-sucking insects that cause leaf curling, stunting, and can transmit viruses.',
      ur: 'چھوٹے رس چوسنے والے کیڑے جو پتوں کو موڑتے ہیں، نشوونما روکتے ہیں اور وائرس پھیلا سکتے ہیں۔',
    },
    'Black Rust': {
      en: 'Caused by Puccinia graminis. Produces black pustules on stems and leaves, severely affecting yield.',
      ur: 'Puccinia graminis کی وجہ سے۔ تنوں اور پتوں پر سیاہ دانے بنتے ہیں جو پیداوار کو شدید متاثر کرتے ہیں۔',
    },
    'Blast': {
      en: 'Fungal disease causing diamond-shaped lesions on leaves and can affect grain heads.',
      ur: 'پھپھوندی کی بیماری جو پتوں پر ہیرے کی شکل کے زخم بناتی ہے اور بالیوں کو متاثر کر سکتی ہے۔',
    },
    'Brown Rust': {
      en: 'Caused by Puccinia triticina. Shows as orange-brown pustules on leaves.',
      ur: 'Puccinia triticina کی وجہ سے۔ پتوں پر نارنجی بھورے دانے نظر آتے ہیں۔',
    },
    'Common Root Rot': {
      en: 'Soil-borne disease causing browning and decay of roots, leading to poor plant vigor.',
      ur: 'مٹی سے پھیلنے والی بیماری جو جڑوں کو بھورا اور سڑا دیتی ہے، پودے کمزور ہو جاتے ہیں۔',
    },
    'Fusarium Head Blight': {
      en: 'Caused by Fusarium species. Bleaches spikelets and produces harmful mycotoxins.',
      ur: 'Fusarium انواع کی وجہ سے۔ بالیوں کو سفید کرتی ہے اور نقصان دہ مائکوٹوکسن پیدا کرتی ہے۔',
    },
    'Healthy': {
      en: 'No disease detected. The plant is in good condition.',
      ur: 'کوئی بیماری نہیں ملی۔ پودا اچھی حالت میں ہے۔',
    },
    'Leaf Blight': {
      en: 'Causes necrotic lesions on leaves, reducing photosynthetic capacity.',
      ur: 'پتوں پر مردہ زخم بناتی ہے جو غذا بنانے کی صلاحیت کم کرتے ہیں۔',
    },
    'Mildew': {
      en: 'Fungal disease causing white or gray powdery coating on leaf surfaces.',
      ur: 'پھپھوندی کی بیماری جو پتوں کی سطح پر سفید یا سرمئی پاؤڈر جیسی تہہ بناتی ہے۔',
    },
    'Mite': {
      en: 'Tiny arachnids that feed on plant tissue, causing stippling and discoloration.',
      ur: 'چھوٹے کیڑے جو پودے کے بافتوں سے خوراک حاصل کرتے ہیں، دھبے اور رنگ تبدیلی کرتے ہیں۔',
    },
    'Septoria': {
      en: 'Caused by Zymoseptoria tritici. Produces tan lesions with dark pycnidia.',
      ur: 'Zymoseptoria tritici کی وجہ سے۔ سیاہ نقطوں والے ہلکے بھورے زخم بناتی ہے۔',
    },
    'Smut': {
      en: 'Fungal disease replacing grain with masses of dark spores, causing foul odor.',
      ur: 'پھپھوندی کی بیماری جو دانوں کو سیاہ بیضانیوں سے بدل دیتی ہے اور بدبو پیدا کرتی ہے۔',
    },
    'Stem Fly': {
      en: 'Insect pest whose larvae bore into stems, causing wilting and lodging.',
      ur: 'کیڑا جس کے لاروے تنوں میں سوراخ کرتے ہیں، مرجھاؤ اور گرنے کا سبب بنتے ہیں۔',
    },
    'Tan Spot': {
      en: 'Caused by Pyrenophora tritici-repentis. Tan oval lesions with yellow halos.',
      ur: 'Pyrenophora tritici-repentis کی وجہ سے۔ پیلے حلقوں والے ہلکے بھورے بیضوی زخم۔',
    },
  };

  /// Get a UI string by key
  static String get(String key, String lang) {
    return _strings[key]?[lang] ?? _strings[key]?[en] ?? key;
  }

  /// Get disease name in current language
  static String getDiseaseName(String englishName, String lang) {
    return diseaseNames[englishName]?[lang] ?? englishName;
  }

  /// Get disease description in current language
  static String getDiseaseDescription(String englishName, String lang) {
    return diseaseDescriptions[englishName]?[lang] ??
        diseaseDescriptions[englishName]?[en] ??
        '';
  }

  /// Get severity label
  static String getSeverityLabel(String severity, String lang) {
    switch (severity.toLowerCase()) {
      case 'low':
        return get('severityLow', lang);
      case 'medium':
        return get('severityMedium', lang);
      case 'high':
        return get('severityHigh', lang);
      default:
        return severity;
    }
  }
}
