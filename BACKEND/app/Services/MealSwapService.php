<?php

namespace App\Services;

use App\Models\Screening;

class MealSwapService
{
    protected $groq;

    public function __construct(
        GroqService $groq
    ) {
        $this->groq = $groq;
    }

    public function recommend(
        $food,
        $screening
    ) {

        $prompt = "

Kamu adalah AI Nutrition Coach.

Profil pengguna:

Umur: {$screening->age}
Gender: {$screening->gender}
Berat badan: {$screening->weight} kg
Tinggi badan: {$screening->height} cm
BMI: {$screening->imt_value}
Risk level: {$screening->risk_level}

Aktivitas fisik:
{$screening->activity_level}

Konsumsi minuman manis:
{$screening->sweet_drink}

Fast food:
{$screening->fast_food}

Durasi tidur:
{$screening->sleep_duration}

Kondisi kesehatan:
{$screening->conditions}

Makanan yang dikonsumsi pengguna:

Nama:
{$food['food_name']}

Kalori:
{$food['calories']} kcal

Protein:
{$food['protein']} gram

Karbohidrat:
{$food['carbs']} gram

Lemak:
{$food['fat']} gram

Porsi:
{$food['serving_size']}

Analisis nutrisi:

{$food['nutrition_analysis']['reason']}

Risk:
{$food['nutrition_analysis']['risk']}

Balas HANYA dalam format JSON valid.

Format:


{
    \"current_food\": \"\",
    \"healthy_alternative\": \"\",
    \"reason\": \"\",
    \"extra_tip\": \"\"
}


Jangan gunakan markdown.
Jangan gunakan tanda ```json.
Jangan berikan penjelasan di luar JSON.

Alternatif harus berupa makanan Indonesia yang lebih sehat sesuai kondisi pengguna.



";

        $response = $this->groq->ask($prompt);

$response = trim($response);

$response = str_replace(
    ['```json', '```'],
    '',
    $response
);

$data = json_decode($response, true);

if (!is_array($data)) {

    return [
        "current_food" => $food['food_name'],
        "healthy_alternative" => null,
        "reason" => "AI tidak dapat memberikan rekomendasi.",
        "extra_tip" => ""
    ];

}

return $data;
    }
}
