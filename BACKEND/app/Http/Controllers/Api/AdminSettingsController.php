<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SystemSetting;
use App\Models\User;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AdminSettingsController extends Controller
{
    public function index()
    {
        $settings = SystemSetting::all();

        return response()->json([
            'success' => true,
            'totalUsers' => User::count(),
            'settings' => $settings
        ]);
    }
    public function changePassword(Request $request)
{
    $request->validate([
        'current_password' => 'required',
        'new_password' => 'required|min:6|confirmed',
    ]);

    $admin = Admin::first();

    if (!$admin) {
        return response()->json([
            'message' => 'Admin tidak ditemukan.'
        ], 404);
    }

    if (!Hash::check($request->current_password, $admin->password)) {
        return response()->json([
            'message' => 'Password lama salah.'
        ], 422);
    }

    $admin->password = Hash::make($request->new_password);
    $admin->save();

    return response()->json([
        'message' => 'Password berhasil diubah.'
    ]);
}
}