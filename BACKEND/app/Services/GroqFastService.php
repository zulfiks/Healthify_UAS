<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class GroqFastService
{
    public function ask(string $prompt): string
    {
        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('GROQ_API_KEY'),
            'Content-Type' => 'application/json',
        ])->post(
            'https://api.groq.com/openai/v1/chat/completions',
            [

                'model' => 'llama-3.1-8b-instant',

                'messages' => [

                    [
                        'role' => 'system',
                        'content' =>
                            'Kamu adalah AI parser makanan Healthify.
                            Tugasmu memahami makanan yang diketik pengguna.
                            Selalu balas JSON valid.
                            Jangan beri penjelasan di luar JSON.'
                    ],

                    [
                        'role' => 'user',
                        'content' => $prompt
                    ]

                ],

                'temperature' => 0.2,

                'max_tokens' => 350

            ]
        );

        if (!$response->successful()) {
            throw new \Exception(
                'Groq Error : ' .
                $response->body()
            );
        }

        return $response['choices'][0]['message']['content'];
    }
}