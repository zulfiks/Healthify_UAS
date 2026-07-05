<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\DeepSeekService;

class TestDeepSeekController extends Controller
{
    public function test()
    {
        $ai = new DeepSeekService();

        return $ai->ask(
            "Apa itu obesitas? Jawab singkat."
        );
    }
}