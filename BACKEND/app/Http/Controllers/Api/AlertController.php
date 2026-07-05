<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FoodLog;
use App\Models\Screening;

class AlertController extends Controller
{
    public function obesityRisk($user_id)
    {
        $screening = Screening::where('user_id',$user_id)
            ->latest()
            ->first();
        $sweetCount = FoodLog::where('user_id', $user_id)
            ->whereDate(
                'created_at',
                '>=',
                now()->subDays(5)
            )
            ->whereHas('food', function ($query) {

                $query->where('name', 'like', '%es teh%')
                    ->orWhere('name', 'like', '%kopi susu%')
                    ->orWhere('name', 'like', '%minuman manis%');

            })
            ->count();

            if (!$screening) {

                $message = "Belum ada data screening.";

            }
            else if ($screening->imt_classification == "Obesity II") {

                $message =
                    "BMI terakhirmu menunjukkan Obesity II. Risiko obesitas sangat tinggi. Disarankan mengurangi makanan tinggi gula dan lemak serta meningkatkan aktivitas fisik.";

            }
            else if ($screening->imt_classification == "Obesity I") {

                $message =
                    "BMI terakhirmu menunjukkan Obesity I. Kurangi makanan ultra processed dan lakukan olahraga rutin.";

            }
            else if ($screening->imt_classification == "Overweight") {

                $message =
                    "Berat badanmu berada pada kategori Overweight. Jaga pola makan dan aktivitas fisik.";

            }
            else if ($screening->imt_classification == "Normal") {

                $message =
                    "BMI berada pada kategori normal. Pertahankan gaya hidup sehat.";

            }
            else {

                $message =
                    "Berat badanmu berada di bawah normal. Pastikan kebutuhan kalori dan protein tercukupi.";

            }

        

        if ($sweetCount >= 4) {

            $message =
                "Dalam 5 hari terakhir, kamu mengonsumsi minuman manis sebanyak $sweetCount kali. Coba ganti dengan air putih selama 2 hari.";

        }

        return response()->json([
            'success' => true,
            'alert_message' => $message
        ]);
    }
}