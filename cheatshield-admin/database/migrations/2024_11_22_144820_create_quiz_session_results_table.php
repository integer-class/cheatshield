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
        Schema::create('quiz_session_results', function (Blueprint $table) {
            $table->id();
            $table->foreignUuid('user_id')->references('id')->on('users');
            $table->foreignUuid('quiz_session_id')->references('id')->on('quiz_sessions');
            $table->unsignedInteger('total_score');
            $table->unsignedInteger('correct_answers');
            $table->unsignedInteger('incorrect_answers');
            $table->jsonb('cheating_status')->nullable();

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('quiz_session_results');
    }
};
