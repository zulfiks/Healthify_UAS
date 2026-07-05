<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RiskAlert extends Model
{
    protected $fillable = [
        'user_id',
        'alert_type',
        'severity',
        'title',
        'description',
        'status',
        'detected_at'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}