<?php
/* =========================================================
   منصة تلاوة القرآن - ملف واحد كامل
   PHP + HTML + CSS + JavaScript
   ========================================================= */

$host = "localhost";
$user = "root";
$pass = "0000";
$db   = "qiraatLearningdb";

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) die("DB Connection Failed: " . $conn->connect_error);
$conn->set_charset("utf8mb4");

function e($str) { return htmlspecialchars($str ?? '', ENT_QUOTES, 'UTF-8'); }

$playlists = [];
$res = $conn->query("SELECT PlaylistID, Title, Notes, Cover FROM Playlists ORDER BY PlaylistID ASC");
if ($res) while ($row = $res->fetch_assoc()) $playlists[] = $row;

$selectedPlaylist = isset($_GET['playlist']) ? intval($_GET['playlist']) : null;
$currentVideoID   = isset($_GET['video'])    ? intval($_GET['video'])    : null;

$videos = [];
if ($selectedPlaylist) {
    $stmt = $conn->prepare("SELECT VideoID, Title, URL_Embed FROM Videos WHERE PlaylistID = ? ORDER BY VideoID ASC");
    $stmt->bind_param("i", $selectedPlaylist);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result) while ($row = $result->fetch_assoc()) $videos[] = $row;
    $stmt->close();
    $conn->next_result();
}

$quizzes = [];
foreach ($videos as $video) {
    $videoID = intval($video['VideoID']);
    $stmtQ = $conn->prepare("
        SELECT q.QuestionID, q.Title AS QuestionTitle,
               c.ChoiceID, c.Choice AS ChoiceText, c.IsTrue
        FROM Questions q
        INNER JOIN Choices c ON q.QuestionID = c.QuestionID
        WHERE q.VideoID = ?
        ORDER BY q.QuestionID, c.ChoiceID
    ");
    $stmtQ->bind_param("i", $videoID);
    $stmtQ->execute();
    $resQ = $stmtQ->get_result();
    while ($row = $resQ->fetch_assoc()) {
        $qid = $row['QuestionID'];
        if (!isset($quizzes[$videoID][$qid])) {
            $quizzes[$videoID][$qid] = ['question' => $row['QuestionTitle'], 'choices' => []];
        }
        $quizzes[$videoID][$qid]['choices'][] = [
            'id' => $row['ChoiceID'], 'text' => $row['ChoiceText'], 'isTrue' => (int)$row['IsTrue']
        ];
    }
    $stmtQ->close();
}

$currentVideo = null;
if ($selectedPlaylist && count($videos)) {
    if ($currentVideoID) foreach ($videos as $v) { if (intval($v['VideoID']) === $currentVideoID) { $currentVideo = $v; break; } }
    if (!$currentVideo) $currentVideo = $videos[0];
}
?>
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>الدورات التأهيلية | مشروع تلاوة القرآن الكريم</title>
<link rel="icon" type="image/png" href="images/logo.png">

<!-- Google Fonts — نفس الصفحة الرئيسية -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Amiri:wght@400;700&family=Tajawal:wght@300;400;500;700&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Main site CSS -->
<link rel="stylesheet" href="styles.css">

<style>
/* =====================================================
   متغيرات اللون — مطابقة للصفحة الرئيسية بالكامل
   ===================================================== */
:root {
    --navy-deep:   #08101f;
    --navy-dark:   #0f1d35;
    --navy-mid:    #162a4a;
    --navy-main:   #193363;
    --gold:        #d4a853;
    --gold-dark:   #a8893f;
    --gold-glow:   rgba(212,168,83,.18);
    --gold-border: rgba(212,168,83,.22);
    --text-light:  #f4f1e8;
    --text-muted:  #94a3b8;
    --font-serif:  'Amiri', serif;
    --font-sans:   'Tajawal', sans-serif;
    --radius:      12px;
    --shadow:      0 8px 32px rgba(8,16,31,.45);
}

*, *::before, *::after { box-sizing: border-box; }
html, body { margin: 0; padding: 0; scroll-behavior: smooth; }

body {
    font-family: var(--font-sans);
    background-color: var(--navy-main);
    color: var(--text-light);
    line-height: 1.8;
    font-size: 16px;
}
a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; }
img { max-width: 100%; display: block; }

/* =====================================================
   شريط التنقل — نسخة طبق الأصل من index.html
   ===================================================== */
