<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Question;
use App\Models\QuizSession;
use App\Models\QuizSessionResult;
use App\Models\UserAnswerInSession;
use App\Models\UserInQuizSession;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class QuizSessionController extends Controller
{
    public function join(Request $request, string $code): JsonResponse
    {
        $user = $request->user();
        $session = QuizSession::query()
            ->where('code', $code)
            ->first();
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

        $userSession = UserInQuizSession::query()
            ->create([
                'user_id' => $user->id,
                'quiz_session_id' => $session->id,
            ]);

        return response()->json([
            'message' => 'Joined successfully',
            'quiz_session' => $session,
            'user_in_quiz_session' => $userSession,
        ]);
    }

    public function history(Request $request): JsonResponse
    {
        $user = $request->user();
        $results = QuizSessionResult::query()
            ->where('user_id', $user->id)
            ->with('quizSession.quiz')
            ->get();

        // Menambahkan title ke response
        $resultsWithTitles = $results->map(function ($result) {
            return [
                'id' => $result->id,
                'user_id' => $result->user_id,
                'quiz_session_id' => $result->quiz_session_id,
                'total_score' => $result->total_score,
                'correct_answers' => $result->correct_answers,
                'incorrect_answers' => $result->incorrect_answers,
                'quiz_title' => $result->quizSession->quiz->title,
                'created_at' => $result->created_at,
                'updated_at' => $result->updated_at,
            ];
        });

        return response()->json([
            'message' => 'Successfully retrieved quiz session results',
            'quiz_session_results' => $resultsWithTitles,
        ]);
    }


    public function submitAnswerForQuestion(Request $request): JsonResponse
    {
        $validatedData = $request->validate([
            'quiz_session_id' => 'required|uuid|exists:quiz_sessions,id',
            'question_id' => 'required|uuid|exists:questions,id',
            'answer_id' => 'required|uuid|exists:answers,id',
        ]);
        $user = Auth::user();

        $question = Question::query()
            ->where('id', $validatedData['question_id'])
            ->first();

        if (! $question) {
            return response()->json([
                'message' => 'Invalid question id',
            ], JsonResponse::HTTP_NOT_FOUND);
        }

        $result = UserAnswerInSession::query()
            ->updateOrCreate([
                'user_id' => $user->id,
                'quiz_session_id' => $validatedData['quiz_session_id'],
                'question_id' => $validatedData['question_id'],
                'answer_id' => $validatedData['answer_id'],
            ], [
                'user_id' => $user->id,
                'quiz_session_id' => $validatedData['quiz_session_id'],
                'question_id' => $validatedData['question_id'],
                'answer_id' => $validatedData['answer_id'],
            ]);

        if (! $result) {
            return response()->json([
                'message' => 'Failed to update or create user answer in session',
            ], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }

        return response()->json([
            'message' => 'Successfully updated or created user answer in session',
        ], JsonResponse::HTTP_OK);
    }

    public function finishQuizSession(Request $request, QuizSession $userQuizSession): JsonResponse
    {
        $rules = [
            'quiz_session_id' => 'required|uuid|exists:quiz_sessions,id',
        ];

        $validatedData = $request->validate($rules);

        $user = Auth::user();

        $userQuizSession = UserInQuizSession::query()
            ->where('user_id', $user->id)
            ->first();
        if (! $userQuizSession) {
            return response()->json([
                'message' => 'This user is not in a valid quiz session',
            ], JsonResponse::HTTP_NOT_FOUND);
        }

        $userAnswers = UserAnswerInSession::query()
            ->where([
                ['user_id', $user->id],
                ['quiz_session_id', $validatedData['quiz_session_id']],
            ])
            ->with([
                'question:id,points',
                'answer:id,is_correct',
            ])
            ->get();

        // if ($userAnswers->count() > 0) {
        //     return response()->json(['message' => 'You have already answered this quiz session'], 400);
        // }

        if ($userAnswers->count() === 0) {
            return response()->json([
                'message' => 'You have not answered any questions yet',
            ], JsonResponse::HTTP_BAD_REQUEST);
        }

        // calculate score
        $totalScore = 0;
        $correctAnswers = 0;
        $incorrectAnswers = 0;
        foreach ($userAnswers as $userAnswer) {
            if ($userAnswer->answer->is_correct) {
                $correctAnswers++;
                $totalScore += $userAnswer->question->points;
            } else {
                $incorrectAnswers++;
            }
        }

        DB::beginTransaction();

        try {
            $quizSessionResult = QuizSessionResult::query()
                ->create([
                    'user_id' => $user->id,
                    'quiz_session_id' => $validatedData['quiz_session_id'],
                    'total_score' => $totalScore,
                    'correct_answers' => $correctAnswers,
                    'incorrect_answers' => $incorrectAnswers,
                ]);
            $userQuizSession->delete();
            DB::commit();
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error($e);

            return response()->json([
                'message' => 'Failed to finish quiz session',
            ], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }

        return response()->json([
            'message' => 'Successfully finished quiz session',
            'quiz_session_result' => $quizSessionResult,
        ]);
    }
}
