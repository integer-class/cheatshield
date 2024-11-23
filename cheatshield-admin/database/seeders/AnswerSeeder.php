<?php

namespace Database\Seeders;

use App\Models\Answer;
use App\Models\Question;
use App\Models\Quiz;
use Illuminate\Database\Seeder;

class AnswerSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        for ($i = 0; $i < 10; $i++) {
            $quiz = Quiz::factory()->create();

            for ($j = 0; $j < 10; $j++) {
                $question = Question::factory()->create([
                    'quiz_id' => $quiz->id,
                ]);

                for ($k = 0; $k < 4; $k++) {
                    Answer::factory()->create(['question_id' => $question->id]);
                }
            }
        }
    }
}
