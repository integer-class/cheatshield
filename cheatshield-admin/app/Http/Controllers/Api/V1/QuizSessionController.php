<?php

namespace App\Http\Controllers\Api\V1;

use Carbon\Carbon;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use App\Models\QuizSession;
use App\Models\QuizSessionResult;
use App\Models\UserInQuizSession;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class QuizSessionController extends Controller
{
    public function join(Request $request, string $code): JsonResponse
    {
        $user = $request->user();
        $session = QuizSession::query()->where('code', $code)->first();
        if (! $session) {
            return response()->json([
                'message' => 'Invalid quiz code',
            ], JsonResponse::HTTP_NOT_FOUND);
        }

        if ($session->completed_at < Carbon::now()) {
            return response()->json([
                'message' => 'Quiz session has been completed',
            ], JsonResponse::HTTP_FORBIDDEN);
        }

        if ($session->started_at > Carbon::now()) {
            return response()->json([
                'message' => 'Quiz session has not started yet',
            ], JsonResponse::HTTP_FORBIDDEN);
        }

        if (!$session->is_active) {
            return response()->json([
                'message' => 'Quiz session is not active',
            ], JsonResponse::HTTP_FORBIDDEN);
        }

        $userSession = UserInQuizSession::query()->create([
            'user_id' => $user->id,
            'quiz_session_id' => $session->id,
        ]);

        return response()->json([
            'message' => 'Joined successfully',
        ]);
    }

    public function history(Request $request): JsonResponse
    {
        $user = $request->user();
        $results = QuizSessionResult::query()
            ->where('user_id', $user->id)
            ->get();

        return response()->json($results);
    }
}
