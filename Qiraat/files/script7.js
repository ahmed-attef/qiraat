/**
 * مشروع تلاوة القرآن الكريم - JavaScript الرئيسي
 * تم إصلاح جميع المشاكل ودمج الكود
 */

// =====================================================
// Mobile Navigation Toggle
// =====================================================
document.addEventListener('DOMContentLoaded', function() {
    const mobileToggle = document.getElementById('mobileToggle');
    const navbarMenu = document.getElementById('navbarMenu');

    if (mobileToggle && navbarMenu) {
        mobileToggle.addEventListener('click', function() {
            this.classList.toggle('active');
            navbarMenu.classList.toggle('active');
        });
    }

    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        const link = item.querySelector('.nav-link');
        const dropdown = item.querySelector('.dropdown-menu');
        if (dropdown && link) {
            link.addEventListener('click', function(e) {
                if (window.innerWidth <= 768) {
                    e.preventDefault();
                    item.classList.toggle('active');
                    navItems.forEach(other => { if (other !== item) other.classList.remove('active'); });
                }
            });
        }
    });

    document.addEventListener('click', function(e) {
        if (!e.target.closest('.navbar')) {
            if (navbarMenu) navbarMenu.classList.remove('active');
            if (mobileToggle) mobileToggle.classList.remove('active');
        }
    });

    window.addEventListener('resize', function() {
        if (window.innerWidth > 768) {
            if (navbarMenu) navbarMenu.classList.remove('active');
            if (mobileToggle) mobileToggle.classList.remove('active');
        }
    });

    // Fade-in animations
    document.querySelectorAll('section').forEach(section => {
        section.classList.add('fade-in');
        observer.observe(section);
    });
    document.querySelectorAll('.teacher-card, .requirement-item').forEach((card, index) => {
        card.style.transitionDelay = `${index * 0.1}s`;
        card.classList.add('fade-in');
        observer.observe(card);
    });
});

// =====================================================
// Smooth Scroll
// =====================================================
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        const href = this.getAttribute('href');
        if (href !== '#') {
            e.preventDefault();
            const target = document.querySelector(href);
            if (target) {
                const navbar = document.querySelector('.navbar');
                const navbarHeight = navbar ? navbar.offsetHeight : 0;
                window.scrollTo({ top: target.getBoundingClientRect().top + window.pageYOffset - navbarHeight, behavior: 'smooth' });
                const nm = document.getElementById('navbarMenu');
                const mt = document.getElementById('mobileToggle');
                if (nm) nm.classList.remove('active');
                if (mt) mt.classList.remove('active');
            }
        }
    });
});

// =====================================================
// Navbar Shadow on Scroll
// =====================================================
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        navbar.style.boxShadow = window.scrollY > 50
            ? '0 4px 30px rgba(30, 58, 138, 0.3)'
            : '0 4px 20px rgba(30, 58, 138, 0.15)';
    }
});

// =====================================================
// Fade In Observer
// =====================================================
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => { if (entry.isIntersecting) entry.target.classList.add('visible'); });
}, { root: null, rootMargin: '0px', threshold: 0.1 });

document.querySelectorAll('.fade-in').forEach(el => observer.observe(el));

// =====================================================
// Gender → Appointment (خارج submit handler - إصلاح المشكلة الرئيسية)
// =====================================================
const genderSelect = document.getElementById('gender');
if (genderSelect) {
    genderSelect.addEventListener('change', function() {
        const gender = this.value;
        const appointmentGroup = document.getElementById('appointmentGroup');
        const appointmentInput = document.getElementById('appointment');
        const appointmentDb    = document.getElementById('appointment_date_db');

        if (!appointmentGroup) return;

        if (gender) {
            appointmentGroup.style.display = 'block';
            if (appointmentInput) appointmentInput.value = 'جاري حساب أقرب موعد متاح...';

            fetch('get_appointment.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'gender=' + encodeURIComponent(gender)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    if (appointmentInput) appointmentInput.value = data.date;
                    if (appointmentDb)    appointmentDb.value    = data.raw_date;
                } else {
                    if (appointmentInput) appointmentInput.value = 'لا توجد مواعيد متاحة حالياً';
                }
            })
            .catch(() => {
                if (appointmentInput) appointmentInput.value = 'حدث خطأ في الاتصال';
            });
        } else {
            appointmentGroup.style.display = 'none';
        }
    });
}

