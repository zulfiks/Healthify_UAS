<?php

namespace App\Services;

use App\Models\SmartReminder;
use Carbon\Carbon;

class SmartReminderService
{
    protected $groq;
    protected $dataService;
    protected $promptService;
    protected $parserService;

    public function __construct(
        GroqService $groq,
        ReminderDataService $dataService,
        ReminderPromptService $promptService,
        ReminderParserService $parserService
    ) {
        $this->groq = $groq;
        $this->dataService = $dataService;
        $this->promptService = $promptService;
        $this->parserService = $parserService;
    }

    public function generateDailyReminder($userId)
    {
        $today = Carbon::today()->toDateString();

        $existing = SmartReminder::where(
            'user_id',
            $userId
        )
        ->whereDate(
            'generated_for_date',
            $today
        )
        ->orderBy('reminder_time')
        ->get();

        if ($existing->count() > 0) {
            return $existing;
        }

        $data = $this->dataService
            ->getUserData($userId);

        $prompt = $this->promptService
            ->build($data);

        $response = $this->groq
            ->ask($prompt);

        $reminders = $this->parserService
            ->parse($response);

        $saved = collect();

        foreach ($reminders as $item) {

            $saved->push(

                SmartReminder::create([

                    'user_id' => $userId,

                    'title' => $item['title'],

                    'message' => $item['message'],

                    'reminder_time' => $item['time'],

                    'reminder_type' => $item['type'],

                    'is_completed' => false,

                    'generated_for_date' => $today,

                ])

            );

        }

        return $saved;
    }

    public function regenerate($userId)
    {
        SmartReminder::where(
            'user_id',
            $userId
        )
        ->whereDate(
            'generated_for_date',
            Carbon::today()
        )
        ->delete();

        return $this->generateDailyReminder(
            $userId
        );
    }

    public function getToday($userId)
    {
        return SmartReminder::where(
            'user_id',
            $userId
        )
        ->whereDate(
            'generated_for_date',
            Carbon::today()
        )
        ->orderBy(
            'reminder_time'
        )
        ->get();
    }

    public function completeReminder($id)
    {
        $reminder = SmartReminder::find($id);

        if (!$reminder) {
            return false;
        }

        $reminder->is_completed = true;
        $reminder->save();

        return true;
    }

    public function deleteTodayReminder($userId)
    {
        return SmartReminder::where(
            'user_id',
            $userId
        )
        ->whereDate(
            'generated_for_date',
            Carbon::today()
        )
        ->delete();
    }
}