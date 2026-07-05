<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CravingHistory extends Model
{
    protected $fillable = [
        'user_id',
        'craving_type',
        'message',
        'ai_response'
    ];
}