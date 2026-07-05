<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class AdminCoachingController extends Controller
{
    public function index()
    {
        // Template coaching
        $templates = DB::table('coaching_templates')
            ->orderBy('id', 'desc')
            ->get();

        // Riwayat coaching user
        $histories = DB::table('behavior_coaching_history as b')
            ->leftJoin('users as u', 'u.id', '=', 'b.user_id')
            ->select(
                'b.*',
                'u.name as user_name'
            )
            ->orderBy('b.id', 'desc')
            ->get();

        return response()->json([
            'success' => true,

            // Card
            'totalMessages' => $histories->count(),
            'aiInteractions' => $histories->count(),
            'totalTemplates' => $templates->count(),
            'activeTemplates' => $templates->count(),

            // Tabel
            'templates' => $templates,
            'histories' => $histories,
        ]);
    }
}