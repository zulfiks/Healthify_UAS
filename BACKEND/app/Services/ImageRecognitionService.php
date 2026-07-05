<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class ImageRecognitionService
{
    public function recognize(string $base64Image)
    {
        $apiKey = env('GEMINI_API_KEY');

        $url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={$apiKey}";

       try {

    $response = Http::connectTimeout(10)
        ->timeout(20)
        ->post($url, [

            "contents" => [

                [

                    "parts" => [

                        [
                            "text" => "Identifikasi makanan pada gambar ini. Jawab hanya nama makanan dalam bahasa Indonesia dipisahkan koma. Jangan beri penjelasan."
                        ],

                        [
                            "inline_data" => [
                                "mime_type" => "image/jpeg",
                                "data" => $base64Image
                            ]
                        ]

                    ]

                ]

            ]

        ]);

    dd(
        $response->status(),
        $response->body()
    );

} catch (\Throwable $e) {

    dd($e->getMessage());

}

        if (!$response->successful()) {

            return null;

        }

        $json = $response->json();

        return $json['candidates'][0]['content']['parts'][0]['text']
            ?? null;
    }
}