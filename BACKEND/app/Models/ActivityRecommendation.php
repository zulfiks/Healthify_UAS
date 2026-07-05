<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ActivityRecommendation extends Model
{
    protected $fillable = [
        'week',
        'min_bmi',
        'max_bmi',
        'activity_name',
        'duration_minutes',
        'description'
    ];
}