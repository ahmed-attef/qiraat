<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="التسجيل في مشروع تلاوة القرآن الكريم - القراءات العشر الصغرى">
    <meta name="keywords" content="التسجيل, القراءات العشر, تحفيظ القرآن, الأزهر">
    <title>التسجيل | مشروع تلاوة القرآن الكريم</title>
    <link rel="icon" type="image/png" href="images/logo.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Amiri:wght@400;700&family=Tajawal:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
    <style>
        /* بطاقة الموعد */
        .appointment-card {
            background: linear-gradient(135deg, rgba(212,168,83,0.15), rgba(212,168,83,0.05));
            border: 1.5px solid var(--gold, #d4af37);
            border-radius: 12px;
            padding: 1.2rem 1.5rem;
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .appointment-card .appt-icon {
            font-size: 2rem;
            color: var(--gold, #d4af37);
            flex-shrink: 0;
        }
        .appointment-card .appt-info strong {
            display: block;
            color: var(--gold, #d4af37);
            font-size: 1.05rem;
            margin-bottom: 0.2rem;
        }
        .appointment-card .appt-info span {
            font-size: 1.15rem;
            font-weight: 700;
            color: #fff;
        }
        .appointment-card .appt-note {
            font-size: 0.8rem;
            color: #94a3b8;
            margin-top: 0.3rem;
            display: block;
        }
        .success-appointment {
            background: rgba(212,168,83,0.1);
            border: 1px solid var(--gold, #d4af37);
            border-radius: 10px;
            padding: 1rem 1.5rem;
            margin: 1rem 0;
            text-align: center;
        }
        .success-appointment .date-display {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--gold, #d4af37);
            margin: 0.5rem 0;
        }
    </style>
</head>
<body>

<?php
/* ============================================================
   إعدادات الاتصال بقاعدة البيانات
   ============================================================ */
$host     = "localhost";
$username = "root";
$password = "0000";          // ← غيّريها لو عندك باسورد على phpMyAdmin
$database = "qiraatLearningdb";

/* ============================================================
   رابط Google Apps Script Webhook
   ============================================================
   ⚠️ الصق الكود التالي في Apps Script:

------- ابدأ النسخ -------
function doPost(e) {
  try {
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    if (sheet.getLastRow() === 0) {
      sheet.appendRow([
        'الاسم الكامل','العمر','المؤهل الدراسي','الجنس',
        'العنوان','رقم الهاتف','موعد الاختبار','تاريخ التسجيل'
      ]);
    }
    var data = JSON.parse(e.postData.contents);
    sheet.appendRow([
      data.fullName    || '',
      data.age         || '',
      data.qualification || '',
      data.gender      || '',
      data.address     || '',
      data.phone       || '',
      data.testDate    || '',
      data.createdAt   || ''
    ]);
    return ContentService
      .createTextOutput(JSON.stringify({status:"success"}))
      .setMimeType(ContentService.MimeType.JSON);
  } catch(err) {
    return ContentService
      .createTextOutput(JSON.stringify({status:"error", message: err.toString()}))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
function doGet(e) {
  return ContentService
    .createTextOutput(JSON.stringify({status:"ok"}))
    .setMimeType(ContentService.MimeType.JSON);
}
------- انتهى النسخ -------

خطوات النشر:
1. Extensions → Apps Script → الصق الكود
2. Deploy → New deployment → Web app
3. Execute as: Me | Who has access: Anyone
4. Deploy → انسخ الـ URL والصقه هنا:
============================================================ */
$GOOGLE_SHEET_WEBHOOK = "https://script.google.com/macros/s/AKfycbzw3iekwo5ltQNMPK9USfSYizdxE89NGAxge2PrfDDK3KQgi41sqHhn3IuGxg0VK1rI/exec";


/* ============================================================
   دالة الحفظ في Google Sheets عبر cURL
   ============================================================ */
function saveToGoogleSheets($webhookUrl, $data) {
    if (strpos($webhookUrl, 'YOUR_SCRIPT_ID') !== false) return false;

    $jsonData = json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL            => $webhookUrl,
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => $jsonData,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,   // Apps Script بيعمل redirect
        CURLOPT_MAXREDIRS      => 5,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_SSL_VERIFYHOST => 2,
        CURLOPT_TIMEOUT        => 15,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_HTTPHEADER     => [
            'Content-Type: application/json',
            'Content-Length: ' . strlen($jsonData)
        ],
        CURLOPT_USERAGENT => 'PHP/QuranProject',
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlErr  = curl_error($ch);
    curl_close($ch);

    if ($curlErr)  error_log("[GoogleSheets] cURL error: " . $curlErr);
    if ($response) {
        $dec = json_decode($response, true);
        if (isset($dec['status']) && $dec['status'] === 'error')
            error_log("[GoogleSheets] Script error: " . ($dec['message'] ?? $response));
    }
    return ($httpCode >= 200 && $httpCode < 400);
}

/* ============================================================
   دالة حساب أقرب موعد متاح للاختبار
   ============================================================
   - الذكور  → الاثنين
   - الإناث  → السبت
   - الحد الأقصى: 20 طالب في اليوم
   - لو اليوم مليان → روح للأسبوع اللي بعده
   ============================================================ */
function getNextAvailableTestDate($conn, $genderInt) {
    $maxPerDay  = 20;
    $dayOfWeek  = ($genderInt === 1) ? 'Monday' : 'Saturday';
    $genderBit  = $genderInt;   // 1 = ذكر، 0 = أنثى

    $date = new DateTime();
    // لو النهارده هو نفس اليوم المطلوب، روح للأسبوع الجاي عشان ما تحجزش في نفس اليوم
    $date->modify("next $dayOfWeek");

    // نحاول لحد ما نلاقي يوم فيه مكان (أقصى 52 أسبوع)
    for ($i = 0; $i < 52; $i++) {
        $testDate = $date->format('Y-m-d');

        // نبدأ Transaction لمنع التضارب لو اتنين بعتوا طلب في نفس الوقت
        $conn->begin_transaction();
        try {
            $stmt = $conn->prepare("
                SELECT COUNT(*) AS cnt
                FROM Applications
                WHERE TestDate = ? AND Gender = ?
                FOR UPDATE
            ");
            $stmt->bind_param("si", $testDate, $genderBit);
            $stmt->execute();
            $row = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if ((int)$row['cnt'] < $maxPerDay) {
                // ✅ فيه مكان — احجزه (rollback هنا ما يمسحش الحجز لأننا مش عملنا INSERT هنا)
                // الـ INSERT الفعلي بيتعمل في الكود الرئيسي مع TestDate
                $conn->rollback();
                return $testDate;
            }

            $conn->rollback();
        } catch (Exception $e) {
            $conn->rollback();
            error_log("[TestDate] " . $e->getMessage());
        }

        // اليوم مليان → الأسبوع الجاي
        $date->modify("+1 week");
    }

    return null; // مفيش مواعيد متاحة خلال سنة كاملة (نادر جداً)
}

/* ============================================================
   دالة تحويل التاريخ لعربي مقروء
   ============================================================ */
function formatDateArabic($dateStr) {
    if (!$dateStr) return '';
    $days = [
        'Monday'    => 'الاثنين',
        'Tuesday'   => 'الثلاثاء',
        'Wednesday' => 'الأربعاء',
        'Thursday'  => 'الخميس',
        'Friday'    => 'الجمعة',
        'Saturday'  => 'السبت',
        'Sunday'    => 'الأحد',
    ];
    $months = [
        1=>'يناير',2=>'فبراير',3=>'مارس',4=>'أبريل',
        5=>'مايو',6=>'يونيو',7=>'يوليو',8=>'أغسطس',
        9=>'سبتمبر',10=>'أكتوبر',11=>'نوفمبر',12=>'ديسمبر'
    ];
    $dt      = new DateTime($dateStr);
    $dayName = $days[$dt->format('l')] ?? $dt->format('l');
    $day     = $dt->format('j');
    $month   = $months[(int)$dt->format('n')];
    $year    = $dt->format('Y');
    return "$dayName $day $month $year";
}


/* ============================================================
   الاتصال بقاعدة البيانات
   ============================================================ */
$conn = new mysqli($host, $username, $password, $database);
if ($conn->connect_error) {
    die("<p style='color:red;text-align:center;'>❌ فشل الاتصال بقاعدة البيانات: " . $conn->connect_error . "</p>");
}
$conn->set_charset("utf8mb4");


/* ============================================================
   معالجة إرسال الفورم (POST)
   ============================================================ */
$successMsg    = "";
$errorMsg      = "";
$sheetsData    = [];
$qualifID      = 0;
$assignedDate  = "";        // الموعد اللي اتحدد للطالب

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    // جلب وتنظيف البيانات
    $fullName  = trim(htmlspecialchars($_POST["fullName"]  ?? ""));
    $age       = intval($_POST["age"] ?? 0);
    $address   = trim(htmlspecialchars($_POST["address"]   ?? ""));
    $city      = trim(htmlspecialchars($_POST["city"]      ?? ""));
    $phone     = trim(htmlspecialchars($_POST["phone"]     ?? ""));
    $genderStr = trim($_POST["gender"] ?? "");
    $qualifID  = intval($_POST["qualification-id"] ?? 0);

    // تحويل الجنس: male→1  female→0
    $gender      = ($genderStr === "male") ? 1 : 0;
    $fullAddress = $address . " - " . $city;

    // التحقق من البيانات
    if (empty($fullName) || $age < 10 || $age > 80 || empty($phone) || $qualifID === 0 || empty($genderStr)) {
        $errorMsg = "⚠️ يُرجى تعبئة جميع الحقول بشكل صحيح.";
    } else {

        // ── 1. أوجد أقرب موعد متاح ──────────────────────────────
        $testDate = getNextAvailableTestDate($conn, $gender);

        if (!$testDate) {
            $errorMsg = "⚠️ لا توجد مواعيد متاحة حالياً. يرجى التواصل مع الإدارة.";
        } else {

            // ── 2. أدخل البيانات في الداتابيز مع TestDate ────────
            $stmt = $conn->prepare("
                INSERT INTO Applications
                    (FullName, Age, AcademicQualificationID, Gender, Address, Phone, TestDate)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ");
            // s=FullName, i=Age, i=QualifID, i=Gender, s=Address, s=Phone, s=TestDate
            $stmt->bind_param("siiisss",
                $fullName, $age, $qualifID, $gender, $fullAddress, $phone, $testDate
            );

            if ($stmt->execute()) {
                $assignedDate = $testDate;
                $successMsg   = "✅ تم إرسال طلبك بنجاح!";

                // ── 3. جهّز بيانات Google Sheets ──────────────────
                $sheetsData = [
                    "fullName"      => $fullName,
                    "age"           => $age,
                    "qualification" => "",   // سيُكمَل بعد جلب المؤهلات
                    "gender"        => ($gender === 1) ? "ذكر" : "أنثى",
                    "address"       => $fullAddress,
                    "phone"         => $phone,
                    "testDate"      => formatDateArabic($testDate),   // الموعد بالعربي
                    "createdAt"     => date("Y-m-d H:i:s"),
                ];
            } else {
                $errorMsg = "❌ حدث خطأ أثناء حفظ البيانات: " . $stmt->error;
            }
            $stmt->close();
        }
    }
}

/* ============================================================
   جلب المؤهلات الدراسية من الداتابيز (لملء الـ select)
   ============================================================ */
$qualifications = [];
$res = $conn->query("SELECT AcademicQualificationID, Title FROM academicqualifications ORDER BY AcademicQualificationID");
if ($res && $res->num_rows > 0) {
    $qualifications = $res->fetch_all(MYSQLI_ASSOC);
}

/* ── أكمل اسم المؤهل في sheetsData ثم أرسل لـ Google Sheets ── */
if (!empty($sheetsData)) {
    foreach ($qualifications as $q) {
        if ($q['AcademicQualificationID'] == $qualifID) {
            $sheetsData['qualification'] = $q['Title'];
            break;
        }
    }
    saveToGoogleSheets($GOOGLE_SHEET_WEBHOOK, $sheetsData);
}

$conn->close();
?>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="navbar-container">
            <div class="navbar-logo">
                <img src="images/logo.png" alt="شعار المشروع">
                <span class="navbar-logo-text">مشروع تلاوة</span>
            </div>
            <ul class="navbar-menu" id="navbarMenu">
                <li class="nav-item">
                    <a href="index.html" class="nav-link">الرئيسية</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">عن المشروع <i class="fas fa-chevron-down"></i></a>
                    <ul class="dropdown-menu">
                        <li><a href="index.html#introduction" class="dropdown-item">نبذة عن المشروع</a></li>
                        <li><a href="index.html#founder"      class="dropdown-item">المؤسس والمشرف</a></li>
                        <li><a href="index.html#teachers"     class="dropdown-item">هيئة التدريس</a></li>
                        <li><a href="#"                       class="dropdown-item">إنجازات المشروع</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">الخدمات <i class="fas fa-chevron-down"></i></a>
                    <ul class="dropdown-menu">
                        <li><a href="index.html#requirements" class="dropdown-item">شروط القبول</a></li>
                        <li><a href="apply.php"               class="dropdown-item">التسجيل</a></li>
                        <li><a href="#"                       class="dropdown-item">الإجازات القرآنية</a></li>
                        <li><a href="playlists.php"           class="dropdown-item">الدورات التأهيلية</a></li>
                        <li><a href="#"                       class="dropdown-item">الاستشارات القرآنية</a></li>
                    </ul>
                </li>
            </ul>
            <div class="mobile-toggle" id="mobileToggle">
                <span></span><span></span><span></span>
            </div>
        </div>
    </nav>

    <!-- Hero -->
    <section class="apply-hero">
        <h1>التسجيل في المشروع</h1>
        <p>انضم إلى برنامج القراءات العشر الصغرى وكن أحد حفظة كتاب الله</p>
    </section>

    <!-- Application Form Section -->
    <section class="application-form-section">
        <div class="application-form-container">

            <?php if (!empty($successMsg)): ?>
            <!-- ✅ رسالة النجاح مع الموعد -->
            <div class="success-message" style="display:block;">
                <i class="fas fa-check-circle" style="font-size:3rem; margin-bottom:1rem; color:var(--gold,#d4af37);"></i>
                <h3>تم إرسال طلبك بنجاح!</h3>
                <p>شكراً لتسجيلك في مشروع تلاوة القرآن الكريم.</p>

                <?php if ($assignedDate): ?>
                <!-- بطاقة الموعد -->
                <div class="success-appointment">
                    <p style="margin:0 0 0.4rem; color:#94a3b8; font-size:0.9rem;">
                        <i class="fas fa-calendar-check" style="color:var(--gold,#d4af37); margin-left:6px;"></i>
                        موعد اختبار القبول الخاص بك
                    </p>
                    <div class="date-display">
                        <?= htmlspecialchars(formatDateArabic($assignedDate)) ?>
                    </div>
                    <p style="margin:0; color:#94a3b8; font-size:0.85rem;">
                        <?= ($sheetsData['gender'] ?? '') === 'ذكر'
                            ? '📍 يُرجى الحضور يوم الاثنين في الموعد المحدد'
                            : '📍 يُرجى الحضور يوم السبت في الموعد المحدد' ?>
                    </p>
                </div>
                <?php endif; ?>

                <p style="color:#94a3b8; font-size:0.9rem; margin-top:1rem;">
                    سيتم التواصل معك قريباً لتأكيد الموعد وإرشادك لمكان الاختبار.
                </p>
                <br>
                <a href="apply.php" style="color:var(--gold,#d4af37); font-weight:bold;">↩ تسجيل طلب جديد</a>
            </div>

            <?php elseif (!empty($errorMsg)): ?>
            <div style="background:#fee2e2; color:#b91c1c; padding:1rem 1.5rem; border-radius:8px; margin-bottom:1.5rem; text-align:center;">
                <?= $errorMsg ?>
            </div>
            <?php endif; ?>

            <?php if (empty($successMsg)): ?>
            <!-- الفورم -->
            <div class="form-note">
                <p>
                    <i class="fas fa-info-circle" style="color:var(--gold,#d4af37); margin-left:0.5rem;"></i>
                    يُرجى تعبئة جميع البيانات المطلوبة بدقة. سيتم تحديد موعد اختبار القبول تلقائياً بعد إرسال الطلب.
                    <br>
                    <small style="color:#94a3b8;">
                        🗓 الذكور: يوم الاثنين &nbsp;|&nbsp; الإناث: يوم السبت &nbsp;|&nbsp; الطاقة الاستيعابية: 20 طالب يومياً
                    </small>
                </p>
            </div>

            <form id="applicationForm" action="apply.php" method="POST">

                <!-- الاسم الكامل -->
                <div class="form-group">
                    <label for="fullName">
                        <i class="fas fa-user" style="margin-left:0.5rem;"></i>الاسم الكامل
                    </label>
                    <input type="text" id="fullName" name="fullName"
                           placeholder="أدخل اسمك الرباعي"
                           value="<?= htmlspecialchars($_POST['fullName'] ?? '') ?>"
                           required>
                </div>

                <!-- العمر -->
                <div class="form-group">
                    <label for="age">
                        <i class="fas fa-calendar" style="margin-left:0.5rem;"></i>العمر
                    </label>
                    <input type="number" id="age" name="age"
                           placeholder="أدخل عمرك" min="10" max="80"
                           value="<?= htmlspecialchars($_POST['age'] ?? '') ?>"
                           required>
                </div>

                <!-- العنوان -->
                <div class="form-group">
                    <label for="address">
                        <i class="fas fa-home" style="margin-left:0.5rem;"></i>العنوان التفصيلي
                    </label>
                    <input type="text" id="address" name="address"
                           placeholder="أدخل عنوانك التفصيلي"
                           value="<?= htmlspecialchars($_POST['address'] ?? '') ?>"
                           required>
                </div>

                <div class="form-row">
                    <!-- المدينة -->
                    <div class="form-group">
                        <label for="city">
                            <i class="fas fa-city" style="margin-left:0.5rem;"></i>المدينة
                        </label>
                        <input type="text" id="city" name="city"
                               placeholder="أدخل اسم المدينة"
                               value="<?= htmlspecialchars($_POST['city'] ?? '') ?>"
                               required>
                    </div>

                    <!-- رقم الهاتف -->
                    <div class="form-group">
                        <label for="phone">
                            <i class="fas fa-phone" style="margin-left:0.5rem;"></i>رقم الهاتف
                        </label>
                        <input type="tel" id="phone" name="phone"
                               placeholder="أدخل رقم هاتفك"
                               value="<?= htmlspecialchars($_POST['phone'] ?? '') ?>"
                               required>
                    </div>
                </div>

                <!-- الجنس -->
                <div class="form-group">
                    <label for="gender">
                        <i class="fas fa-venus-mars" style="margin-left:0.5rem;"></i>الجنس
                    </label>
                    <select id="gender" name="gender" required>
                        <option value="" disabled <?= empty($_POST['gender']) ? 'selected' : '' ?>>اختر الجنس</option>
                        <option value="male"   <?= (($_POST['gender'] ?? '') === 'male')   ? 'selected' : '' ?>>ذكر</option>
                        <option value="female" <?= (($_POST['gender'] ?? '') === 'female') ? 'selected' : '' ?>>أنثى</option>
                    </select>
                    <!-- ملاحظة الموعد تحت الـ select -->
                    <small style="color:#94a3b8; display:block; margin-top:0.4rem;">
                        <i class="fas fa-info-circle" style="color:var(--gold,#d4af37);"></i>
                        سيُحدَّد موعد اختبارك تلقائياً بعد الإرسال
                        (ذكور: الاثنين | إناث: السبت)
                    </small>
                </div>

                <!-- المؤهل الدراسي -->
                <div class="form-group">
                    <label for="education">
                        <i class="fas fa-graduation-cap" style="margin-left:0.5rem;"></i>المؤهل الدراسي
                    </label>
                    <select id="education" name="qualification-id" required>
                        <option value="" disabled selected>اختر المؤهل الدراسي</option>
                        <?php foreach ($qualifications as $qual): ?>
                            <option value="<?= $qual['AcademicQualificationID'] ?>"
                                <?= (isset($_POST['qualification-id']) && $_POST['qualification-id'] == $qual['AcademicQualificationID']) ? 'selected' : '' ?>>
                                <?= htmlspecialchars($qual['Title']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>

                <!-- زر الإرسال -->
                <button type="submit" class="submit-button" id="submitBtn">
                    <span>إرسال الطلب وتحديد الموعد</span>
                    <i class="fas fa-calendar-plus"></i>
                </button>

            </form>
            <?php endif; ?>

        </div>
    </section>

    <!-- ما بعد التسجيل -->
    <section class="introduction" style="padding:3rem 2rem;">
        <div class="section-container">
            <div class="section-header">
                <h2>ما بعد التسجيل</h2>
                <p>خطوات إتمام القبول في البرنامج</p>
            </div>
            <div class="requirements-list" style="max-width:800px; margin:0 auto;">
                <div class="requirement-item">
                    <div class="requirement-number">١</div>
                    <div class="requirement-text">
                        <h4>تأكيد الموعد تلقائياً</h4>
                        <p>بمجرد إرسال طلبك، يُحدَّد موعد اختبار القبول تلقائياً (الذكور: الاثنين — الإناث: السبت) ويُعرض لك فوراً.</p>
                    </div>
                </div>
                <div class="requirement-item">
                    <div class="requirement-number">٢</div>
                    <div class="requirement-text">
                        <h4>مراجعة الطلب</h4>
                        <p>سيتم مراجعة طلبك والتحقق من البيانات خلال 3-5 أيام عمل.</p>
                    </div>
                </div>
                <div class="requirement-item">
                    <div class="requirement-number">٣</div>
                    <div class="requirement-text">
                        <h4>اختبار الحفظ</h4>
                        <p>ستجتاز اختباراً شفهياً في جزء أو أكثر من القرآن الكريم في الموعد المحدد.</p>
                    </div>
                </div>
                <div class="requirement-item">
                    <div class="requirement-number">٤</div>
                    <div class="requirement-text">
                        <h4>القبول النهائي</h4>
                        <p>بعد اجتياز الاختبار، سيتم إعلامك بالقبول وتحديد موعد بدء الدراسة.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h4>مشروع تلاوة القرآن الكريم</h4>
                <p>مشروع علمي قرآني يهدف إلى تخريج مئة حافظ سنوياً في القراءات العشر الصغرى.</p>
            </div>
            <div class="footer-section">
                <h4>روابط سريعة</h4>
                <ul class="footer-links">
                    <li><a href="index.html#introduction">نبذة عن المشروع</a></li>
                    <li><a href="index.html#founder">المؤسس والمشرف</a></li>
                    <li><a href="index.html#teachers">هيئة التدريس</a></li>
                    <li><a href="index.html#requirements">شروط القبول</a></li>
                    <li><a href="apply.php">التسجيل</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>تواصل معنا</h4>
                <ul class="footer-links">
                    <li><i class="fas fa-phone"></i> <span>[رقم الهاتف]</span></li>
                    <li><i class="fas fa-envelope"></i> <span>[البريد الإلكتروني]</span></li>
                    <li><i class="fas fa-map-marker-alt"></i> <span>[العنوان]</span></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>جميع الحقوق محفوظة © مشروع تلاوة القرآن الكريم 2024</p>
        </div>
    </footer>

    <script src="script7.js"></script>
</body>
</html>
