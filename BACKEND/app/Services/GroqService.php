<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class GroqService
{
    public function ask($prompt)
    {
        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('GROQ_API_KEY'),
            'Content-Type' => 'application/json'
        ])->post(
            'https://api.groq.com/openai/v1/chat/completions',
            [
                'model' => 'llama-3.3-70b-versatile',

                'messages' => [
                    [
                        'role' => 'system',
                        'content' =>
                            'Kamu adalah AI coach kesehatan Healthify.
                            Berikan jawaban yang jelas dan praktis.
                            Gunakan bahasa Indonesia.
                            Panjang jawaban 2-5 kalimat atau 3-5 poin.'
                    ],

                    [
                        'role' => 'user',
                        'content' => $prompt
                    ]
                ],

                'temperature' => 0.6,
                'max_tokens' => 500
            ]
        );

        if (!$response->successful()) {
    return $response->body();
}

$data = $response->json();

if (!isset($data['choices'][0]['message']['content'])) {
    return json_encode($data);
}

return $data['choices'][0]['message']['content'];
    }
}