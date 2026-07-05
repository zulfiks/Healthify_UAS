<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Food;
use Illuminate\Http\Request;

class AdminFoodController extends Controller
{
    /**
     * GET /api/admin/foods
     */
    public function index()
    {
        $foods = Food::orderBy('id', 'desc')->get();

        return response()->json([
            'success' => true,
            'data' => $foods
        ]);
    }

    /**
     * POST /api/admin/foods
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'calories' => 'required|numeric|min:0',
            'protein' => 'nullable|numeric|min:0',
            'carbs' => 'nullable|numeric|min:0',
            'fat' => 'nullable|numeric|min:0',
            'serving_size' => 'required|string|max:100',
        ]);

        $food = Food::create([
            'name' => $request->name,
            'calories' => $request->calories,
            'protein' => $request->protein ?? 0,
            'carbs' => $request->carbs ?? 0,
            'fat' => $request->fat ?? 0,
            'serving_size' => $request->serving_size,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Makanan berhasil ditambahkan',
            'data' => $food
        ], 201);
    }

    /**
     * PUT /api/admin/foods/{id}
     */
    public function update(Request $request, $id)
    {
        $food = Food::findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'calories' => 'required|numeric|min:0',
            'protein' => 'nullable|numeric|min:0',
            'carbs' => 'nullable|numeric|min:0',
            'fat' => 'nullable|numeric|min:0',
            'serving_size' => 'required|string|max:100',
        ]);

        $food->update([
            'name' => $request->name,
            'calories' => $request->calories,
            'protein' => $request->protein ?? 0,
            'carbs' => $request->carbs ?? 0,
            'fat' => $request->fat ?? 0,
            'serving_size' => $request->serving_size,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Makanan berhasil diupdate',
            'data' => $food
        ]);
    }

    /**
     * DELETE /api/admin/foods/{id}
     */
    public function destroy($id)
    {
        $food = Food::findOrFail($id);

        $food->delete();

        return response()->json([
            'success' => true,
            'message' => 'Makanan berhasil dihapus'
        ]);
    }
}