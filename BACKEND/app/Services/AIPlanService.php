<?php

namespace App\Services;

class AIPlanService
{
    protected $groq;

    public function __construct(GroqService $groq)
    {
        $this->groq = $groq;
    }

    public function generatePlan(
    $screening,
    $topFood,
    $goal,
    $avgCalories,
    $previousWeight
)
    {

        $bmi = $screening->imt_value;

        if ($bmi < 18.5) {
            $category = "Underweight";
        }
        elseif ($bmi < 25) {
            $category = "Normal";
        }
        elseif ($bmi < 30) {
            $category = "Overweight";
        }
        else {
            $category = "Obesitas";
        }
        $prompt = "
        Kamu adalah AI Health Coach.

        Profil pengguna:

        Umur: {$screening->age}
        Gender: {$screening->gender}
        Berat badan: {$screening->weight} kg
        Berat sebelumnya: {$previousWeight} kg
        Tinggi badan: {$screening->height} cm
        BMI: {$screening->imt_value}
        Risk level: {$screening->risk_level}
        Tujuan: {$goal}
        Kategori BMI: {$category}
        Aktivitas fisik:
{$screening->activity_level}

Konsumsi minuman manis:
{$screening->sweet_drink}

Makanan cepat saji:
{$screening->fast_food}

Durasi tidur:
{$screening->sleep_duration}

Kondisi kesehatan:
{$screening->conditions}

        Makanan yang sering dikonsumsi:
        {$topFood}
        Rata-rata kalori harian:
        {$avgCalories} kcal

        Instruksi:

Analisis seluruh data pengguna terlebih dahulu.

Gunakan BMI, aktivitas, pola makan, konsumsi gula, fast food, tidur, kondisi kesehatan, makanan yang sering dikonsumsi, dan rata-rata kalori sebagai dasar rekomendasi.

WAJIB mengembalikan jawaban dengan format PERSIS seperti berikut.

Focus:
(satu kalimat)

Activity Target:
(satu kalimat)

Small Habit:
(satu kalimat)

Menu Recommendation:
(satu kalimat)

Aturan:
- Jangan menambahkan kalimat pembuka.
- Jangan menambahkan kalimat penutup.
- Jangan menggunakan bullet atau nomor.
- Jangan mengubah nama heading.
- Pastikan isi setiap bagian sesuai data pengguna.
- Jika BMI normal, fokus mempertahankan berat badan.
- Jika BMI underweight, fokus menaikkan berat badan.
- Jika BMI overweight atau obesitas, fokus penurunan berat badan bertahap.
        ";

        return $this->groq->ask($prompt);
    }
}