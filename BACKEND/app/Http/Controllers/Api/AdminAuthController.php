<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class AdminAuthController extends Controller
{
    /**
     * Domain email admin
     */
    protected function allowedDomain(): string
    {
        return config('admin.email_domain', 'healthify.com');
    }

    // =========================
    // LOGIN ADMIN
    // =========================
    public function login(Request $request)
    {
        $domain = $this->allowedDomain();

        $validator = Validator::make($request->all(), [
            'email'    => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        // Validasi domain manual
        if (!str_ends_with($request->email, '@' . $domain)) {
            return response()->json([
                'message' => 'Email admin harus menggunakan domain @' . $domain,
            ], 422);
        }

        // Cari admin di database
        $admin = Admin::where('email', $request->email)->first();

        // Cek password
        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return response()->json([
                'message' => 'Email atau password salah',
            ], 401);
        }

        // Hapus token lama, buat token baru
        $admin->tokens()->delete();
        $token = $admin->createToken('admin-token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'admin'   => [
                'id'    => $admin->id,
                'email' => $admin->email,
                'role'  => $admin->role,
            ],
            'token' => $token,
        ]);
    }

    // =========================
    // LOGOUT ADMIN
    // =========================
    public function logout(Request $request)
    {
        $user = $request->user();

        if ($user && $user->currentAccessToken()) {
            $user->currentAccessToken()->delete();
        }

        return response()->json([
            'message' => 'Logout berhasil',
        ]);
    }

    // =========================
    // GET ADMIN YANG LOGIN
    // =========================
    public function me(Request $request)
    {
        return response()->json([
            'id'    => $request->user()->id,
            'email' => $request->user()->email,
            'role'  => $request->user()->role,
        ]);
    }

    // =========================
    // FORGOT PASSWORD
    // =========================
    public function forgotPassword(Request $request)
    {
        $domain = $this->allowedDomain();

        $validator = Validator::make($request->all(), [
            'email' => ['required', 'email'],
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        if (!str_ends_with($request->email, '@' . $domain)) {
            return response()->json([
                'message' => 'Email admin harus menggunakan domain @' . $domain,
            ], 422);
        }

        $admin = Admin::where('email', $request->email)->first();

        // Selalu return pesan sama supaya tidak bisa ditebak email terdaftar atau tidak
        if (!$admin) {
            return response()->json([
                'message' => 'Jika email terdaftar, link reset telah dikirim',
            ]);
        }

        $token = Str::random(64);

        DB::table('admin_password_reset_tokens')->updateOrInsert(
            ['email' => $admin->email],
            [
                'email'      => $admin->email,
                'token'      => Hash::make($token),
                'created_at' => now(),
            ]
        );

        $resetUrl = config('app.frontend_url', config('app.url'))
            . '/reset-password?token=' . $token . '&email=' . urlencode($admin->email);

        Mail::raw(
            "Reset password link:\n{$resetUrl}",
            function ($message) use ($admin) {
                $message->to($admin->email)
                    ->subject('Reset Password Admin');
            }
        );

        return response()->json([
            'message' => 'Link reset password dikirim jika email terdaftar',
        ]);
    }

    // =========================
    // RESET PASSWORD
    // =========================
    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'                 => ['required', 'email'],
            'token'                 => ['required', 'string'],
            'password'              => ['required', 'string', 'min:8', 'confirmed'],
            'password_confirmation' => ['required', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $record = DB::table('admin_password_reset_tokens')
            ->where('email', $request->email)
            ->first();

        if (!$record || !Hash::check($request->token, $record->token)) {
            return response()->json([
                'message' => 'Token tidak valid atau sudah digunakan',
            ], 400);
        }

        if (now()->diffInMinutes($record->created_at) > 60) {
            DB::table('admin_password_reset_tokens')->where('email', $request->email)->delete();
            return response()->json([
                'message' => 'Token sudah expired, silakan request reset password ulang',
            ], 400);
        }

        $admin = Admin::where('email', $request->email)->first();

        if (!$admin) {
            return response()->json([
                'message' => 'Admin tidak ditemukan',
            ], 404);
        }

        $admin->password = Hash::make($request->password);
        $admin->save();

        // Hapus token reset dan semua token login
        DB::table('admin_password_reset_tokens')->where('email', $request->email)->delete();
        $admin->tokens()->delete();

        return response()->json([
            'message' => 'Password berhasil diubah, silakan login kembali',
        ]);
    }
}