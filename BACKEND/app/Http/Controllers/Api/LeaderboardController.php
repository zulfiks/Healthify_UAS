<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\UserPoint;
use Illuminate\Support\Facades\DB;

class LeaderboardController extends Controller
{
    public function getTopLeaderboard()
    {
        try {
         $limit = request()->get('limit', 5);   
            // Ambil data user beserta total kalori dari food_logs
            // Pastikan kolom 'profile_picture' ikut diseleksi
$query = UserPoint::join(
    'users',
    'users.id',
    '=',
    'user_points.user_id'
)
->select(
    'users.id',
    'users.name',
    'users.profile_picture',
    DB::raw('SUM(user_points.points) as skor')
)
->groupBy(
    'users.id',
    'users.name',
    'users.profile_picture'
)
->orderByDesc('skor');
if ($limit != 'all') {
    $query->take((int)$limit);
}
$leaderboard = $query
    ->get()
    ->map(function ($user) {

        return [

            'id'=>$user->id,

            'name'=>$user->name,

            'skor'=>$user->skor,

            'profile_picture'=>$user->profile_picture
                ? asset('storage/'.$user->profile_picture)
                : null,

        ];

    });

            return response()->json([
                'success' => true,
                'leaderboard' => $leaderboard
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data leaderboard: ' . $e->getMessage()
            ], 500);
        }
    }
}