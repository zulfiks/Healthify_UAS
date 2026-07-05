<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class AdminAgentLogController extends Controller
{
    public function index()
    {
        $logs = DB::table('activity_logs')
            ->leftJoin('users','users.id','=','activity_logs.user_id')
            ->select(
                'activity_logs.*',
                'users.name'
            )
            ->latest()
            ->get();

        $logs = $logs->map(function ($log) {

    return [
        'id' => $log->id,

        'user' => [
            'name' => $log->name
        ],

        'agent_name' => 'Activity Agent',

        'intent' => $log->activity_type,

        'action' =>
            $log->duration_minutes . ' menit | ' .
            $log->intensity . ' | ' .
            $log->calories_burned . ' kkal',

        'status' => 'success',

        'created_at' => now(),
    ];
});
    

        return response()->json($logs);
    }
}