<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserStreak extends Model
{
    protected $table = 'user_streaks';

    protected $fillable = [
        'user_id',
        'current_streak',
        'best_streak',
        'last_activity_date'
    ];
}