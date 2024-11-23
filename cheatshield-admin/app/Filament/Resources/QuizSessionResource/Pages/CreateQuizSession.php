<?php

namespace App\Filament\Resources\QuizSessionResource\Pages;

use App\Filament\Resources\QuizSessionResource;
use Carbon\Carbon;
use Filament\Resources\Pages\CreateRecord;
use Illuminate\Database\Eloquent\Model;

class CreateQuizSession extends CreateRecord
{
    protected static string $resource = QuizSessionResource::class;

    protected function handleRecordCreation(array $data): Model
    {
        $started_at = Carbon::now();
        $completed_at = $started_at->clone()->addMinutes(intval($data['duration']));

        $data = [
            'user_id' => $data['user_id'],
            'quiz_id' => $data['quiz_id'],
            'code' => $data['code'],
            'title' => $data['title'],
            'is_active' => $data['is_active'],
            'started_at' => $started_at,
            'completed_at' => $completed_at,
        ];

        return parent::handleRecordCreation($data);
    }

    protected function getFormActions(): array
    {
        return [
            parent::getCreateFormAction(),
            parent::getCreateAnotherFormAction(),
            parent::getCancelFormAction(),
        ];
    }
}
