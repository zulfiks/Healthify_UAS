<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MealSwap extends Model
{
    use HasFactory;

    protected $table = 'meal_swaps';

    protected $fillable = [
        'user_id',
        'original_food',
        'swap_recommendation'
    ];
}