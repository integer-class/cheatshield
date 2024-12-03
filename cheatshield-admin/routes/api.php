<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\FaceRecognitionController;
use App\Http\Controllers\Api\V1\QuizSessionController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// V1 Routes
Route::group([
    'prefix' => 'v1',
    'as' => 'api.v1.',
], function () {
    // TODO: remove this later
    Route::get('/user', function (Request $request) {
        return $request->user();
    })->middleware('auth:sanctum,role:student');

    // auth routes
    Route::group([
        'prefix' => 'auth',
        'as' => 'auth.',
    ], function () {
        Route::post('/login', [AuthController::class, 'login']);
        Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
        Route::post('/register', [AuthController::class, 'register']);
    });

    // quiz related routes
    Route::group([
        'prefix' => 'quiz',
        'as' => 'quiz.',
        'middleware' => 'auth:sanctum,role:student',
    ], function () {
        Route::get('/join/{code}', [QuizSessionController::class, 'join']);
        Route::get('/history', [QuizSessionController::class, 'history']);
    });

    // user related operations
    Route::group([
        'prefix' => 'user',
        'as' => 'user.',
        'middleware' => ['auth:sanctum', 'role:student'],
    ], function () {
        Route::get('/', [AuthController::class, 'getProfile']);
        Route::put('/', [AuthController::class, 'updateProfile']);
        Route::put('/embedding', [FaceRecognitionController::class, 'updateEmbedding']);
    });
});
