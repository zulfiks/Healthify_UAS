<?php

namespace App\Services;

class CravingSupportService
{
    protected $groq;

    public function __construct(
        GroqService $groq
    ) {
        $this->groq = $groq;
    }

    public function generate(
        $type,
        $screening
    ) {

        $prompt = "

Kamu adalah AI health coach.

Profil pengguna:

BMI: {$screening->imt_value}

Risk level:
{$screening->risk_level}

Aktivitas fisik:
{$screening->activity_level}

Fast food:
{$screening->fast_food}

Minuman manis:
{$screening->sweet_drink}

Durasi tidur:
{$screening->sleep_duration}

Jenis craving:

$type

Berikan:

1. Delay Technique
2. Healthy Snack
3. Short Motivation
4. Distraction Activity

Jawab PERSIS dengan format:

Delay Technique:
...

Healthy Snack:
...

Short Motivation:
...

Distraction Activity:
...

Gunakan bahasa Indonesia.

";

        return $this->groq->ask(
            $prompt
        );
    }
}