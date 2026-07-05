<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Food;

class FoodLog extends Model
{
    protected $fillable = [
        'user_id',
        'food_id',
        'food_name',
        'portion',
        'total_calories',
        'log_date',
        'whatsapp_number'
    ];

    public function food()
    {
        return $this->belongsTo(Food::class);
    }
}