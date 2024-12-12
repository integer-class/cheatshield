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
            'timeout' => 120, // 2 minutes since the video embedding can take a while
        ]);
    }

    /**
     * Generates an embedding for a given video
     *
     * @param  array<string, File>  $videos
     */
    public function updateEmbedding(User $user, array $videos): array
    {
        $response = $this->client->post('/api/v1/face-recognition/embedding', [
            'multipart' => [
                ['name' => 'user_id', 'contents' => $user->id],
                ['name' => 'left', 'contents' => $videos['left']],
                ['name' => 'right', 'contents' => $videos['right']],
                ['name' => 'up', 'contents' => $videos['up']],
                ['name' => 'down', 'contents' => $videos['down']],
                ['name' => 'straight', 'contents' => $videos['straight']],
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
