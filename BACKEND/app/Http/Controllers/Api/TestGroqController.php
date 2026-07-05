<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\GroqService;

class TestGroqController extends Controller
{
    public function test()
    {
        $groq = new GroqService();

        return response()->json([
            'answer' => $groq->ask(
                'Saya sering ngemil malam. Bagaimana cara mengatasinya?'
            )
        ]);
    }
}