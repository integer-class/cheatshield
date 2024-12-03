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
                'user_id' => '9da350cb-2d17-4f18-b340-620ccbb655fc', // anu iki tak place ambe uuid student sg wes dibuat
                'nim' => '1234567890',
                'gender' => 'male',
            ]
        ];

        DB::table('students')->insert($data);
    }
}
