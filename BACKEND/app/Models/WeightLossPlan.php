<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WeightLossPlan extends Model
{
    protected $fillable = [
        'user_id',
        'plan_text',
        'generated_at'
    ];
}