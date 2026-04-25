# ONYX Dotfiles

> نظام إعدادات شخصي مبني على **Hyprland** — نظيف، سريع، وقابل للتخصيص الكامل عبر نظام ثيمات موحّد.

---

## 📋 المحتويات

- [المكونات](#-المكونات)
- [المميزات](#-المميزات)
  - [نظام الثيمات](#-نظام-الثيمات)
  - [شاشة تسجيل الدخول SDDM](#-شاشة-تسجيل-الدخول-sddm)
  - [قائمة خلفيات الشاشة](#-قائمة-خلفيات-الشاشة)
  - [الحافظة](#-الحافظة)
  - [شاشة القفل](#-شاشة-القفل)
  - [قائمة Rofi الرئيسية](#-قائمة-rofi-الرئيسية)
  - [Wi-Fi والبلوتوث](#-wi-fi-والبلوتوث)
  - [مشغّل الوسائط](#-مشغّل-الوسائط)
  - [إضاءة الليل](#-إضاءة-الليل)
  - [مجموعات النوافذ المبوّبة](#-مجموعات-النوافذ-المبوّبة)
  - [Scratchpad](#-scratchpad)
  - [مراقبة البطارية](#-مراقبة-البطارية)
  - [نظام Hooks](#-نظام-hooks)
  - [نظام المهاجرة التلقائية](#-نظام-المهاجرة-التلقائية)
  - [أداة Debug](#-أداة-debug)
  - [ملفات Waybar الديناميكية](#-ملفات-waybar-الديناميكية)
  - [ملفات تعريف الطاقة](#-ملفات-تعريف-الطاقة)
- [التثبيت](#-التثبيت)
- [التبعيات](#-التبعيات)
- [اختصارات لوحة المفاتيح](#-اختصارات-لوحة-المفاتيح)
- [هيكل الملفات](#-هيكل-الملفات)
- [الإعداد اليدوي بعد التثبيت](#-الإعداد-اليدوي-بعد-التثبيت)
- [ملاحظات](#-ملاحظات)

---

## 🖥️ المكونات

| المكوّن | الأداة |
|---------|--------|
| Compositor | Hyprland |
| شريط الحالة | Waybar |
| مشغّل التطبيقات | Rofi (Wayland) |
| الطرفية | Kitty |
| الإشعارات | SwayNC |
| خلفية الشاشة | awww |
| شاشة القفل | Hyprlock + Hypridle |
| الـ Shell | Zsh |
| مؤشر الـ Shell | Starship |
| مدير الملفات (واجهة رسومية) | Nautilus |
| مدير الملفات (TUI) | Yazi |
| الحافظة | cliphist |
| مراقب النظام | btop |
| المُرئي الصوتي | cava |
| معاينة الملفات | ctpv |
| بديل `ls` | lsd |
| إضاءة الليل | hyprsunset |
| المُتعدِّد للطرفية | tmux |
| أداة المعلومات | fastfetch |
| محرر لقطات الشاشة | Satty |
| مسجّل الشاشة | gpu-screen-recorder |
| شاشة تسجيل الدخول | SDDM |

---

## ✨ المميزات

### 🎨 نظام الثيمات

**الثيمات المتاحة:**

| الثيم | النوع |
|-------|-------|
| `void_purple` | Dark |
| `deep_cyan` | Dark |
| `sakura_pink` | Light |
| `lavender` | Light |
| `sky_blue` | Light |
| `inferno` | Light |

**نطاق التطبيق:** Waybar · SwayNC · Kitty · Rofi · btop · cava · Starship · حدود النوافذ · خلفية الشاشة · الأيقونات · GTK

#### آلية العمل

كل ثيم عبارة عن ملف واحد `colors.toml` يحتوي على جميع قيم الألوان. عند تطبيق أي ثيم، يقوم `theme-set.sh` تلقائياً بتوليد جميع ملفات الإعداد من القوالب الموجودة في `~/.config/themes/templates/`.

```bash
# تطبيق ثيم مباشرة من الطرفية
~/.config/hypr/scripts/theme-set.sh void_purple
~/.config/hypr/scripts/theme-set.sh sky_blue
~/.config/hypr/scripts/theme-set.sh sakura_pink

# أو من واجهة Rofi: Super + Space → Style → Theme
```

#### إضافة ثيم جديد

```bash
# أنشئ مجلد الثيم داخل dark أو light حسب النوع
mkdir -p ~/.config/themes/dark/my_theme

# أنشئ ملف colors.toml فقط — النظام يولّد الباقي تلقائياً
# انظر أي ثيم موجود كنموذج
```

---

### 🖥️ شاشة تسجيل الدخول SDDM

**الثيمات المتاحة:**
- `silent` — ثيم نظيف وهادئ مع دعم اختيار الجلسة ولوحة المفاتيح الافتراضية
- `astronaut` — ثيم بأسلوب فضائي

تحتوي ثيمات SDDM على خط **Red Hat** المدمج (Regular, Bold, Mono, Display) ودعم كامل للوحة المفاتيح الافتراضية عبر `QtQuick.VirtualKeyboard`.

لتغيير الثيم:
```bash
# من Rofi: Super + Space → Style → SDDM Theme
# أو من الطرفية:
~/.config/rofi/scripts/sddm-theme.sh
```

---

### 🖼️ قائمة خلفيات الشاشة (`Super + I`)

يفتح قائمة Rofi تعرض معاينات مصغّرة لجميع الصور الموجودة في `~/Pictures/Wallpapers/`.  
يتم حفظ مسار الخلفية الحالية وإعادة تطبيقها تلقائياً عند كل إقلاع عبر `restore_wallpaper.sh`.

لدعم خلفيات الفيديو:
```bash
~/.config/hypr/scripts/video-wallpaper.sh
```

---

### 📋 الحافظة

| الاختصار | الوظيفة |
|----------|---------|
| `Super + C` | الحافظة النصية مع سجل كامل |
| `Super + Shift + C` | الحافظة المرئية مع معاينات مصغّرة |

تعمل الحافظة عبر `cliphist` وتخزّن النصوص والصور بشكل منفصل.

---

### 🔒 شاشة القفل (`Super + Shift + X`)

مبنية على **Hyprlock + Hypridle** مع:
- لقطة شاشة ضبابية كخلفية
- عرض الوقت والتاريخ في المنتصف بخط **Electroharmonix**
- حقل إدخال كلمة المرور بزوايا حادة
- عرض مستوى البطارية عبر `battery.sh`
- مؤشر تغيير لغة لوحة المفاتيح عبر `lang_notify.sh`

---

### 🚀 قائمة Rofi الرئيسية (`Super + Space`)

| الخيار | الوظيفة |
|--------|---------|
| Apps | مشغّل التطبيقات الكامل |
| Install | تثبيت الحزم (Pacman / AUR) |
| Remove | إزالة الحزم |
| Update | تحديث النظام |
| Wallpaper | تغيير خلفية الشاشة |
| Style | الثيمات وثيم SDDM |
| About | معلومات النظام (fastfetch) |
| System | القفل · تسجيل الخروج · التعليق · إعادة التشغيل · الإيقاف |

---

### 📡 Wi-Fi والبلوتوث

- **قائمة Wi-Fi** — الاتصال بالشبكات مباشرةً من Rofi
- **قائمة البلوتوث** — إدارة الأجهزة المقترنة من Rofi
- الوصول عبر: `Super + Space` ← القوائم المخصصة، أو النقر على Waybar

---

### 🎵 مشغّل الوسائط (`Super + O`)

يعرض تحكمات مشغّل الوسائط الحالي في نافذة Rofi عائمة:
- اسم المسار الحالي
- أزرار التشغيل/الإيقاف، التالي، السابق

---

### 🌙 إضاءة الليل (hyprsunset)

يضبط درجة حرارة اللون الدافئة لتقليل إجهاد العينين في الليل.

| الاختصار | الوظيفة |
|----------|---------|
| `Super + Shift + N` | تبديل إضاءة الليل |
| `Super + F7` | تبديل إضاءة الليل (بديل) |

---

### 🪟 مجموعات النوافذ المبوّبة

يدعم Hyprland تجميع النوافذ في علامات تبويب (Groups):

| الاختصار | الوظيفة |
|----------|---------|
| `Super + G` | تبديل مجموعة النافذة |
| `Super + Alt + G` | نقل النافذة خارج المجموعة |
| `Super + Alt + Tab` | التنقل للأمام في علامات التبويب |
| `Super + Alt + Shift + Tab` | التنقل للخلف في علامات التبويب |
| `Super + Ctrl + Left/Right` | التنقل بين علامات تبويب المجموعة |
| `Super + Alt + Arrows` | نقل النافذة إلى مجموعة مجاورة |

---

### 📌 Scratchpad

نافذة خفية يمكن استدعاؤها في أي وقت:

| الاختصار | الوظيفة |
|----------|---------|
| `Super + S` | إظهار/إخفاء الـ Scratchpad |
| `Super + Alt + S` | نقل نافذة إلى الـ Scratchpad |

---

### 🔋 مراقبة البطارية

- تنبيه تلقائي عند انخفاض البطارية إلى **10%** عبر مؤقت systemd (كل 30 ثانية)
- يمكن تخصيص الاستجابة عبر نظام Hooks:

```bash
# أضف السكريبت هنا لتشغيل صوت أو أي إجراء مخصص
~/.config/onyx/hooks/battery-low
```

---

### 🪝 نظام Hooks

أضف سكريبتات مخصصة في `~/.config/onyx/hooks/` لتنفيذ إجراءات عند أحداث معينة:

| ملف الـ Hook | متى يُشغَّل |
|-------------|------------|
| `battery-low` | عند وصول البطارية لـ 10% |
| `theme-set` | عند تطبيق ثيم جديد |
| `font-set` | عند تغيير الخط |
| `post-update` | بعد تحديث النظام |

> ملفات نموذجية بامتداد `.sample` متاحة كنقطة بداية.

---

### 🔄 نظام المهاجرة التلقائية

التغييرات في الإعدادات بين الإصدارات تُطبَّق تلقائياً عبر مجلد `migrations/`.  
الحالة مُتتبَّعة في `~/.local/state/onyx/migrations/`.

---

### 🐛 أداة Debug

```bash
~/.config/hypr/scripts/debug.sh
```

تجمع معلومات النظام والسجلات والحزم المثبّتة. تدعم الرفع إلى `0x0.st` لمشاركة نتائج التشخيص.

---

### 📺 ملفات Waybar الديناميكية

مؤشرات حية في Waybar:

| السكريبت | يُظهر |
|---------|-------|
| `screen-recording.sh` | أيقونة 󰻂 أثناء التسجيل |
| `idle-indicator.sh` | أيقونة 󱫖 عند إيقاف القفل التلقائي |
| `notification-silencing.sh` | أيقونة 󰂛 في وضع عدم الإزعاج |
| `nightlight-indicator.sh` | أيقونة  عند تفعيل إضاءة الليل |

---

### ⚡ ملفات تعريف الطاقة

```bash
~/.config/hypr/scripts/powerprofiles-set.sh toggle    # تبديل: performance ↔ balanced
~/.config/hypr/scripts/powerprofiles-set.sh ac        # تفعيل performance عند الشحن
~/.config/hypr/scripts/powerprofiles-set.sh battery   # تفعيل balanced عند البطارية
```

---

## ⚙️ التثبيت

### تلقائي (موصى به)

```bash
git clone https://github.com/2b-3c/dotfiles
cd dotfiles
bash install.sh
```

> يقوم المثبّت بكل شيء تلقائياً: تثبيت الحزم، نسخ الإعدادات، ضبط الصلاحيات، تشغيل الخدمات، وتطبيق الثيم الافتراضي **void_purple**.  
> يُحفظ نسخ احتياطي من إعداداتك الحالية في `~/.config_backup_*` قبل كل تثبيت.

### يدوي

```bash
git clone https://github.com/2b-3c/dotfiles
cd dotfiles

# نسخ ملفات الإعداد
cp -r .config/* ~/.config/

# نسخ ملفات Home
cp .zshrc ~/
cp .gitconfig ~/

# إنشاء المجلدات المطلوبة
mkdir -p ~/Pictures/Screenshots ~/Pictures/Wallpapers ~/Videos

# منح صلاحيات التنفيذ للسكريبتات
find ~/.config/rofi/scripts      -type f -name "*.sh" -exec chmod +x {} +
find ~/.config/waybar/scripts    -type f               -exec chmod +x {} +
find ~/.config/swaync/scripts    -type f -name "*.sh" -exec chmod +x {} +
find ~/.config/hypr/scripts      -type f -name "*.sh" -exec chmod +x {} +
find ~/.config/fastfetch/scripts -type f -name "*.sh" -exec chmod +x {} +
```

---

## 📦 التبعيات

> **ملاحظة:** التثبيت التلقائي عبر `install.sh` يتولى تثبيت هذه الحزم كلها.

### الأساسية

```
hyprland hyprlock hypridle hyprsunset
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xorg-xwayland
grim slurp grimblast-git awww wl-clipboard imagemagick iw
hyprpolkitagent
```

### الصوت

```
pipewire pipewire-pulse pipewire-alsa wireplumber
pamixer playerctl libpulse wiremix python-gobject
```

### الشبكة

```
networkmanager network-manager-applet
bluez bluez-utils bluetui impala rfkill
```

### الواجهة

```
waybar python python-requests pacman-contrib upower jq curl
rofi-wayland rofi-emoji
swaync
brightnessctl libnotify
```

### التطبيقات

```
kitty firefox nautilus
btop fastfetch cava gum
tmux starship zsh lsd bat neovim yazi
fd ripgrep p7zip ffmpeg ffplay rsync
ffmpegthumbnailer perl-image-exiftool
satty gpu-screen-recorder v4l-utils v4l2loopback-dkms linux-headers
hyprpicker cliphist fzf zoxide
```

### الخطوط والأيقونات

```
ttf-firacode-nerd ttf-jetbrains-mono-nerd
noto-fonts noto-fonts-emoji
yaru-icon-theme bibata-cursor-theme
```

### SDDM

```
sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
```

> خط **Electroharmonix** المستخدم في شاشة القفل مضمّن في `sddm/silent/fonts/` — لا حاجة لتثبيته يدوياً.  
> خط **Red Hat** مضمّن أيضاً في ثيمات SDDM.

---

## ⌨️ اختصارات لوحة المفاتيح

> `$mod` = مفتاح Super (Windows)

### القوائم

| الاختصار | الوظيفة |
|----------|---------|
| `Super + Space` | القائمة الرئيسية |
| `Super + A` | مشغّل التطبيقات |
| `Super + R` | مشغّل الأوامر |
| `Super + C` | الحافظة النصية |
| `Super + Shift + C` | الحافظة المرئية |
| `Super + .` | منتقي الرموز التعبيرية |
| `Super + W` | محوّل النوافذ |
| `Super + O` | التحكم في الوسائط الحالية |
| `Super + I` | منتقي خلفية الشاشة |

### التطبيقات

| الاختصار | الوظيفة |
|----------|---------|
| `Super + T` | الطرفية (Kitty) |
| `Super + E` | مدير الملفات (Nautilus) |
| `Super + F` | المتصفح (Firefox) |
| `Super + N` | إظهار/إخفاء الإشعارات |

### لقطات الشاشة

| الاختصار | الوظيفة |
|----------|---------|
| `Print` | لقطة ذكية (نقر على نافذة أو رسم منطقة) |
| `Super + Print` | لقطة شاشة كاملة |
| `Ctrl + Super + Print` | لقطة نافذة محددة |
| `Super + Shift + S` | لقطة منطقة محددة إلى الحافظة فقط |

> تُحفظ اللقطات في `~/Pictures/Screenshots/` وتُنسخ إلى الحافظة. يظهر إشعار بزر **Edit** لفتح Satty للتعليق عليها.

### تسجيل الشاشة

| الاختصار | الوظيفة |
|----------|---------|
| `Super + Shift + R` | بدء/إيقاف تسجيل الشاشة |
| `Super + Shift + Alt + R` | بدء التسجيل مع صوت الحاسوب والميكروفون |

> تُحفظ التسجيلات في `~/Videos/`.

### الصوت

| الاختصار | الوظيفة |
|----------|---------|
| `XF86AudioRaiseVolume` | رفع الصوت |
| `XF86AudioLowerVolume` | خفض الصوت |
| `XF86AudioMute` | كتم الصوت |
| `XF86AudioMicMute` | كتم الميكروفون |
| `XF86AudioPlay/Pause` | تشغيل/إيقاف مؤقت |
| `XF86AudioNext/Prev` | التالي/السابق |
| `Super + XF86AudioMute` | تبديل جهاز الإخراج الصوتي |

### السطوع

| الاختصار | الوظيفة |
|----------|---------|
| `XF86MonBrightnessUp` | رفع السطوع |
| `XF86MonBrightnessDown` | خفض السطوع |

### الشاشة والتخطيط

| الاختصار | الوظيفة |
|----------|---------|
| `Super + F8` | تدوير مقياس الشاشة |
| `Super + Shift + F8` | تبديل نسبة عرض النافذة الواحدة |
| `Super + Shift + N` / `Super + F7` | تبديل إضاءة الليل |
| `Super + L` | تبديل تخطيط مساحات العمل (dwindle ↔ master) |
| `Super + Backspace` | تبديل شفافية النافذة |
| `Super + Shift + Backspace` | تبديل مسافات النوافذ |

### إدارة النوافذ

| الاختصار | الوظيفة |
|----------|---------|
| `Super + Q` | إغلاق النافذة |
| `Super + V` | تبديل النافذة العائمة |
| `Super + P` | تبديل الـ Pseudo-tiling |
| `Super + J` | تبديل الانقسام |
| `Super + F11` | ملء الشاشة |
| `Super + U` | إبراز النافذة (عائمة ومثبّتة) |
| `Super + Arrows` | تحريك التركيز |
| `Super + Shift + Arrows` | تبادل موضع النافذة |
| `Super + [-]` / `Super + [=]` | تغيير حجم النافذة أفقياً |
| `Super + Shift + [-]` / `Super + Shift + [=]` | تغيير حجم النافذة عمودياً |
| `Super + سحب الماوس` | تحريك النافذة |
| `Super + زر الماوس الأيمن` | تغيير حجم النافذة |
| `Alt + Tab` | التنقل للأمام بين النوافذ |
| `Alt + Shift + Tab` | التنقل للخلف بين النوافذ |

### مجموعات النوافذ (Tabbed)

| الاختصار | الوظيفة |
|----------|---------|
| `Super + G` | تبديل مجموعة النافذة |
| `Super + Alt + G` | نقل النافذة خارج المجموعة |
| `Super + Alt + Tab` | علامة التبويب التالية |
| `Super + Alt + Shift + Tab` | علامة التبويب السابقة |
| `Super + Ctrl + Left/Right` | التنقل بين علامات التبويب |
| `Super + Alt + Arrows` | نقل النافذة إلى مجموعة مجاورة |

### مساحات العمل

| الاختصار | الوظيفة |
|----------|---------|
| `Super + 1-0` | التنقل إلى مساحة العمل 1-10 |
| `Super + Shift + 1-0` | نقل النافذة إلى مساحة عمل |
| `Super + Shift + Alt + 1-0` | نقل النافذة بصمت إلى مساحة عمل |
| `Super + Tab` | مساحة العمل التالية |
| `Super + Shift + Tab` | مساحة العمل السابقة |
| `Super + Ctrl + Tab` | مساحة العمل الأخيرة |
| `Super + Scroll` | التنقل بين مساحات العمل بعجلة الماوس |
| `Super + Shift + Alt + Arrows` | نقل مساحة عمل إلى شاشة أخرى |
| `Super + S` | إظهار/إخفاء الـ Scratchpad |
| `Super + Alt + S` | نقل النافذة إلى الـ Scratchpad |

### النظام

| الاختصار | الوظيفة |
|----------|---------|
| `Super + Shift + X` | قفل الشاشة |
| `Super + Shift + B` | إعادة تشغيل Waybar |
| `Super + Shift + M` | الخروج من Hyprland |

---

## 📁 هيكل الملفات

```
~/.config/
├── hypr/
│   ├── hyprland.conf          ← الملف الرئيسي (يستدعي بقية الملفات)
│   ├── hyprlock.conf          ← إعدادات شاشة القفل
│   ├── hypridle.conf          ← إعدادات مؤقت الخمول
│   ├── autostart.conf         ← التطبيقات التي تعمل عند البدء
│   ├── bindings.conf          ← جميع اختصارات لوحة المفاتيح
│   ├── colors.conf            ← الألوان (تُدار بواسطة theme-set.sh)
│   ├── env.conf               ← متغيرات البيئة
│   ├── input.conf             ← إعدادات لوحة المفاتيح والفأرة
│   ├── looknfeel.conf         ← الشكل والمظهر (فجوات، ضبابية، حركات)
│   ├── monitors.conf          ← إعدادات الشاشات
│   ├── windowrules.conf       ← قواعد النوافذ
│   ├── xdph.conf              ← إعدادات مشاركة الشاشة
│   ├── hyprlock/assets/       ← صور شاشة القفل
│   └── scripts/               ← جميع السكريبتات
│       ├── audio-switch.sh
│       ├── battery-monitor.sh
│       ├── battery-status.sh
│       ├── debug.sh
│       ├── font-set.sh
│       ├── idle-toggle.sh
│       ├── migrate.sh
│       ├── monitor-scaling-cycle.sh
│       ├── nightlight-toggle.sh
│       ├── powerprofiles-set.sh
│       ├── restore_wallpaper.sh
│       ├── screenrecord.sh
│       ├── screenshot.sh
│       ├── theme-set.sh
│       ├── theme-select.sh
│       └── video-wallpaper.sh
│
├── themes/
│   ├── dark/
│   │   ├── void_purple/colors.toml
│   │   └── deep_cyan/colors.toml
│   ├── light/
│   │   ├── sakura_pink/colors.toml
│   │   ├── lavender/colors.toml
│   │   ├── sky_blue/colors.toml
│   │   └── inferno/colors.toml
│   └── templates/             ← قوالب توليد ملفات الثيمات
│
├── waybar/
│   ├── config.jsonc
│   ├── style.css
│   ├── theme.css
│   └── scripts/
│       ├── screen-recording.sh
│       ├── idle-indicator.sh
│       ├── notification-silencing.sh
│       └── nightlight-indicator.sh
│
├── rofi/
│   ├── app-launcher.rasi
│   ├── bluetooth.rasi
│   ├── clipboard.rasi
│   ├── config.rasi
│   ├── emoji.rasi
│   ├── image-clipboard.rasi
│   ├── launcher-menu.rasi
│   ├── logout-menu.rasi
│   ├── nowplaying/
│   ├── run-launcher.rasi
│   ├── wallpaper-select.rasi
│   ├── wifi.rasi
│   ├── wifi-bluetooth-menu.rasi
│   ├── window-switcher.rasi
│   └── scripts/
│       ├── launcher-menu.sh
│       ├── network-menu.sh
│       ├── nowplaying.sh
│       ├── wallpaper-select.sh
│       ├── theme-select.sh
│       ├── sddm-theme.sh
│       ├── window-switcher.sh
│       ├── clipboard-images.sh
│       ├── pkg-install
│       ├── pkg-remove
│       └── video-wallpaper-select.sh
│
├── swaync/
│   ├── config.json
│   ├── style.css
│   ├── theme.css
│   └── scripts/
│
├── kitty/
│   ├── kitty.conf
│   └── theme.conf
│
├── btop/
│   ├── btop.conf
│   └── themes/theme.theme
│
├── cava/config
│
├── fastfetch/
│   ├── config.jsonc
│   ├── onyx.txt              ← ASCII art مخصص
│   └── scripts/
│       ├── theme-current.sh
│       ├── version-branch.sh
│       ├── version-channel.sh
│       ├── version-pkgs.sh
│       └── version.sh
│
├── yazi/
│   ├── yazi.toml
│   ├── keymap.toml
│   └── theme.toml
│
├── starship/theme.toml
├── ctpv/config
├── lsd/config.yaml
├── tmux/tmux.conf
├── fontconfig/fonts.conf
├── gtk-3.0/ (gtk.css · settings.ini)
└── gtk-4.0/ (gtk.css · settings.ini)

~/
├── .zshrc                    ← إعدادات Zsh مع تاريخ، aliases، وplugins
├── .gitconfig
├── Videos/                   ← مجلد حفظ تسجيلات الشاشة
└── Pictures/
    ├── Screenshots/
    └── Wallpapers/

~/dotfiles/
├── install.sh
├── version                   ← الإصدار الحالي (1.1.0)
├── install/
│   ├── helpers/
│   ├── preflight/
│   ├── packaging/
│   ├── config/
│   └── post-install/
├── migrations/               ← ترقية الإعدادات بين الإصدارات
└── sddm/
    ├── silent/               ← ثيم Silent
    │   ├── Main.qml
    │   ├── components/
    │   ├── configs/sakura_pink.conf
    │   ├── fonts/redhat*/
    │   └── icons/
    └── astronaut/            ← ثيم Astronaut
```

---

## ⚠️ الإعداد اليدوي بعد التثبيت

| الملف | ما يجب تعديله |
|-------|--------------|
| `~/.config/hypr/monitors.conf` | اسم الشاشة، الدقة، ومعدل التحديث |
| `~/.config/hypr/input.conf` | تخطيط لوحة المفاتيح وإعدادات الفأرة |
| `~/.config/hypr/hyprland.conf` | الطرفية الافتراضية، المتصفح، أو مدير الملفات |

---

## 📝 ملاحظات

- الإصدار الحالي: **1.1.0**
- الثيم الافتراضي: **void_purple** — يُطبَّق تلقائياً عند التثبيت
- إعداد Hyprland مقسّم إلى ملفات فرعية — عدّل كل قسم في ملفه المخصص
- نسخ احتياطي من الإعداد يُحفظ في `~/.config_backup_*` عند كل تثبيت
- خلفية الشاشة تُستعاد تلقائياً عند كل إقلاع عبر `restore_wallpaper.sh`
- المؤشر المستخدم: **Bibata-Modern-Classic** بحجم 16px (Hyprland) و 24px (HyprCursor)
- إضافات Zsh (autosuggestions, syntax-highlighting, history-substring-search) مضمّنة في `~/.config/zsh/`
- المتغيرات البيئية لـ Wayland مُعدَّة مسبقاً في `env.conf` لضمان التوافق مع GTK وQT وSDL وElectron
- ملفات XWayland تعمل بمقياس `force_zero_scaling = true` لتجنب التشويه
- التحديثات والمهاجرات التلقائية مُتتبَّعة في `~/.local/state/onyx/migrations/`

---

## 🤝 المساهمة

الاقتراحات والإصلاحات مرحّب بها — افتح **Issue** أو **Pull Request**.

---

*ONYX Dotfiles — v1.1.0*
