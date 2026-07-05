<?php

namespace App\Services;

class MedicalSafetyService
{
    protected $groq;

    public function __construct(
        GroqService $groq
    ) {
        $this->groq = $groq;
    }

    public function analyze($screening)
    {

        $conditions = $screening->conditions;

        $prompt = "

Kamu adalah AI Medical Safety Assistant.

Profil pengguna:

Usia:
{$screening->age}

Jenis kelamin:
{$screening->gender}

BMI:
{$screening->imt_value}

Kategori BMI:
{$screening->imt_classification}

Risk level:
{$screening->risk_level}

Aktivitas fisik:
{$screening->activity_level}

Durasi tidur:
{$screening->sleep_duration}

Riwayat penyakit:
{$conditions}

Tentukan apakah pengguna aman menjalankan program penurunan berat badan.

Berikan:

1. Safety Status
2. Risk Factors
3. Exercise Advice
4. Medical Recommendation

Jawab PERSIS dengan format:

Safety Status:
...

Risk Factors:
...

Exercise Advice:
...

Medical Recommendation:
...

Gunakan bahasa Indonesia.

";

        return $this->groq->ask(
            $prompt
        );
    }
}