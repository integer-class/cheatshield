<?php

namespace App\Filament\Resources\QuizSessionResource\Pages;

use App\Filament\Resources\QuizSessionResource;
use App\Models\UserAnswerInSession;
use App\Models\UserInQuizSession;
use Carbon\Carbon;
use Filament\Resources\Pages\ListRecords;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class ShowQuizSession extends ListRecords
{
    protected static string $resource = QuizSessionResource::class;

    protected function getHeaderActions(): array
    {
        return [
        ];
    }

    public function table(Table $table): Table
    {
        return $table
            ->query(UserInQuizSession::query())
            ->columns([
                Tables\Columns\TextColumn::make('user.name')
                    ->label('Name'),
                Tables\Columns\TextColumn::make('quizSession.title')
                    ->label('Quiz Title'),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Joined At')
                    ->alignCenter(),
                Tables\Columns\TextColumn::make('completed_at')
                    ->default(fn (Model $record) => $record->quizSession->completed_at)
                    ->alignCenter(),
                Tables\Columns\TextColumn::make('duration')
                    ->label('Duration left (minutes)')
                    ->default(fn (Model $record) => intval($record->created_at->diffInMinutes($record->quizSession->completed_at)))
                    ->alignCenter(),
                Tables\Columns\TextColumn::make('question_done')
                    ->label('Question Done')
                    ->default(function (Model $record) {
                        $totalQuestions = $record->quizSession->quiz->questions->count();
                        $totalQuestionsDone = UserAnswerInSession::query()
                            ->where('quiz_session_id', $record->quizSession->id)
                            ->count();

                        return "{$totalQuestionsDone}/{$totalQuestions}";
                    })
                    ->alignCenter(),
                Tables\Columns\TextColumn::make('status')
                    ->label('Status')
                    ->default(function (Model $record) {
                        // value could be:
                        // {
                        //     "last_updated_at": "2023-11-22T14:33:58.000000Z",
                        //     "looking_left": 0.121,
                        //     "looking_right": 0.241,
                        //     "looking_up": 0.012,
                        //     "looking_down": 0.726,
                        //     "looking_straight": 0.312,
                        // }
                        $status = json_decode($record->status, true);
                        if (! is_array($status)) {
                            return 'Inactive';
                        }

                        $lastUpdatedAtDate = Carbon::parse($status['last_updated_at']);
                        $isUpdatedFiveSecondsAgo = Carbon::now()->diffInSeconds($lastUpdatedAtDate) < 5;

                        if ($isUpdatedFiveSecondsAgo) {
                            return 'Inactive';
                        }

                        return $this->formatFaceStatusIntoReadable($status);
                    })
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'Inactive' => 'gray',
                        'Active' => 'success',
                        default => 'warning',
                    })
                    ->alignCenter(),
            ]);
    }

    /**
     * @param  array<int,mixed>  $status
     */
    private function formatFaceStatusIntoReadable(array $status): string
    {
        $highestProbability = '';
        $highestProbabilityValue = 0;
        foreach ($status as $key => $value) {
            // skip when value is less than 0.6 which means the face is detected
            if ($value < 0.6) {
                continue;
            }
            if ($value > $highestProbability) {
                $highestProbability = $key;
                $highestProbabilityValue = $value;
            }
        }

        if ($highestProbability === '') {
            return 'Cheating';
        }

        $statusText = Str::of($highestProbability)
            ->replace('_', ' ')
            ->ucfirst();
        $highestProbabilityPercent = number_format($highestProbabilityValue * 100, 2);

        return "{$statusText} ({$highestProbabilityPercent})%";
    }
}