.navbar {
    position: sticky;
    top: 0;
    z-index: 100;
    background: rgba(8, 16, 31, .95);
    backdrop-filter: blur(12px);
    border-bottom: 1px solid var(--gold-border);
}
.navbar-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 24px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 70px;
}
.navbar-logo {
    display: flex;
    align-items: center;
    gap: 12px;
}
.navbar-logo img {
    width: 42px;
    height: 42px;
    border-radius: 8px;
    object-fit: contain;
}
.navbar-logo-text {
    font-family: var(--font-serif);
    font-size: 20px;
    color: var(--gold);
    font-weight: 700;
}
.navbar-menu {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
    gap: 8px;
    align-items: center;
}
.nav-item { position: relative; }
.nav-link {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    color: var(--text-light);
    font-weight: 500;
    font-size: 15px;
    border-radius: 8px;
    transition: .2s;
}
.nav-link:hover { color: var(--gold); background: var(--gold-glow); }
.nav-item:hover .dropdown-menu { opacity: 1; pointer-events: auto; transform: translateY(0); }
.dropdown-menu {
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    background: var(--navy-dark);
    border: 1px solid var(--gold-border);
    border-radius: var(--radius);
    min-width: 200px;
    list-style: none;
    padding: 8px;
    margin: 0;
    opacity: 0;
    pointer-events: none;
    transform: translateY(-8px);
    transition: .2s;
    box-shadow: var(--shadow);
}
.dropdown-item {
    display: block;
    padding: 10px 14px;
    color: var(--text-muted);
    border-radius: 8px;
    font-size: 14px;
    transition: .15s;
}
.dropdown-item:hover { background: var(--gold-glow); color: var(--gold); }
.mobile-toggle {
    display: none;
    flex-direction: column;
    gap: 5px;
    cursor: pointer;
    padding: 6px;
}
.mobile-toggle span {
    display: block;
    width: 24px;
    height: 2px;
    background: var(--gold);
    border-radius: 2px;
    transition: .3s;
}

/* =====================================================
   Hero بانر الدورات
   ===================================================== */
.page-hero {
    background: linear-gradient(135deg, var(--navy-deep) 0%, var(--navy-dark) 60%, var(--navy-mid) 100%);
    border-bottom: 1px solid var(--gold-border);
    padding: 60px 24px 50px;
    text-align: center;
    position: relative;
    overflow: hidden;
}
.page-hero::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse 700px 300px at 50% 0%, var(--gold-glow), transparent 70%);
    pointer-events: none;
}
.page-hero .breadcrumb-top {
    font-size: 13px;
    color: var(--text-muted);
    margin-bottom: 16px;
}
.page-hero .breadcrumb-top a { color: var(--gold); }
.page-hero .breadcrumb-top span { margin: 0 6px; color: var(--text-muted); }
.page-hero h1 {
    font-family: var(--font-serif);
    font-size: clamp(28px, 4vw, 44px);
    color: var(--text-light);
    margin: 0 0 12px;
}
.page-hero h1 span { color: var(--gold); }
.page-hero p {
    color: var(--text-muted);
    max-width: 600px;
    margin: 0 auto;
    font-size: 16px;
}
.gold-line {
    width: 80px;
    height: 2px;
    background: linear-gradient(90deg, transparent, var(--gold), transparent);
    margin: 20px auto 0;
}

/* =====================================================
   شبكة الدورات
   ===================================================== */
.courses-section {
    max-width: 1200px;
    margin: 0 auto;
    padding: 60px 24px;
}
.section-header-inner {
    text-align: center;
    margin-bottom: 40px;
}
.section-header-inner h2 {
    font-family: var(--font-serif);
    font-size: 2rem;
    color: var(--gold);
    margin: 0 0 8px;
}
.section-header-inner p {
    color: var(--text-muted);
    font-size: 15px;
}

