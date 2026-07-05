<?php

namespace App\Http\Controllers\Api;

use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\RiskAlert;

class RiskAlertController extends Controller
{
public function index()
{
    $alerts = DB::table('screenings')
        ->leftJoin('users', 'users.id', '=', 'screenings.user_id')
        ->select(
            'screenings.id',
            'users.name',
            'screenings.risk_level',
            'screenings.imt_classification',
            'screenings.conditions'
        )
        ->latest('screenings.id')
        ->get();

    $data = $alerts->map(function ($item) {

        return [
            'id' => $item->id,

            'user' => [
                'name' => $item->name
            ],

            'title' => $item->imt_classification,

            'severity' => $item->risk_level,

            'status' => 'Aktif',

            'conditions' => $item->conditions
        ];
    });

    return response()->json([
        'success' => true,
        'data' => $data
    ]);
}

    public function statistics()
{
    return response()->json([

        'active_alerts' =>
            DB::table('screenings')->count(),

        'high_risk' =>
            DB::table('screenings')
                ->where('risk_level','High')
                ->count(),

        'medical_flags' =>
            DB::table('screenings')
                ->whereNotNull('conditions')
                ->count(),

        'need_review' =>
            DB::table('screenings')
                ->where('risk_level','Very High')
                ->count(),

    ]);
}
}