<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\Student;
use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Role::create(['name' => 'admin']);
        Role::create(['name' => 'student']);

        $admin = User::factory()->create([
            'name' => 'Admin',
            'email' => 'admin@gmail.com',
            'password' => bcrypt('admin'),
        ]);
        $admin->assignRole('admin');

        // dummy students
        $student = User::factory()->create([
            'name' => 'Student',
            'email' => 'student@gmail.com',
            'password' => bcrypt('student'),
        ]);
        Student::create([
            'user_id' => $student->id,
            'nim' => '1234567890',
            'gender' => 'male',
        ]);
        $student->assignRole('student');
    }
}