.courses-grid {
    display: grid;
    gap: 24px;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
}
.course-card {
    background: var(--navy-dark);
    border: 1px solid var(--gold-border);
    border-radius: var(--radius);
    overflow: hidden;
    box-shadow: var(--shadow);
    transition: transform .3s, box-shadow .3s;
    display: flex;
    flex-direction: column;
}
.course-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 16px 48px rgba(8,16,31,.6), 0 0 0 1px rgba(212,168,83,.35);
}
.course-cover {
    aspect-ratio: 16/9;
    background: linear-gradient(135deg, var(--navy-mid), var(--navy-deep));
    display: grid;
    place-items: center;
    position: relative;
    overflow: hidden;
}
.course-cover img { width: 100%; height: 100%; object-fit: cover; }
.course-cover .cover-icon {
    color: var(--gold);
    opacity: .4;
    font-size: 56px;
}
.course-cover .badge {
    position: absolute;
    top: 12px;
    right: 12px;
    background: var(--gold);
    color: var(--navy-deep);
    padding: 4px 12px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
}
.course-body {
    padding: 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 10px;
}
.course-body h3 {
    font-family: var(--font-serif);
    font-size: 19px;
    color: var(--text-light);
    margin: 0;
}
.course-body p {
    color: var(--text-muted);
    font-size: 14px;
    margin: 0;
    flex: 1;
}
.course-body .start-btn {
    margin-top: 8px;
    background: transparent;
    border: 1px solid var(--gold);
    color: var(--gold);
    padding: 10px 18px;
    border-radius: 8px;
    font-weight: 700;
    font-size: 14px;
    transition: .2s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    justify-content: center;
}
.course-body .start-btn:hover {
    background: var(--gold);
    color: var(--navy-deep);
}

/* فارغة */
.empty-state {
    text-align: center;
    padding: 80px 20px;
    color: var(--text-muted);
}
.empty-state i { font-size: 48px; color: var(--gold); opacity: .4; margin-bottom: 16px; }
.empty-state h3 { color: var(--text-light); font-family: var(--font-serif); }

/* =====================================================
   صفحة الدرس — shell ثنائي العمود
   ===================================================== */
.lesson-shell {
    display: grid;
    grid-template-columns: 1fr 340px;
    min-height: calc(100vh - 70px);
}

/* المحتوى الرئيسي */
.lesson-main {
    padding: 32px 36px 80px;
    background: var(--navy-main);
    border-left: 1px solid var(--gold-border);
}
.lesson-crumb {
    font-size: 13px;
    color: var(--text-muted);
    margin-bottom: 12px;
}
.lesson-crumb a { color: var(--gold); }
.lesson-crumb i { margin: 0 6px; font-size: 10px; }

.lesson-title-h {
    font-family: var(--font-serif);
    font-size: 26px;
    color: var(--text-light);
    margin: 0 0 20px;
}

/* لفافة الفيديو */
.video-wrap {
    position: relative;
    padding-top: 56.25%;
    background: var(--navy-deep);
    border-radius: var(--radius);
    overflow: hidden;
    border: 1px solid var(--gold-border);
    box-shadow: var(--shadow);
}
.video-wrap iframe {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    border: 0;
}

/* ملاحظة الدرس */
.lesson-note {
    background: var(--navy-dark);
    border: 1px solid var(--gold-border);
    border-radius: var(--radius);
    padding: 16px 20px;
    margin-top: 18px;
    color: var(--text-muted);
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.lesson-note i { color: var(--gold); font-size: 16px; flex-none; }

/* أزرار التنقل */
.nav-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-top: 20px;
    flex-wrap: wrap;
}
.nav-btn {
    background: var(--navy-dark);
    border: 1px solid var(--gold-border);
    color: var(--text-light);
    padding: 10px 20px;
    border-radius: 10px;
    font-weight: 600;
    font-size: 14px;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: .2s;
}
.nav-btn:hover { border-color: var(--gold); color: var(--gold); }
.nav-btn.disabled { opacity: .35; pointer-events: none; }
.complete-btn {
    background: var(--gold);
    color: var(--navy-deep);
    border: none;
    padding: 10px 22px;
    border-radius: 10px;
    font-weight: 700;
    font-size: 14px;
    transition: .2s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}
