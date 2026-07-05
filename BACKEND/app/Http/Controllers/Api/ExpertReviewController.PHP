<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\ExpertReview;
use App\Models\User;
use App\Models\Screening;
use App\Models\FoodLog;
use App\Models\WeightLossPlan;

class ExpertReviewController extends Controller
{

    /*
    ======================================
    READ
    Semua user untuk halaman Expert
    ======================================
    */

    public function index()
    {
        $users = User::select('id','name','email')
            ->with('expertReview')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $users
        ]);
    }

    /*
    ======================================
    READ DETAIL USER
    ======================================
    */

    public function show($userId)
    {

        $user = User::findOrFail($userId);

        $screening = Screening::where('user_id',$userId)
            ->latest()
            ->first();

        $foodLogs = FoodLog::where('user_id',$userId)
            ->latest()
            ->take(20)
            ->get();

        $weightPlan = WeightLossPlan::where('user_id',$userId)
            ->first();

        $review = ExpertReview::where('user_id',$userId)
            ->latest()
            ->first();

        return response()->json([

            'success'=>true,

            'user'=>$user,

            'screening'=>$screening,

            'food_logs'=>$foodLogs,

            'weight_loss_plan'=>$weightPlan,

            'expert_review'=>$review

        ]);

    }

    /*
    ======================================
    CREATE
    ======================================
    */

    public function store(Request $request)
    {

        $request->validate([

            'user_id'=>'required',

            'expert_name'=>'required',

            'expert_note'=>'required',

            'meal_plan'=>'required',

            'status'=>'required'

        ]);

        $weightPlan = WeightLossPlan::where(
            'user_id',
            $request->user_id
        )->first();

        $review = ExpertReview::create([

            'user_id'=>$request->user_id,

            'expert_name'=>$request->expert_name,

            'ai_recommendation'=>$weightPlan?->plan_text,

            'expert_note'=>$request->expert_note,

            'meal_plan'=>$request->meal_plan,

            'status'=>$request->status,

            'reviewed_at'=>now()

        ]);

        return response()->json([

            'success'=>true,

            'message'=>'Review berhasil dibuat.',

            'data'=>$review

        ]);

    }

    /*
    ======================================
    UPDATE
    ======================================
    */

    public function update(Request $request,$id)
    {

        $review = ExpertReview::findOrFail($id);

        $review->update([

            'expert_name'=>$request->expert_name,

            'expert_note'=>$request->expert_note,

            'meal_plan'=>$request->meal_plan,

            'status'=>$request->status,

            'reviewed_at'=>now()

        ]);

        return response()->json([

            'success'=>true,

            'message'=>'Review berhasil diperbarui.',

            'data'=>$review

        ]);

    }

    /*
    ======================================
    DELETE
    ======================================
    */

    public function destroy($id)
    {

        $review = ExpertReview::findOrFail($id);

        $review->delete();

        return response()->json([

            'success'=>true,

            'message'=>'Review berhasil dihapus.'

        ]);

    }
    public function userReview($userId)
{
    $review = ExpertReview::where(
        'user_id',
        $userId
    )
    ->latest()
    ->first();

    if (!$review) {

        return response()->json([

            'success' => false,

            'message' => 'Belum ada review dari ahli gizi.'

        ],404);

    }

    return response()->json([

        'success' => true,

        'data' => $review

    ]);

}

}