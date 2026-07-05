<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SmartReminder extends Model
{
    use HasFactory;

    protected $table = 'smart_reminders';

    protected $fillable = [

        'user_id',

        'title',

        'message',

        'reminder_time',

        'reminder_type',

        'is_completed',

        'generated_for_date',

    ];

    protected $casts = [

        'is_completed' => 'boolean',

        'generated_for_date' => 'date',

    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}