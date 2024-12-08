<?php

namespace App\Services;

use App\Models\User;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\File;

class FaceRecognitionService
{
    private readonly Client $client;

    public function __construct()
    {
        $this->client = new Client([
            'base_uri' => env('FACE_RECOGNITION_SERVICE_URL'),
            'timeout' => 120 // 2 minutes since the video embedding can take a while
        ]);
    }

    public function updateEmbedding(User $user, File $video): array
    {
        $response = $this->client->post('/api/v1/face-recognition/embedding', [
            'multipart' => [
                [ 'name' => 'user_id', 'contents' => $user->id ],
                [ 'name' => 'video', 'contents' => $video ],
            ],
        ]);
        if ($response->getStatusCode() !== 200) {
            throw new \Exception('Failed to update embedding');
        }

        $data = json_decode($response->getBody()->getContents(), true);
        if ($data === null) {
            throw new \Exception('Failed to decode response from face recognition service');
        }

        if (count($data['data']) === 0) {
            throw new \Exception('Failed to generate embeddings from video');
        }

        return $data;
    }
}
