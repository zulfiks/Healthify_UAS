<?php

namespace App\Services;

class ReminderPromptService
{
    public function build(array $data)
    {
        $user = $data['user'];
        $screening = $data['screening'];
        $weeklyPlan = $data['weekly_plan'];
        $weeklyReport = $data['weekly_report'];

        return "

Kamu adalah AI Smart Reminder milik aplikasi Healthify.

Tugasmu adalah membuat reminder harian yang PERSONAL sesuai kondisi pengguna.

==========================
DATA PENGGUNA
==========================

Nama :
{$user->name}

Usia :
{$screening?->age}

Jenis Kelamin :
{$screening?->gender}

BMI :
{$screening?->imt_value}

Kategori BMI :
{$screening?->imt_classification}

Risk Level :
{$screening?->risk_level}

Aktivitas :
{$screening?->activity_level}

Durasi Tidur :
{$screening?->sleep_duration}

Riwayat Penyakit :
{$screening?->conditions}

==========================
FOOD HISTORY
==========================

{$data['food_history']}

Rata-rata kalori :

{$data['avg_calories']} kcal

==========================
ACTIVITY
==========================

{$data['activity_history']}

Kalori terbakar :

{$data['burned']} kcal

==========================
TARGET USER
==========================

Fokus :

".($weeklyPlan?->focus ?? "-")."

Target Aktivitas :

".($weeklyPlan?->activity_target ?? "-")."

Habit :

".($weeklyPlan?->small_habit ?? "-")."

Menu :

".($weeklyPlan?->menu_recommendation ?? "-")."

==========================
LAPORAN MINGGUAN
==========================

".($weeklyReport?->recommendation ?? "-")."

==========================

Buat TEPAT 5 reminder.

Setiap reminder harus memiliki:

- time
- title
- message
- type

type hanya boleh:

meal
water
exercise
sleep
motivation

Jawab HANYA JSON.

Contoh:

[
{
\"time\":\"07:00\",
\"title\":\"Sarapan\",
\"message\":\"Sarapan tinggi protein agar kenyang lebih lama.\",
\"type\":\"meal\"
},
{
\"time\":\"10:00\",
\"title\":\"Air Putih\",
\"message\":\"Minum 500 ml air putih.\",
\"type\":\"water\"
},
{
\"time\":\"17:30\",
\"title\":\"Olahraga\",
\"message\":\"Jalan kaki santai 20 menit.\",
\"type\":\"exercise\"
},
{
\"time\":\"21:00\",
\"title\":\"Tidur\",
\"message\":\"Tidur lebih awal malam ini.\",
\"type\":\"sleep\"
},
{
\"time\":\"15:00\",
\"title\":\"Semangat\",
\"message\":\"Ingat tujuanmu hidup lebih sehat.\",
\"type\":\"motivation\"
}

]

";
    }
}