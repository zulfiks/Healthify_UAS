<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Screening;

class UserController extends Controller
{
    public function index()
    {
        $users = User::all();

        $result = $users->map(function ($user) {

            $latestScreening = Screening::where(
                'user_id',
                $user->id
            )->latest()->first();

            return [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'created_at' => $user->created_at,
                'target_weight' => $user->target_weight,

                'gender' => $latestScreening?->gender,
                'age' => $latestScreening?->age,
                'weight' => $latestScreening?->weight,
                'imt_value' => $latestScreening?->imt_value,
                'bmi_category' => $latestScreening?->imt_classification,
                'risk_level' => $latestScreening?->risk_level,
            ];
        });

        return response()->json($result);
    }
}