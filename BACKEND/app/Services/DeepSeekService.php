<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class DeepSeekService
{
    public function ask($prompt)
    {
        $response = Http::withHeaders([
            'Authorization' => 'Bearer '.env('DEEPSEEK_API_KEY'),
            'Content-Type' => 'application/json'
        ])->post(
            'https://api.deepseek.com/chat/completions',
            [
                'model' => 'deepseek-chat',
                'messages' => [
                    [
                        'role' => 'user',
                        'content' => $prompt
                    ]
                ]
            ]
        );

        return $response->json();
    }
}