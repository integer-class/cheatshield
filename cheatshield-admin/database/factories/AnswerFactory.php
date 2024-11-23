<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Answer;
use App\Models\Question;

/**
 * @extends Factory<Model>
 */
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
            'question_id' => Question::factory(),
            'content' => $this->faker->paragraphs(3, true),
            'is_correct' => $this->faker->boolean(),
        ];
    }
}
