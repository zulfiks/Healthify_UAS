<?php

namespace App\Services;

class BehaviorCoachingService
{
    protected $groq;

    public function __construct(
        GroqService $groq
    ) {
        $this->groq = $groq;
    }

    public function generate(
        $screening
    ) {

        $prompt = "

Kamu adalah AI Health Coach.

Data pengguna:

BMI : {$screening->imt_value}

Risk level :
{$screening->risk_level}

Aktivitas fisik :
{$screening->activity_level}

Minuman manis :
{$screening->sweet_drink}

Fast food :
{$screening->fast_food}

Tidur :
{$screening->sleep_duration}

Kondisi :
{$screening->conditions}

Setiap bagian WAJIB terisi.

Jangan berhenti sebelum seluruh bagian selesai.

Berikan 2-3 kalimat untuk setiap bagian.

Pastikan output memiliki tepat 5 bagian:

Daily Motivation:
...

Habit Evaluation:
...

Overeating Strategy:
...

Mindful Eating:
...

Craving Support:
...

Jangan menambahkan penjelasan lain.

";

        return $this->groq->ask($prompt);

    }
}