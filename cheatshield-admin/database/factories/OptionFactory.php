<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;
use App\Models\Option;
use App\Models\Question;

class OptionFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Option::class;

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
