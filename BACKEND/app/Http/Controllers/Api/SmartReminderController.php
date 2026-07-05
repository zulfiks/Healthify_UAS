<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\SmartReminderService;

class SmartReminderController extends Controller
{
    protected $service;

    public function __construct(
        SmartReminderService $service
    ) {
        $this->service = $service;
    }

    /**
     * Ambil reminder hari ini
     */
    public function index($userId)
    {
        $reminders = $this->service
            ->getToday($userId);

        if ($reminders->count() == 0) {

            $reminders = $this->service
                ->generateDailyReminder($userId);

        }

        return response()->json([

            'success' => true,

            'count' => $reminders->count(),

            'data' => $reminders

        ]);

    }

    /**
     * Generate ulang reminder
     */
    public function regenerate($userId)
    {

        $reminders = $this->service
            ->regenerate($userId);

        return response()->json([

            'success' => true,

            'message' => 'Reminder berhasil dibuat ulang.',

            'count' => $reminders->count(),

            'data' => $reminders

        ]);

    }

    /**
     * Tandai reminder selesai
     */
    public function complete($id)
    {

        $ok = $this->service
            ->completeReminder($id);

        return response()->json([

            'success' => $ok,

            'message' => $ok
                ? 'Reminder selesai.'
                : 'Reminder tidak ditemukan.'

        ]);

    }

    /**
     * Hapus reminder hari ini
     */
    public function deleteToday($userId)
    {

        $this->service
            ->deleteTodayReminder($userId);

        return response()->json([

            'success' => true,

            'message' => 'Reminder hari ini berhasil dihapus.'

        ]);

    }
}