<?php

namespace App\Services;

class ReminderParserService
{
    public function parse($response)
    {
        if (empty($response)) {
            return $this->defaultReminder();
        }

        $response = trim($response);

        // Hapus markdown JSON
        $response = str_replace(
            ['```json', '```'],
            '',
            $response
        );

        $response = trim($response);

        $json = json_decode($response, true);

        if (
            json_last_error() !== JSON_ERROR_NONE ||
            !is_array($json)
        ) {

            preg_match('/\[[\s\S]*\]/', $response, $match);

            if (!empty($match)) {

                $json = json_decode(
                    $match[0],
                    true
                );

            }

        }

        if (
            json_last_error() !== JSON_ERROR_NONE ||
            !is_array($json)
        ) {

            return $this->defaultReminder();

        }

        $result = [];

        foreach ($json as $item) {

            if (
                !isset($item['time']) ||
                !isset($item['title']) ||
                !isset($item['message'])
            ) {

                continue;

            }

            $result[] = [

                'time' => $item['time'],

                'title' => $item['title'],

                'message' => $item['message'],

                'type' => $item['type'] ?? 'general',

            ];

        }

        if (count($result) == 0) {

            return $this->defaultReminder();

        }

        return $result;
    }

    private function defaultReminder()
    {

        return [

            [

                'time' => '07:00',

                'title' => 'Sarapan',

                'message' =>
                    'Jangan lupa sarapan sehat hari ini.',

                'type' => 'meal'

            ],

            [

                'time' => '10:00',

                'title' => 'Air Putih',

                'message' =>
                    'Minum minimal 500 ml air putih.',

                'type' => 'water'

            ],

            [

                'time' => '17:30',

                'title' => 'Aktivitas',

                'message' =>
                    'Luangkan waktu berjalan kaki selama 20 menit.',

                'type' => 'exercise'

            ],

            [

                'time' => '21:00',

                'title' => 'Tidur',

                'message' =>
                    'Tidur lebih awal agar tubuh pulih dengan baik.',

                'type' => 'sleep'

            ],

            [

                'time' => '15:00',

                'title' => 'Motivasi',

                'message' =>
                    'Sedikit kemajuan setiap hari akan menjadi hasil besar di masa depan.',

                'type' => 'motivation'

            ]

        ];

    }
}