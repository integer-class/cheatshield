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
                'user_id' => '9da11160-4edf-4f87-8745-e0f749c58cdb', // anu iki tak place ambe uuid student sg wes dibuat
                'nim' => '1234567890',
                'gender' => 'male',
            ]
        ];

        DB::table('students')->insert($data);
    }
}
