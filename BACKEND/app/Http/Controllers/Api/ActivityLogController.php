<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActivityLog;
use App\Models\User;
use App\Models\ActivityProgram;

class ActivityLogController extends Controller
{
public function store(Request $request)
{
    $request->validate([
        'user_id' => 'required|exists:users,id',
        'activity_type' => 'required',
        'duration_minutes' => 'required|integer',
        'intensity' => 'required'
    ]);

    $met = 0;


// Jalan kaki
if ($request->activity_type == "Jalan kaki") {

    if ($request->intensity == "ringan")
        $met = 2.8;
    elseif ($request->intensity == "sedang")
        $met = 3.5;
    else
        $met = 4.8;
}

// Jogging
elseif ($request->activity_type == "Jogging") {

    if ($request->intensity == "ringan")
        $met = 7.0;
    elseif ($request->intensity == "sedang")
        $met = 8.3;
    else
        $met = 9.8;
}

// Bersepeda
elseif ($request->activity_type == "Bersepeda") {

    if ($request->intensity == "ringan")
        $met = 4.0;
    elseif ($request->intensity == "sedang")
        $met = 6.8;
    else
        $met = 10.0;
}

// Renang
elseif ($request->activity_type == "Renang") {

    if ($request->intensity == "ringan")
        $met = 6.0;
    elseif ($request->intensity == "sedang")
        $met = 8.3;
    else
        $met = 10.0;
}

// Badminton
elseif ($request->activity_type == "Badminton") {

    if ($request->intensity == "ringan")
        $met = 4.5;
    elseif ($request->intensity == "sedang")
        $met = 5.5;
    else
        $met = 7.0;
}
if ($met == 0) {
    $met = 4;
}
$user = User::find($request->user_id);

$weight = $user->weight ?? 60;
$hours = $request->duration_minutes / 60;

$calories = round(
    $met * $weight * $hours
);

    $activity = ActivityLog::create([
        'user_id' => $request->user_id,
        'activity_type' => $request->activity_type,
        'duration_minutes' => $request->duration_minutes,
        'intensity' => $request->intensity,
        'calories_burned' => $calories
    ]);
$program = ActivityProgram::firstOrCreate(
    [
        'user_id' => $request->user_id
    ],
    [
        'current_week' => 1,
        'completed_sessions' => 0
    ]
);

// tambah jumlah aktivitas selesai
$program->completed_sessions++;

// setiap 3 aktivitas naik minggu
if (
    $program->completed_sessions >= 3 &&
    $program->current_week < 4
) {

    $program->current_week++;

    $program->completed_sessions = 0;

}

$program->save();
    return response()->json([
        'message' => 'success',
        'data' => $activity
    ]);
}
public function history($user_id)
{
    $activities = ActivityLog::where('user_id',$user_id)
                    ->latest()
                    ->get();

    return response()->json($activities);
}
public function todayBurned($user_id)
{
    $total = ActivityLog::where('user_id',$user_id)
                ->sum('calories_burned');

    return response()->json([
        'today_burned'=>$total
    ]);
}
}