<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $validatedData = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // login with sanctum
        if (! Auth::attempt($validatedData)) {
            return response()->json([
                'message' => 'Invalid email or password',
            ], JsonResponse::HTTP_UNAUTHORIZED);
        }

        $token = $request->user()->createToken('personal_access_token');

        return response()->json([
            'token' => $token->plainTextToken,
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Logged out successfully',
        ], JsonResponse::HTTP_OK);
    }

    public function register(Request $request): JsonResponse
    {
        $validatedData = $request->validate([
            'name' => 'required',
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::query()->create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'password' => bcrypt($validatedData['password']),
            'role' => 'student',
        ]);

        $token = $user->createToken('personal_access_token');

        return response()->json([
            'token' => $token->plainTextToken,
        ]);
    }

    public function getProfile(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'name' => $user->name,
            'email' => $user->email,
            'nim' => $user->student->nim,
            'gender' => $user->student->gender,
            'photo' => $user->student->photo,
        ]);
    }

    public function updateProfile(Request $request): JsonResponse
{
    $user = $request->user();

    // Validate email if provided
    if ($request->has('email') && !filter_var($request->email, FILTER_VALIDATE_EMAIL)) {
        return response()->json([
            'message' => 'Invalid email format',
        ], JsonResponse::HTTP_BAD_REQUEST);
    }

    // Update user fields if new data is provided
    if ($request->filled('name')) {
        $user->name = $request->name;
    }
    if ($request->filled('email')) {
        $user->email = $request->email;
    }

    // Ensure the student relation is loaded
    $student = $user->student;
    if ($student) {
        if ($request->filled('nim')) {
            $student->nim = $request->nim;
        }
        if ($request->filled('gender')) {
            $student->gender = $request->gender;
        }
        if ($request->filled('photo')) {
            $student->photo = $request->photo;
        }

        // Save changes to the student relation
        $student->save();
    }

    // Save changes to the user
    $user->save();

    return response()->json([
        'message' => 'Profile updated successfully',
    ]);
}


}
