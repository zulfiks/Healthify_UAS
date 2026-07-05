<?php

namespace App\Services;

use App\Models\UserPoint;

class PointService
{
    public static function add($userId,$activity,$points)
    {
        UserPoint::create([
            'user_id'=>$userId,
            'activity'=>$activity,
            'points'=>$points
        ]);
    }
}