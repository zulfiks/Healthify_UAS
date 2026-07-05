<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BehaviorCoachingHistory extends Model
{
    protected $table = 'behavior_coaching_history';

    protected $fillable = [
        'user_id',
        'motivation',
        'habit_evaluation',
        'overeating_strategy',
        'mindful_eating',
        'craving_support',
        'generated_at'
    ];
}