<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\FoodController;
use App\Http\Controllers\Api\FoodLogController;
use App\Http\Controllers\Api\ScreeningController;;
use App\Http\Controllers\Api\LeaderboardController;
use App\Http\Controllers\Api\AlertController;
use App\Http\Controllers\Api\CoachingController;
use App\Http\Controllers\Api\WeeklyReportController;
use App\Http\Controllers\Api\WeeklyPlanController;
use App\Http\Controllers\Api\TestGeminiController;
use App\Http\Controllers\Api\TestDeepSeekController;
use App\Http\Controllers\Api\TestGroqController;
use App\Http\Controllers\Api\CravingController;
use App\Http\Controllers\Api\StreakController;
use App\Http\Controllers\Api\MealSwapController;
use App\Http\Controllers\Api\ActivityRecommendationController;
use App\Http\Controllers\Api\ActivityLogController;
use App\Http\Controllers\Api\EducationController;
use App\Http\Controllers\Api\WeightLossPlanController;
use App\Http\Controllers\Api\MedicalSafetyController;
use App\Http\Controllers\Api\SmartReminderController;
use App\Http\Controllers\Api\FoodParsingController;
use App\Http\Controllers\Api\ExpertReviewController;
use App\Http\Controllers\Api\ExpertDashboardController;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\Api\AdminAuthController;
use App\Http\Controllers\Api\AdminDashboardController;
use App\Http\Controllers\Api\AdminAIController;
use App\Http\Controllers\Api\AdminAchievementController;
use App\Http\Controllers\Api\AdminCoachingController;
use App\Http\Controllers\Api\AdminSettingsController;
use App\Http\Controllers\Api\AdminAISettingController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\RiskAlertController;
use App\Http\Controllers\Api\AdminWeeklyPlanController;
use App\Http\Controllers\Api\AdminFoodController;
use App\Http\Controllers\Api\AdminFoodStatisticsController;
use App\Http\Controllers\Api\AdminEducationController;
use App\Http\Controllers\Api\AdminAgentLogController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/foods', [FoodController::class, 'index']);
Route::post('/food-logs', [FoodLogController::class, 'store']);
Route::get('/leaderboard/top', [FoodLogController::class, 'leaderboard']);
Route::get('/food-logs/today/{user_id}', [FoodLogController::class, 'today']);
Route::post('/screening', [ScreeningController::class, 'store']);
Route::post('/user/{id}/upload-profile-picture', [AuthController::class, 'updateProfilePicture']);
Route::put('/user/{id}', [AuthController::class, 'update']);
Route::get('/leaderboard/top', [LeaderboardController::class, 'getTopLeaderboard']);
Route::get('/foods/search', [App\Http\Controllers\Api\FoodLogController::class, 'searchFood']);
Route::get('/foods/search', [FoodLogController::class, 'searchFood']);
Route::post('/food-log/whatsapp', [FoodLogController::class, 'storeFromWhatsApp']);
Route::get('/screening/latest/{user_id}',[ScreeningController::class,'latest']);
Route::get('/screening/history/{user_id}',[ScreeningController::class,'history']);
Route::get('/alerts/{user_id}',[AlertController::class,'obesityRisk']);
Route::get('/coaching/daily/{user_id}',[CoachingController::class,'daily']);
Route::get('/coaching/history/{user_id}',[CoachingController::class,'history']);
Route::get('/weekly-report/{user_id}',[WeeklyReportController::class, 'generate']);
Route::get('/weekly-plan/{user_id}', [WeeklyPlanController::class, 'getPlan']);
Route::get('/test-gemini', [TestGeminiController::class, 'test']);
Route::get('/test-deepseek', [TestDeepSeekController::class,'test']);
Route::get('/test-groq', [TestGroqController::class, 'test']);
Route::get('/craving/{user_id}/{type}', [CravingController::class, 'store']);
Route::get('/craving-history/{user_id}', [CravingController::class, 'history']);
Route::get('/streak/{user_id}',[StreakController::class,'getStreak']);

Route::get('/meal-swap/{user_id}/{food}',[MealSwapController::class,'getRecommendation']);
Route::get('/activity-recommendation/{user_id}',[ActivityRecommendationController::class,'getRecommendation']);
Route::get('/food-logs/history/{userId}', [FoodLogController::class, 'history']);
Route::get('/activity-log', function () {return response()->json(['message' => 'Activity API aktif']);});
Route::post('/activity-log', [ActivityLogController::class,'store']);
Route::get('/activity-log/history/{user_id}',[ActivityLogController::class,'history']);
Route::get('/activity-log/today-burned/{user_id}',[ActivityLogController::class,'todayBurned']);
Route::get('/education',[EducationController::class,'index']);
Route::delete('/delete-account/{id}',[AuthController::class,'deleteAccount']);
Route::get('/weight-loss-plan/{user_id}',[WeightLossPlanController::class,'generate']);
Route::get('/medical-safety/{user_id}',[MedicalSafetyController::class,'analyze']);
Route::get('/smart-reminders/{userId}',[SmartReminderController::class,'index']);
Route::post('/smart-reminders/regenerate/{userId}',[SmartReminderController::class,'regenerate']);
Route::post('/smart-reminders/complete/{id}',[SmartReminderController::class,'complete']);
Route::delete('/smart-reminders/{userId}',[SmartReminderController::class,'deleteToday']);
Route::post('/food-parsing',[FoodParsingController::class, 'parse']);
Route::post('/food-image', [FoodParsingController::class, 'parseImage']);
Route::get('/test-gemini-http', function () {

    $key = env('GEMINI_API_KEY');

    $url = "https://generativelanguage.googleapis.com/v1beta/models?key={$key}";

    $response = Http::get($url);

    return response()->json([
        'status' => $response->status(),
        'body' => $response->json(),
    ]);

});
Route::post('/test-upload', function () {

    dd("MASUK");

});

