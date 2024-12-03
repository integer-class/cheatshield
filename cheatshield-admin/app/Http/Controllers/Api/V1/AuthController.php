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

        // if email field is filled, make sure it's a valid format
        if ($request->has('email')) {
            if (! filter_var($request->email, FILTER_VALIDATE_EMAIL)) {
                return response()->json([
                    'message' => 'Invalid email format',
                ], JsonResponse::HTTP_BAD_REQUEST);
            }
        }

        $user->name ??= $request->name;
        $user->email ??= $request->email;
        $user->nim ??= $request->nim;
        $user->gender ??= $request->gender;
        $user->photo ??= $request->photo;

        $user->save();

        return response()->json([
            'message' => 'Profile updated successfully',
        ]);
    }
}
