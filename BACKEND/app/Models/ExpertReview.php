<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExpertReview extends Model
{
    protected $table = 'expert_reviews';

    protected $fillable = [
        'user_id',
        'expert_name',
        'ai_recommendation',
        'expert_note',
        'meal_plan',
        'status',
        'reviewed_at',
    ];

    protected $casts = [
        'reviewed_at' => 'datetime',
    ];

    // Relasi ke User
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}