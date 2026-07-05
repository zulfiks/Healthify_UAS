<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
      Schema::create('meal_swaps', function (Blueprint $table) {
    $table->id();
    $table->string('food_name');
    $table->text('alternative_food');
    $table->integer('calorie_saved');
    $table->text('recommendation');
    $table->timestamps();
});
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('meal_swaps');
    }
};
