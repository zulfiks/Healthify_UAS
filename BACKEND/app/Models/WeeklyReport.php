<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WeeklyReport extends Model
{
    protected $fillable = [

        'user_id',

        'period_start',
        'period_end',

        'report_text',

        'avg_calories',

        'weight_change',

        'frequent_food',

        'recommendation',

        'expert_note'
    ];
}