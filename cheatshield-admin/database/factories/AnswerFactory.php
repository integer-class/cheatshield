<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;
use App\Models\Answer;
use App\Models\Attempt;
use App\Models\Option;
use App\Models\Question;

class AnswerFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Answer::class;

    /**
     * Define the model's default state.
     */
    public function definition(): array
    {
        return [
            'attempt_id' => Attempt::factory(),
            'question_id' => Question::factory(),
            'option_id' => Option::factory(),
            'content' => $this->faker->paragraphs(3, true),
            'is_correct' => $this->faker->boolean(),
            'points_earned' => $this->faker->randomFloat(2, 0, 999.99),
        ];
    }
}