// =====================================================
// Form Submission — Google Sheets (للـ HTML static فقط)
// =====================================================
const applicationForm = document.getElementById('applicationForm');
const successMessage  = document.getElementById('successMessage');
const submitBtn       = document.getElementById('submitBtn');

if (applicationForm && applicationForm.action &&
    !applicationForm.action.includes('apply.php')) {

    applicationForm.addEventListener('submit', async function(e) {
        e.preventDefault();

        const get = id => (document.getElementById(id) || {}).value || '';

        const formData = {
            fullName:         get('fullName'),
            age:              get('age'),
            address:          get('address'),
            city:             get('city'),
            phone:            get('phone'),
            gender:           get('gender'),
            education:        get('education'),
            appointment_date: get('appointment_date_db'),
            timestamp:        new Date().toISOString()
        };

        if (submitBtn) { submitBtn.disabled = true; submitBtn.innerHTML = '<span>جاري الإرسال...</span>'; }

        const formAction = applicationForm.action;

        if (!formAction || formAction.includes('YOUR_GOOGLE_SHEETS_SCRIPT_URL')) {
            setTimeout(() => { console.log('Demo Mode:', formData); showSuccess(); }, 1500);
            return;
        }

        try {
            await fetch(formAction, {
                method: 'POST', mode: 'no-cors',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            });
            showSuccess();
        } catch (err) {
            console.error(err);
            if (submitBtn) { submitBtn.disabled = false; submitBtn.innerHTML = '<span>إعادة المحاولة</span>'; }
            alert('حدث خطأ أثناء إرسال الطلب. يرجى المحاولة مرة أخرى.');
        }
    });
}

function showSuccess() {
    if (applicationForm) applicationForm.style.display = 'none';
    if (successMessage) {
        successMessage.classList.add('show');
        successMessage.style.display = 'block';
        successMessage.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
}

// =====================================================
// Form Validation
// =====================================================
document.querySelectorAll('.form-group input, .form-group select').forEach(input => {
    input.addEventListener('focus', function() { this.parentElement.classList.add('focused'); });
    input.addEventListener('blur', function() {
        this.parentElement.classList.remove('focused');
        this.classList.toggle('valid', this.value.trim() !== '');
    });
});

// =====================================================
// Phone Input
// =====================================================
const phoneInput = document.getElementById('phone');
if (phoneInput) {
    phoneInput.addEventListener('input', function() {
        let v = this.value.replace(/[^\d+]/g, '');
        if (v.length > 15) v = v.substring(0, 15);
        this.value = v;
    });
}

// =====================================================
// Age Input
// =====================================================
const ageInput = document.getElementById('age');
if (ageInput) {
    ageInput.addEventListener('input', function() {
        let v = this.value.replace(/[^\d]/g, '');
        if (v) { if (parseInt(v) < 10) v = '10'; if (parseInt(v) > 80) v = '80'; }
        this.value = v;
    });
}

// =====================================================
// Video Player
// =====================================================
function playVideo(container, videoId) {
    var iframe = document.createElement('iframe');
    iframe.src = "https://www.youtube.com/embed/" + videoId + "?autoplay=1";
    iframe.style.cssText = "position:absolute;top:0;left:0;width:100%;height:100%;border:none;";
    iframe.allow = "autoplay; encrypted-media";
    iframe.allowFullscreen = true;
    container.innerHTML = "";
    container.appendChild(iframe);
    container.onclick = null;
    container.style.cursor = 'default';
}
