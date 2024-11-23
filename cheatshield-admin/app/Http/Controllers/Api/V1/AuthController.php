<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Response;

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
            return Response::json([
                'message' => 'Invalid email or password',
            ], JsonResponse::HTTP_UNAUTHORIZED);
        }

        $token = $request->user()->createToken('personal_access_token');

        return Response::json([
            'token' => $token->plainTextToken,
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->tokens()->delete();

        return Response::json([
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

        $user = User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'password' => bcrypt($validatedData['password']),
            'role' => 'student',
        ]);

        $token = $user->createToken('personal_access_token');

        return Response::json([
            'token' => $token->plainTextToken,
        ]);
    }
}
