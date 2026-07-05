<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminAchievementController extends Controller
{
public function index()
{
    $leaderboard = DB::table('user_points')
        ->join('users', 'users.id', '=', 'user_points.user_id')
        ->select(
            'users.name',
            'user_points.user_id',
            DB::raw('SUM(user_points.points) as total_points')
        )
        ->groupBy('users.name', 'user_points.user_id')
        ->orderByDesc('total_points')
        ->get();

    $streaks = DB::table('user_streaks')
        ->join('users', 'users.id', '=', 'user_streaks.user_id')
        ->select(
            'users.name',
            'user_streaks.current_streak',
            'user_streaks.best_streak'
        )
        ->orderByDesc('current_streak')
        ->get();

    return response()->json([
        'badges' => $streaks,
        'challenges' => [],
        'userBadges' => $leaderboard,

        'totalBadges' => $streaks->count(),
        'totalChallenges' => 0,
        'earnedBadges' => $streaks->where('current_streak', '>', 0)->count(),
        'totalUsers' => $leaderboard->count(),
    ]);
}

    public function storeBadge(Request $request)
    {
        $request->validate([
            'name'            => 'required|string',
            'category'        => 'required|string',
            'condition_type'  => 'required|string',
            'condition_value' => 'required|integer',
        ]);

        $id = DB::table('badges')->insertGetId([
            'name'            => $request->name,
            'category'        => $request->category,
            'icon'            => $request->icon,
            'description'     => $request->description,
            'condition_type'  => $request->condition_type,
            'condition_value' => $request->condition_value,
            'created_at'      => now(),
            'updated_at'      => now(),
        ]);

        return response()->json(['success' => true, 'id' => $id]);
    }

    public function updateBadge(Request $request, $id)
    {
        DB::table('badges')->where('id', $id)->update([
            'name'            => $request->name,
            'category'        => $request->category,
            'icon'            => $request->icon,
            'description'     => $request->description,
            'condition_type'  => $request->condition_type,
            'condition_value' => $request->condition_value,
            'updated_at'      => now(),
        ]);

        return response()->json(['success' => true]);
    }

    public function destroyBadge($id)
    {
        DB::table('badges')->where('id', $id)->delete();
        return response()->json(['success' => true]);
    }

    public function storeChallenge(Request $request)
    {
        $request->validate([
            'name'       => 'required|string',
            'start_date' => 'required|date',
            'end_date'   => 'required|date',
        ]);

        $id = DB::table('challenges')->insertGetId([
            'name'          => $request->name,
            'description'   => $request->description,
            'duration_days' => $request->duration_days ?? 7,
            'status'        => $request->status ?? 'active',
            'start_date'    => $request->start_date,
            'end_date'      => $request->end_date,
            'created_at'    => now(),
            'updated_at'    => now(),
        ]);

        return response()->json(['success' => true, 'id' => $id]);
    }

    public function updateChallenge(Request $request, $id)
    {
        DB::table('challenges')->where('id', $id)->update([
            'name'          => $request->name,
            'description'   => $request->description,
            'duration_days' => $request->duration_days,
            'status'        => $request->status,
            'start_date'    => $request->start_date,
            'end_date'      => $request->end_date,
            'updated_at'    => now(),
        ]);

        return response()->json(['success' => true]);
    }

    public function destroyChallenge($id)
    {
        DB::table('challenges')->where('id', $id)->delete();
        return response()->json(['success' => true]);
    }
}