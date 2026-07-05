<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CoachingTemplate extends Model
{
    protected $fillable = [
        'category',
        'title',
        'message'
    ];
}