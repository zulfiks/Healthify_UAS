<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EducationContent extends Model
{
    use HasFactory;

    protected $table = 'education_contents';

    protected $fillable = [

        'title',
        'description',
        'image_url',
        'type',
        'category',
        'url'

    ];
}