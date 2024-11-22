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
        Schema::create('user_answer_in_sessions', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('user_id')->references('id')->on('users');
            $table->foreignUuid('quiz_session_id')->references('id')->on('quiz_sessions');
            $table->foreignUuid('question_id')->references('id')->on('questions');
            $table->foreignUuid('answer_id')->references('id')->on('answers');

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_answer_in_sessions');
    }
};
