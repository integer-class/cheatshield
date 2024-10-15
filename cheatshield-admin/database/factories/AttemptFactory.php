<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;
use App\Models\Attempt;
use App\Models\Quiz;
use App\Models\User;

class AttemptFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Attempt::class;

    /**
     * Define the model's default state.
     */
    public function definition(): array
    {
        return [
            'quiz_id' => Quiz::factory(),
            'user_id' => User::factory(),
            'started_at' => $this->faker->dateTime(),
            'completed_at' => $this->faker->dateTime(),
            'score' => $this->faker->randomFloat(2, 0, 999.99),
        ];
    }
}
