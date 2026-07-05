<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AdminAISettingController extends Controller
{
    private function userBackendUrl(): string
    {
        return config('services.user_backend.url', 'http://127.0.0.1:8000');
    }

    public function index()
    {
        try {
            $response = Http::timeout(5)
                ->get("{$this->userBackendUrl()}/api/admin/ai-settings");

            if ($response->failed()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Gagal mengambil data dari backend user.',
                ], 502);
            }

            return response()->json($response->json());
        } catch (\Exception $e) {
            Log::error('Gagal konek ke backend USER (ai-settings index)', [
                'message' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Tidak bisa terhubung ke backend user.',
            ], 503);
        }
    }

    public function update(Request $request, $key)
    {
        try {
            $response = Http::timeout(5)
                ->put("{$this->userBackendUrl()}/api/admin/ai-settings/{$key}", [
                    'value' => $request->input('value'),
                ]);

            if ($response->failed()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Gagal menyimpan ke backend user.',
                ], 502);
            }

            return response()->json($response->json());
        } catch (\Exception $e) {
            Log::error('Gagal konek ke backend USER (ai-settings update)', [
                'message' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Tidak bisa terhubung ke backend user.',
            ], 503);
        }
    }
}