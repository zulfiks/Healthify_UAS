<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EducationContent;

class EducationController extends Controller
{
    public function index()
    {
        return response()->json(
            EducationContent::latest()->get()
        );
    }
}