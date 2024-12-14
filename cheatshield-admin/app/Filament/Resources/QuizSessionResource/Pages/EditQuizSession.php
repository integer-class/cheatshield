<?php

namespace App\Filament\Resources\QuizSessionResource\Pages;

use App\Filament\Resources\QuizSessionResource;
use Carbon\Carbon;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditQuizSession extends EditRecord
{
    protected static string $resource = QuizSessionResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $started_at = Carbon::parse($data['started_at']);
        $completed_at = Carbon::parse($data['completed_at']);
        $data['duration'] = $started_at->diffInMinutes($completed_at);

        return $data;
    }
}
