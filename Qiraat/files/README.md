# مشروع تلاوة القرآن الكريم
# Quran Recitation Project Website

موقع ويب احترافي لمشروع تلاوة القرآن الكريم، مصمم بأسلوب إسلامي أزهري أنيق مع دعم كامل للغة العربية (RTL).

## 📁 هيكل المشروع

```
quran-recitation-project/
├── index.html          # الصفحة الرئيسية
├── apply.html          # صفحة التسجيل
├── styles.css          # ملف الأنماط الرئيسي
├── script.js           # ملف JavaScript
├── images/             # مجلد الصور
│   ├── logo.png                    # شعار المشروع
│   ├── islamic-pattern.png         # النمط الإسلامي للخلفية
│   ├── ornament-divider.png        # زخرفة فاصلة
│   ├── founder-placeholder.png     # صورة المؤسس
│   ├── teacher-male-placeholder.png   # صورة معلم
│   └── teacher-female-placeholder.png # صورة معلمة
└── README.md           # ملف التوثيق
```

## ✨ المميزات

- ✅ تصميم RTL كامل للغة العربية
- ✅ ألوان ملكية (أزرق ملكي + ذهبي)
- ✅ زخارف إسلامية مستوحاة من الأزهر
- ✅ تصميم متجاوب (موبايل + ديسكتوب)
- ✅ قائمة تنقل منسدلة احترافية
- ✅ نموذج تسجيل متصل بـ Google Sheets
- ✅ أداء سريع وخفيف
- ✅ سهل التعديل والتخصيص

## 🚀 طريقة الاستخدام

### 1. تشغيل الموقع محلياً
افتح ملف `index.html` في أي متصفح ويب.

### 2. رفع الموقع على الإنترنت
يمكنك رفع المجلد كاملاً إلى أي استضافة ويب مثل:
- Netlify (مجاني)
- Vercel (مجاني)
- GitHub Pages (مجاني)
- أي استضافة تقليدية

## 📊 ربط نموذج التسجيل بـ Google Sheets

### الخطوة 1: إنشاء Google Sheet
1. أنشئ جدول بيانات Google جديد
2. أضف العناوين التالية في الصف الأول:
   - التاريخ
   - الاسم الكامل
   - العمر
   - العنوان
   - المدينة
   - رقم الهاتف
   - الجنس

### الخطوة 2: إنشاء Google Apps Script
1. من الجدول، اذهب إلى: Extensions > Apps Script
2. احذف الكود الافتراضي والصق الكود التالي:

```javascript
function doPost(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var data = JSON.parse(e.postData.contents);
  
  sheet.appendRow([
    new Date(),
    data.fullName,
    data.age,
    data.address,
    data.city,
    data.phone,
    data.gender
  ]);
  
  return ContentService.createTextOutput(
    JSON.stringify({ result: 'success' })
  ).setMimeType(ContentService.MimeType.JSON);
}

function doGet(e) {
  return ContentService.createTextOutput(
    JSON.stringify({ result: 'success' })
  ).setMimeType(ContentService.MimeType.JSON);
}
```

### الخطوة 3: نشر التطبيق
1. اضغط على Deploy > New Deployment
2. اختر نوع "Web app"
3. في "Who has access" اختر "Anyone"
4. اضغط Deploy وانسخ رابط الـ Web app

### الخطوة 4: تحديث الموقع
1. افتح ملف `apply.html`
2. ابحث عن `YOUR_GOOGLE_SHEETS_SCRIPT_URL`
3. استبدله بالرابط الذي نسخته

## 🎨 تخصيص الألوان

يمكنك تعديل الألوان من ملف `styles.css` في المتغيرات:

```css
:root {
    --primary-color: #1e3a8a;      /* الأزرق الملكي */
    --primary-dark: #1e2d5e;       /* الأزرق الداكن */
    --gold: #d4af37;               /* الذهبي */
    --gold-light: #f0d77d;         /* الذهبي الفاتح */
}
```

## 📝 تخصيص المحتوى

### تحديث معلومات المؤسس
- افتح `index.html`
- ابحث عن قسم `id="founder"`
- عدّل الاسم والسيرة الذاتية

### تحديث معلومات المعلمين
- ابحث عن قسم `id="teachers"`
- عدّل بطاقات المعلمين

### إضافة صور حقيقية
استبدل الصور في مجلد `images/` مع الحفاظ على نفس الأسماء أو حدّث المسارات في HTML.

## 📱 التوافق

- ✅ Chrome (جميع الإصدارات)
- ✅ Firefox (جميع الإصدارات)
- ✅ Safari (جميع الإصدارات)
- ✅ Edge (جميع الإصدارات)
- ✅ الهواتف المحمولة (iOS + Android)
- ✅ الأجهزة اللوحية

## 📞 الدعم

لأي استفسارات أو مساعدة في التخصيص، يمكنك التواصل عبر إضافة Issue في المستودع.

---

**جميع الحقوق محفوظة © مشروع تلاوة القرآن الكريم 2024**
