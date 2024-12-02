<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class StudentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $data = [
            [
                'id' => \Illuminate\Support\Str::uuid(),
                'user_id' => '9da100db-b447-4f9e-b98c-38e671334380',
                'nim' => '1234567890',
                'gender' => 'male',
            ]
        ];

        DB::table('students')->insert($data);
    }
}
