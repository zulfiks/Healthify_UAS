<?php

namespace App\Models;
use App\Models\CoachingTemplate;

use Illuminate\Database\Eloquent\Model;

class CoachingHistory extends Model
{
    protected $fillable = [
        'user_id',
        'template_id',
        'read_at'
    ];
        public function template()
    {
        return $this->belongsTo(
            CoachingTemplate::class,
            'template_id'
        );
    }
}