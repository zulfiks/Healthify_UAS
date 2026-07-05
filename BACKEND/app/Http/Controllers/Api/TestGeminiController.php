<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\GeminiService;

class TestGeminiController extends Controller
{
    public function test()
    {
        $gemini = new GeminiService();

        $result = $gemini->ask(
            "Halo, jawab singkat. Apa itu obesitas?"
        );

        return response()->json($result);
    }
}