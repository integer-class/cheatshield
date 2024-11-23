<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\FaceRecognitionService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rules\File;

class FaceRecognitionController extends Controller
{
    public function __construct(private readonly FaceRecognitionService $faceRecognitionService) {}

    public function updateEmbedding(Request $request): JsonResponse
    {
        $request->validate([
            'user_id' => 'required|integer',
            'video' => [
                'required',
                File::types(['mp4'])
                    ->max(1024 * 1024 * 20), // 20 MB
            ],
        ]);

        /** @var User $user */
        $user = $request->user();
        $files = $request->file('video');
        if ($files === null || count($files) === 0) {
            return response()->json([
                'message' => 'No file uploaded',
                'data' => null,
            ], JsonResponse::HTTP_BAD_REQUEST);
        }

        $file = $files[0];

        $embeddings = $this->faceRecognitionService->updateEmbedding($user, $file);

        // flush old embeddings
        $user->student->embeddings()->delete();
        // save new embeddings
        $user->student->embeddings()
            ->createMany(collect($embeddings)
                ->map(fn ($embedding) => ['embedding' => $embedding]));
        $user->student->save();

        return response()->json([
            'message' => 'Embedding updated successfully',
            'data' => $user->embedding,
        ]);
    }
}