.complete-btn:hover { background: var(--gold-dark); color: #fff; }
.complete-btn.done { background: #2a6b4a; color: #d4f5e2; }

/* =====================================================
   الشريط الجانبي
   ===================================================== */
.sidebar {
    background: var(--navy-dark);
    display: flex;
    flex-direction: column;
    max-height: calc(100vh - 70px);
    position: sticky;
    top: 70px;
    border-right: none;
    overflow: visible;
}
.sidebar-top {
    padding: 24px 18px 0;
    flex-shrink: 0;
    overflow: visible;
}
.sidebar-top h3 {
    font-family: var(--font-serif);
    color: var(--gold);
    margin: 0 0 4px;
    font-size: 19px;
    white-space: nowrap;
}
.sidebar-top small { color: var(--text-muted); font-size: 13px; }
.sidebar-scroll {
    flex: 1;
    overflow-y: auto;
    overflow-x: hidden;
    padding: 0 18px 24px;
}

/* شريط التقدم */
.progress-wrap {
    background: rgba(212,168,83,.12);
    border-radius: 999px;
    height: 6px;
    overflow: hidden;
    margin: 12px 0 20px;
}
.progress-bar {
    height: 100%;
    background: linear-gradient(90deg, var(--gold-dark), var(--gold));
    width: 0%;
    transition: width .4s ease;
    border-radius: 999px;
}

/* قائمة الدروس */
.lesson-list {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: 6px;
}
.lesson-item {
    border: 1px solid var(--gold-border);
    border-radius: 10px;
    overflow: hidden;
    background: var(--navy-mid);
    transition: .2s;
}
.lesson-item .row {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 14px;
    cursor: pointer;
    border-right: 3px solid transparent;
    transition: .2s;
}
.lesson-item .row:hover { background: var(--gold-glow); }
.lesson-item.active { background: rgba(212,168,83,.08); }
.lesson-item.active .row { border-right-color: var(--gold); }
.lesson-num {
    width: 28px;
    height: 28px;
    flex: none;
    border-radius: 50%;
    background: var(--navy-deep);
    border: 1px solid var(--gold-border);
    display: grid;
    place-items: center;
    font-weight: 700;
    color: var(--gold);
    font-size: 12px;
}
.lesson-item.completed .lesson-num {
    background: var(--gold);
    color: var(--navy-deep);
    border-color: var(--gold);
}
.lesson-text { flex: 1; min-width: 0; }
.lesson-text .t {
    color: var(--text-light);
    font-weight: 600;
    font-size: 13px;
    white-space: normal;
    word-break: break-word;
    line-height: 1.5;
}
.lesson-text .s { color: var(--text-muted); font-size: 11px; }
.check-icon { display: none; color: var(--gold); font-size: 13px; }
.lesson-item.completed .check-icon { display: block; }

.quiz-tag {
    margin: 0 42px 10px;
    padding: 5px 10px;
    background: transparent;
    border: 1px dashed var(--gold-border);
    border-radius: 6px;
    font-size: 12px;
    color: var(--text-muted);
    display: flex;
    align-items: center;
    gap: 6px;
}
.quiz-tag.passed {
    color: var(--gold);
    border-color: var(--gold);
    background: var(--gold-glow);
}

/* =====================================================
   لوحة الاختبار
   ===================================================== */
.quiz-panel {
    margin-top: 28px;
    background: var(--navy-dark);
    border: 1px solid var(--gold-border);
    border-radius: var(--radius);
    padding: 24px;
    box-shadow: var(--shadow);
}
.quiz-panel-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--gold-border);
}
.quiz-panel-header i { color: var(--gold); font-size: 20px; }
.quiz-panel-header h3 {
    font-family: var(--font-serif);
    color: var(--text-light);
    margin: 0;
    font-size: 20px;
}
.q-block {
    border: 1px solid var(--gold-border);
    border-radius: var(--radius);
    padding: 18px;
    margin-bottom: 14px;
    background: var(--navy-mid);
}
.q-title {
    font-weight: 700;
    color: var(--text-light);
    margin: 0 0 14px;
    font-size: 15px;
}
.choices { display: flex; flex-direction: column; gap: 8px; }
.choice {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    border: 1px solid var(--gold-border);
    background: var(--navy-dark);
    border-radius: 10px;
    cursor: pointer;
    transition: .15s;
    color: var(--text-light);
    font-size: 14px;
}
.choice:hover { border-color: var(--gold); background: var(--gold-glow); }
.choice input { accent-color: var(--gold); }
.choice.correct { border-color: #3a9e6a; background: rgba(58,158,106,.12); color: #a8f0c8; }
.choice.wrong   { border-color: #c0504a; background: rgba(192,80,74,.12);  color: #f5bcba; }
.q-actions {
    margin-top: 12px;
    display: flex;
    gap: 12px;
    align-items: center;
}
.check-btn {
    background: transparent;
    border: 1px solid var(--gold);
    color: var(--gold);
    padding: 8px 20px;
    border-radius: 8px;
    font-weight: 700;
    font-size: 13px;
    transition: .2s;
}
.check-btn:hover { background: var(--gold); color: var(--navy-deep); }
.result { font-weight: 700; font-size: 13px; }
.result.ok  { color: #6ddfaa; }
.result.bad { color: #f08080; }
.no-quiz {
    text-align: center;
    padding: 20px;
    color: var(--text-muted);
    font-size: 14px;
}

/* =====================================================
   Footer — مطابق للرئيسية
   ===================================================== */
.footer {
    background: var(--navy-deep);
    border-top: 1px solid var(--gold-border);
    color: var(--text-muted);
    font-size: 13px;
}
.footer-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: 40px 24px 24px;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 32px;
}
.footer-section h4 {
    font-family: var(--font-serif);
    color: var(--gold);
    margin: 0 0 14px;
    font-size: 17px;
}
.footer-section p { margin: 0; line-height: 1.7; }
.footer-links { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 8px; }
.footer-links a:hover { color: var(--gold); }
.footer-bottom {
    border-top: 1px solid var(--gold-border);
    text-align: center;
    padding: 16px 24px;
    font-size: 12px;
}

/* =====================================================
   موبايل
   ===================================================== */
@media (max-width: 980px) {
    .mobile-toggle { display: flex; }
    .navbar-menu   { display: none; }
    .lesson-shell  { grid-template-columns: 1fr; }
    .sidebar {
        position: fixed;
        inset: 70px 0 0 auto;
        right: 0;
        width: 300px;
        max-width: 85vw;
        max-height: calc(100vh - 70px);
        transform: translateX(100%);
        transition: transform .3s ease;
        z-index: 40;
        box-shadow: -12px 0 40px rgba(0,0,0,.5);
        overflow: visible;
    }
    .sidebar.open { transform: translateX(0); }
    .backdrop {
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,.55);
        z-index: 30;
        opacity: 0;
        pointer-events: none;
        transition: opacity .2s;
    }
    .backdrop.show { opacity: 1; pointer-events: auto; }
    .lesson-main { padding: 18px 16px 60px; border-left: none; }
}

@media (max-width: 600px) {
    .nav-row { flex-direction: column; }
    .nav-btn, .complete-btn { width: 100%; justify-content: center; }
    .courses-grid { grid-template-columns: 1fr; }
}
</style>
</head>
<body>

<!-- =====================================================
     شريط التنقل — نفس index.html
     ===================================================== -->
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
                <a href="#" class="nav-link">عن المشروع <i class="fas fa-chevron-down" style="font-size:11px;"></i></a>
                <ul class="dropdown-menu">
                    <li><a href="index.html#introduction" class="dropdown-item">نبذة عن المشروع</a></li>
                    <li><a href="index.html#founder"      class="dropdown-item">المؤسس والمشرف</a></li>
                    <li><a href="index.html#teachers"     class="dropdown-item">هيئة التدريس</a></li>
                    <li><a href="index.html#achievements" class="dropdown-item">إنجازات المشروع</a></li>
                </ul>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link">الخدمات <i class="fas fa-chevron-down" style="font-size:11px;"></i></a>
                <ul class="dropdown-menu">
                    <li><a href="index.html#requirements" class="dropdown-item">شروط القبول</a></li>
                    <li><a href="apply.html"              class="dropdown-item">التسجيل</a></li>
                    <li><a href="#"                       class="dropdown-item">الإجازات القرآنية</a></li>
                    <li><a href="Playlists.php"           class="dropdown-item">الدورات التأهيلية</a></li>
                    <li><a href="#"                       class="dropdown-item">الاستشارات القرآنية</a></li>
                </ul>
            </li>
        </ul>

        <?php if ($selectedPlaylist): ?>
        <button class="mobile-toggle" onclick="toggleSidebar()" aria-label="قائمة الدروس">
            <span></span><span></span><span></span>
        </button>
        <?php else: ?>
        <div class="mobile-toggle" id="mobileToggle">
            <span></span><span></span><span></span>
        </div>
        <?php endif; ?>
    </div>
</nav>

<?php if (!$selectedPlaylist): ?>
<!-- =====================================================
     صفحة الدورات
     ===================================================== -->

<div class="page-hero">
    <div class="breadcrumb-top">
        <a href="index.html">الرئيسية</a>
        <span><i class="fas fa-chevron-left" style="font-size:10px;"></i></span>
        <span>الدورات التأهيلية</span>
    </div>
    <h1>الدورات <span>التأهيلية</span></h1>
    <p>اختر من بين دوراتنا المنهجية في القراءات العشر وابدأ رحلتك مع كتاب الله تعالى</p>
    <div class="gold-line"></div>
</div>

<section class="courses-section">
    <div class="section-header-inner">
        <h2>الدورات المتاحة</h2>
        <p>برامج علمية متكاملة على يد نخبة من المقرئين المتخصصين</p>
    </div>

    <?php if (!count($playlists)): ?>
        <div class="empty-state">
            <i class="fas fa-book-quran"></i>
            <h3>لا توجد دورات متاحة حالياً</h3>
            <p>سيتم إضافة الدورات قريباً، تابعونا.</p>
        </div>
    <?php else: ?>
        <div class="courses-grid">
            <?php foreach ($playlists as $p): ?>
            <article class="course-card">
                <div class="course-cover">
                    <?php if (!empty($p['Cover'])): ?>
                        <img src="<?= e($p['Cover']) ?>" alt="<?= e($p['Title']) ?>">
                    <?php else: ?>
                        <i class="fas fa-book-open-reader cover-icon"></i>
                    <?php endif; ?>
                    <span class="badge">دورة</span>
                </div>
                <div class="course-body">
                    <h3><?= e($p['Title']) ?></h3>
                    <p><?= e($p['Notes']) ?: 'دورة منهجية في تلاوة القرآن الكريم وإتقان أحكام التجويد.' ?></p>
                    <a href="?playlist=<?= intval($p['PlaylistID']) ?>">
                        <button class="start-btn">
                            <i class="fas fa-play-circle"></i>
                            ابدأ الدورة
                        </button>
                    </a>
                </div>
            </article>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</section>

<?php else: ?>
<!-- =====================================================
     صفحة الدرس
     ===================================================== -->
<?php if (!count($videos)): ?>
    <div class="empty-state" style="padding:100px 20px;">
        <i class="fas fa-video-slash"></i>
        <h3>لا توجد فيديوهات في هذه الدورة بعد</h3>
        <a href="?" style="display:inline-block;margin-top:20px;padding:12px 24px;background:var(--gold);color:var(--navy-deep);border-radius:10px;font-weight:700;">
            العودة للدورات
        </a>
    </div>
<?php else: ?>

<div class="lesson-shell">

    <!-- المحتوى الرئيسي -->
    <main class="lesson-main">

        <div class="lesson-crumb">
            <a href="?">الدورات</a>
            <i class="fas fa-chevron-left"></i>
            <span>الدرس <?= array_search($currentVideo, $videos) + 1 ?></span>
        </div>

        <h1 class="lesson-title-h" id="lessonTitle"><?= e($currentVideo['Title']) ?></h1>

        <div class="video-wrap">
            <iframe id="videoFrame"
                    src="<?= e($currentVideo['URL_Embed']) ?>"
                    allowfullscreen
                    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture">
            </iframe>
        </div>

        <div class="lesson-note">
            <i class="fas fa-lightbulb"></i>
            تابع الدرس بتركيز، ثم انتقل إلى الاختبار في الأسفل لتثبيت ما تعلّمته.
        </div>

        <?php
        $idx  = array_search($currentVideo, $videos);
        $prev = $idx > 0              ? $videos[$idx-1] : null;
        $next = $idx < count($videos)-1 ? $videos[$idx+1] : null;
        ?>
        <div class="nav-row">
            <a class="nav-btn <?= $prev ? '' : 'disabled' ?>"
               href="?playlist=<?= $selectedPlaylist ?>&video=<?= $prev ? intval($prev['VideoID']) : '' ?>">
                <i class="fas fa-chevron-right"></i>
                الدرس السابق
            </a>

            <button class="complete-btn" id="completeBtn"
                    data-video="<?= intval($currentVideo['VideoID']) ?>"
                    data-playlist="<?= $selectedPlaylist ?>"
                    onclick="markComplete(this)">
                <i class="fas fa-check"></i>
                تم إكمال الدرس
            </button>

            <a class="nav-btn <?= $next ? '' : 'disabled' ?>"
               href="?playlist=<?= $selectedPlaylist ?>&video=<?= $next ? intval($next['VideoID']) : '' ?>">
                الدرس التالي
                <i class="fas fa-chevron-left"></i>
            </a>
        </div>

        <!-- لوحة الاختبار -->
        <?php if (isset($quizzes[$currentVideo['VideoID']])): ?>
        <section class="quiz-panel" id="quizPanel">
            <div class="quiz-panel-header">
                <i class="fas fa-clipboard-question"></i>
                <h3>اختبار الدرس</h3>
            </div>

            <?php foreach ($quizzes[$currentVideo['VideoID']] as $qid => $q): ?>
            <div class="q-block" data-qid="<?= $qid ?>">
                <p class="q-title"><?= e($q['question']) ?></p>
                <div class="choices">
                    <?php foreach ($q['choices'] as $choice): ?>
                    <label class="choice">
                        <input type="radio"
                               name="q_<?= $currentVideo['VideoID'] ?>_<?= $qid ?>"
                               data-correct="<?= $choice['isTrue'] ?>">
                        <span><?= e($choice['text']) ?></span>
                    </label>
                    <?php endforeach; ?>
                </div>
                <div class="q-actions">
                    <button class="check-btn" onclick="checkAnswer(this)">تحقق من الإجابة</button>
                    <span class="result"></span>
                </div>
            </div>
            <?php endforeach; ?>
        </section>
        <?php else: ?>
        <div class="quiz-panel">
            <p class="no-quiz"><i class="fas fa-info-circle" style="color:var(--gold);margin-left:6px;"></i>لا يوجد اختبار لهذا الدرس.</p>
        </div>
        <?php endif; ?>
    </main>

    <!-- الشريط الجانبي -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-top">
            <h3>محتوى الدورة</h3>
            <small><?= count($videos) ?> دروس</small>
        </div>
        <div class="sidebar-scroll">
        <div class="progress-wrap">
            <div class="progress-bar" id="progressBar"></div>
        </div>

        <ul class="lesson-list">
            <?php foreach ($videos as $i => $v): ?>
            <?php
            $isActive = intval($v['VideoID']) === intval($currentVideo['VideoID']);
            $vid      = intval($v['VideoID']);
            $hasQuiz  = isset($quizzes[$vid]);
            ?>
            <li class="lesson-item <?= $isActive ? 'active' : '' ?>"
                data-video="<?= $vid ?>"
                data-playlist="<?= $selectedPlaylist ?>">
                <a class="row" href="?playlist=<?= $selectedPlaylist ?>&video=<?= $vid ?>">
                    <span class="lesson-num"><?= $i+1 ?></span>
                    <span class="lesson-text">
                        <span class="t"><?= e($v['Title']) ?></span>
                        <span class="s">درس <?= $i+1 ?></span>
                    </span>
                    <i class="fas fa-check-circle check-icon"></i>
                </a>
                <?php if ($hasQuiz): ?>
                <div class="quiz-tag" data-quiz-tag="<?= $vid ?>">
                    <i class="fas fa-pen-to-square"></i>
                    <span>اختبار الدرس</span>
                </div>
                <?php endif; ?>
            </li>
            <?php endforeach; ?>
        </ul>
        </div><!-- end sidebar-scroll -->
    </aside>

    <div class="backdrop" id="backdrop" onclick="toggleSidebar()"></div>
</div>

<?php endif; ?>
<?php endif; ?>

<!-- =====================================================
     Footer — مطابق للرئيسية
     ===================================================== -->
<footer class="footer">
    <div class="footer-content">
        <div class="footer-section">
            <h4>مشروع تلاوة القرآن الكريم</h4>
            <p>مشروع علمي قرآني يهدف إلى تخريج مئة حافظ سنوياً في القراءات العشر الصغرى، على منهاج الأزهر الشريف.</p>
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
                <li><i class="fas fa-phone" style="color:var(--gold);margin-left:8px;"></i><span>[رقم الهاتف]</span></li>
                <li><i class="fas fa-envelope" style="color:var(--gold);margin-left:8px;"></i><span>[البريد الإلكتروني]</span></li>
                <li><i class="fas fa-map-marker-alt" style="color:var(--gold);margin-left:8px;"></i><span>[العنوان]</span></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>جميع الحقوق محفوظة © مشروع تلاوة القرآن الكريم 2024</p>
    </div>
</footer>

<script>
/* =====================================================
   إدارة التقدم في localStorage
   ===================================================== */
const PLAYLIST_ID = <?= $selectedPlaylist ? intval($selectedPlaylist) : 'null' ?>;
const STORAGE_KEY = PLAYLIST_ID ? 'quran_progress_' + PLAYLIST_ID : null;

function loadProgress() {
    if (!STORAGE_KEY) return { completed: [], quizPassed: [] };
    try { return JSON.parse(localStorage.getItem(STORAGE_KEY)) || { completed: [], quizPassed: [] }; }
    catch(e) { return { completed: [], quizPassed: [] }; }
}
function saveProgress(p) {
    if (STORAGE_KEY) localStorage.setItem(STORAGE_KEY, JSON.stringify(p));
}

function applyProgressUI() {
    if (!PLAYLIST_ID) return;
    const p = loadProgress();
    document.querySelectorAll('.lesson-item').forEach(it => {
        const vid = parseInt(it.dataset.video);
        if (p.completed.includes(vid)) it.classList.add('completed');
        const tag = it.querySelector('[data-quiz-tag]');
        if (tag && p.quizPassed.includes(vid)) {
            tag.classList.add('passed');
            tag.querySelector('span').textContent = 'تم اجتياز الاختبار ✓';
        }
    });
    const total = document.querySelectorAll('.lesson-item').length;
    const done  = p.completed.length;
    const bar   = document.getElementById('progressBar');
    if (bar && total) bar.style.width = Math.round(done / total * 100) + '%';

    const btn = document.getElementById('completeBtn');
    if (btn && p.completed.includes(parseInt(btn.dataset.video))) {
        btn.innerHTML = '<i class="fas fa-check-double"></i> تم الإكمال';
        btn.classList.add('done');
    }
}

function markComplete(btn) {
    const v = parseInt(btn.dataset.video);
    const p = loadProgress();
    if (!p.completed.includes(v)) p.completed.push(v);
    saveProgress(p);
    applyProgressUI();
    const quiz = document.getElementById('quizPanel');
    if (quiz) quiz.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function checkAnswer(btn) {
    const block   = btn.closest('.q-block');
    const radios  = block.querySelectorAll('input[type=radio]');
    const result  = block.querySelector('.result');
    let answered  = false, correct = false, chosen = null;

    radios.forEach(r => {
        r.parentElement.classList.remove('correct', 'wrong');
        if (r.checked) { answered = true; chosen = r.parentElement; correct = r.dataset.correct === '1'; }
    });

    if (!answered) { result.textContent = 'اختر إجابة أولاً'; result.className = 'result'; return; }

    if (correct) {
        chosen.classList.add('correct');
        result.textContent = 'أحسنت! إجابة صحيحة ✓';
        result.className = 'result ok';
        checkQuizPassed();
    } else {
        chosen.classList.add('wrong');
        radios.forEach(r => { if (r.dataset.correct === '1') r.parentElement.classList.add('correct'); });
        result.textContent = 'إجابة غير صحيحة — راجع الإجابة الصحيحة';
        result.className = 'result bad';
    }
}

function checkQuizPassed() {
    const blocks = document.querySelectorAll('#quizPanel .q-block');
    if (!blocks.length) return;
    let allOk = true;
    blocks.forEach(b => { if (!b.querySelector('.result.ok')) allOk = false; });
    if (!allOk) return;
    const btn = document.getElementById('completeBtn');
    if (!btn) return;
    const v = parseInt(btn.dataset.video);
    const p = loadProgress();
    if (!p.quizPassed.includes(v)) p.quizPassed.push(v);
    if (!p.completed.includes(v))  p.completed.push(v);
    saveProgress(p);
    applyProgressUI();
}

function toggleSidebar() {
    const s = document.getElementById('sidebar');
    const b = document.getElementById('backdrop');
    if (!s) return;
    s.classList.toggle('open');
    b.classList.toggle('show');
    document.body.style.overflow = s.classList.contains('open') ? 'hidden' : '';
}

document.addEventListener('DOMContentLoaded', applyProgressUI);
</script>

</body>
</html>
<?php $conn->close(); ?>