// ======================================
// EXPERT REVIEW
// ======================================
Route::get('/expert-reviews', [ExpertReviewController::class, 'index']);
Route::get('/expert-reviews/{userId}', [ExpertReviewController::class, 'show']);
Route::post('/expert-reviews', [ExpertReviewController::class, 'store']);
Route::put('/expert-reviews/{id}', [ExpertReviewController::class, 'update']);
Route::delete('/expert-reviews/{id}', [ExpertReviewController::class, 'destroy']);
Route::get('/expert/users',[ExpertDashboardController::class,'index']);
Route::get('/user/expert-review/{userId}',[ExpertReviewController::class, 'userReview']);

// ======================================
// ADMIN
// ======================================
// ==========================================
// RUTE AUTH ADMIN (Sesuai AdminLogin.jsx)
// ==========================================
Route::post('/admin/login', [AdminAuthController::class, 'login']);

// ==========================================
// GRUP RUTE ADMIN PANEL
// ==========================================
Route::prefix('admin')->group(function () {
    // 1. Dashboard Utama (Sesuai Dashboard.jsx)
    Route::get('/dashboard', [AdminDashboardController::class, 'index']); // Diubah dari '/dashboard-stats' agar pas dengan frontend

    // 2. User Management
    Route::get('/users', [UserController::class, 'index']);

    // 3. Food Intelligence Center (Sesuai FoodCenter.jsx)
Route::get('/foods', [AdminFoodController::class, 'index']);
Route::post('/foods', [AdminFoodController::class, 'store']);
Route::put('/foods/{id}', [AdminFoodController::class, 'update']);
Route::delete('/foods/{id}', [AdminFoodController::class, 'destroy']);
Route::get('/food-statistics', [AdminFoodStatisticsController::class, 'index']); // Grafik tren kalori admin

    // 4. AI Weight Plan & Prompt (Sesuai AIWeight.jsx)
    Route::get('/weekly-plans', [AdminWeeklyPlanController::class, 'getAllPlans']);// List plan user
    // Tambahkan 2 rute ini agar Admin bisa baca & edit Prompt teks di database lewat SystemSetting
    Route::get('/ai-settings', [AdminSettingsController::class, 'index']); 
    Route::put('/ai-settings/{key}', [AdminSettingsController::class, 'update']); 

    // 5. Risk & Safety Center (Sesuai RiskSafety.jsx)
    Route::get('/risk-alerts', [RiskAlertController::class, 'index']);
    Route::get('/risk-statistics', [RiskAlertController::class, 'statistics']);

    // 6. Behavior Coaching & Audit Log (Sesuai Coaching.jsx & Agentlog.jsx)
    Route::get('/coaching', [AdminCoachingController::class, 'index']);
     // Tambahkan rute log multi-agent ini

    // 7. Achievements & Badges (Sesuai Achievements.jsx)
    Route::get('/achievements', [AdminAchievementController::class, 'index']);
});

// ==========================================
// RUTE CRUD BADGES & CHALLENGES (Achievements.jsx)
// ==========================================
// Ubah prefix-nya agar masuk ke kelompok /api/admin/... sesuai request Axios frontend
Route::prefix('admin/achievements')->group(function () {
    Route::post('/badges', [AdminAchievementController::class, 'storeBadge']);
    Route::put('/badges/{id}', [AdminAchievementController::class, 'updateBadge']);
    Route::delete('/badges/{id}', [AdminAchievementController::class, 'destroyBadge']);

    Route::post('/challenges', [AdminAchievementController::class, 'storeChallenge']);
    Route::put('/challenges/{id}', [AdminAchievementController::class, 'updateChallenge']);
    Route::delete('/challenges/{id}', [AdminAchievementController::class, 'destroyChallenge']);
});

Route::get('/weekly-plans', [AdminWeeklyPlanController::class, 'getAllPlans']);

Route::prefix('admin')->group(function () {

    Route::get('/education-content', [AdminEducationController::class, 'index']);

    Route::post('/education-content', [AdminEducationController::class, 'store']);

    Route::put('/education-content/{id}', [AdminEducationController::class, 'update']);

    Route::delete('/education-content/{id}', [AdminEducationController::class, 'destroy']);

    Route::get('/education-statistics', [AdminEducationController::class, 'statistics']);
Route::get('/agent-logs',[AdminAgentLogController::class,'index']);
Route::put('/settings/password', [AdminSettingsController::class, 'changePassword']);
});