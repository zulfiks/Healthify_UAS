<?php

namespace App\Services;

class FoodParsingService
{
    protected GroqFastService $groq;

    protected FoodParsingPromptService $prompt;

    public function __construct(
        GroqFastService $groq,
        FoodParsingPromptService $prompt
    ) {
        $this->groq = $groq;
        $this->prompt = $prompt;
    }

    public function parse(string $text): array
    {

        $prompt = $this->prompt
            ->buildPrompt($text);

        $answer = $this->groq
            ->ask($prompt);

        $answer = trim($answer);

        $answer = str_replace(
            "```json",
            "",
            $answer
        );

        $answer = str_replace(
            "```",
            "",
            $answer
        );

        $json = json_decode(
            $answer,
            true
        );

        if (!$json) {

            return [

                'success' => false,

                'message' =>
                    'AI gagal memahami makanan.',

                'raw' => $answer

            ];

        }

        return [

            'success' => true,

            'foods' =>
                $json['foods'] ?? []

        ];

    }
}