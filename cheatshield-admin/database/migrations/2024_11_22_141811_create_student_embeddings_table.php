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
        Schema::create('student_embeddings', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('student_id')->references('id')->on('students');
            $table->binary('embedding');

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('student_embeddings');
    }
};
