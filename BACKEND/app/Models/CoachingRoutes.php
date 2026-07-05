<?php

// Tambahkan di dalam Route::prefix('admin')->middleware(['auth:sanctum', 'admin'])->group()
// di file routes/api.php

use App\Http\Controllers\Api\AdminCoachingController;

Route::prefix('admin')->middleware(['auth:sanctum'])->group(function () {

    // Dashboard coaching
    Route::get('/coaching', [AdminCoachingController::class, 'index']);

    // CRUD Template
    Route::post('/coaching/templates',          [AdminCoachingController::class, 'store']);
    Route::put('/coaching/templates/{id}',      [AdminCoachingController::class, 'update']);
    Route::delete('/coaching/templates/{id}',   [AdminCoachingController::class, 'destroy']);

});