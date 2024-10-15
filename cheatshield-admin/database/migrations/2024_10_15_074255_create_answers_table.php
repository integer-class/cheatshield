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
        Schema::disableForeignKeyConstraints();

        Schema::create('answers', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('attempt_id')->constrained();
            $table->foreignUuid('question_id')->constrained();
            $table->foreignUuid('option_id')->nullable()->constrained();
            $table->text('content')->nullable();
            $table->boolean('is_correct');
            $table->decimal('points_earned', 5, 2)->nullable();
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('answers');
    }
};
