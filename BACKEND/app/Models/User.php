<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use App\Models\ExpertReview;
use App\Models\Screening;

class User extends Authenticatable
{
    public function foodLogs()
    
    {
        return $this->hasMany(FoodLog::class, 'user_id');
    }
public function latestScreening()
{
    return $this->hasOne(
        Screening::class,
        'user_id'
    )->latestOfMany();
}
    // ==========================
    // EXPERT REVIEW
    // ==========================
    public function expertReview()
    {
        return $this->hasOne(ExpertReview::class, 'user_id');
    }

    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'whatsapp_number',
        // Tambahkan baris di bawah ini:
        'pola_makan', 'jam_makan', 'ngemil', 'gula', 'aktivitas', 
        'tidur', 'stres', 'riwayat', 'penyakit', 'klasifikasi_risiko','profile_picture',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}
