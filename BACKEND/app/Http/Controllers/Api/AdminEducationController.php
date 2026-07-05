<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EducationContent;
use Illuminate\Http\Request;

class AdminEducationController extends Controller
{
    /**
     * GET /api/admin/education-content
     */
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => EducationContent::latest()->get()
        ]);
    }

    /**
     * POST /api/admin/education-content
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'category' => 'required|string|max:100',
            'type' => 'required|string|max:50',
            'image_url' => 'nullable|string',
            'url' => 'nullable|string',
        ]);

        $content = EducationContent::create([
            'title' => $request->title,
            'description' => $request->description,
            'category' => $request->category,
            'type' => $request->type,
            'image_url' => $request->image_url,
            'url' => $request->url,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Konten berhasil ditambahkan',
            'data' => $content
        ]);
    }

    /**
     * PUT /api/admin/education-content/{id}
     */
    public function update(Request $request, $id)
    {
        $content = EducationContent::findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'category' => 'required|string|max:100',
            'type' => 'required|string|max:50',
            'image_url' => 'nullable|string',
            'url' => 'nullable|string',
        ]);

        $content->update([
            'title' => $request->title,
            'description' => $request->description,
            'category' => $request->category,
            'type' => $request->type,
            'image_url' => $request->image_url,
            'url' => $request->url,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Konten berhasil diupdate',
            'data' => $content
        ]);
    }

    /**
     * DELETE /api/admin/education-content/{id}
     */
    public function destroy($id)
    {
        $content = EducationContent::findOrFail($id);

        $content->delete();

        return response()->json([
            'success' => true,
            'message' => 'Konten berhasil dihapus'
        ]);
    }

    /**
     * GET /api/admin/education-statistics
     */
    public function statistics()
    {
        return response()->json([
            'success' => true,
            'total_contents' => EducationContent::count(),
            'categories' => EducationContent::distinct('category')->count('category'),

            // sementara gunakan total konten sebagai contoh
            // nanti kalau sudah ada tabel log AI bisa diganti
            'sent_this_week' => EducationContent::whereBetween(
                'created_at',
                [now()->startOfWeek(), now()->endOfWeek()]
            )->count()
        ]);
    }
}