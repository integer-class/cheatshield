<?php

namespace App\Filament\Resources;

use App\Filament\Resources\QuizSessionResource\Pages;
use App\Models\QuizSession;
use Carbon\Carbon;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class QuizSessionResource extends Resource
{
    protected static ?string $model = QuizSession::class;

    protected static ?string $navigationGroup = 'Quizzes';

    protected static ?string $navigationIcon = 'heroicon-o-qr-code';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Hidden::make('user_id')
                    ->default(Auth::user()->id),
                Forms\Components\Select::make('quiz_id')
                    ->relationship('quiz', 'title')
                    ->helperText('Select a quiz for this session')
                    ->columnSpanFull()
                    ->searchable()
                    ->required(),
                Forms\Components\Grid::make(12)
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->columnSpan(8)
                            ->helperText('Title of the session')
                            ->required()
                            ->maxLength(255),
                        Forms\Components\TextInput::make('code')
                            ->columnSpan(2)
                            ->helperText('max. 8 characters')
                            ->maxLength(8)
                            ->required(),
                        Forms\Components\TextInput::make('duration')
                            ->numeric()
                            ->minValue(1)
                            ->columnSpan(2)
                            ->helperText('in minutes')
                            ->required(),
                    ]),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('quiz.title'),
                Tables\Columns\TextColumn::make('code')
                    ->formatStateUsing(fn (string $state): string => Str::upper($state))
                    ->badge()
                    ->searchable(),
                Tables\Columns\TextColumn::make('title')
                    ->searchable(),
                Tables\Columns\IconColumn::make('is_active')
                    ->default(fn (Model $record) => Carbon::now() >= $record->started_at && Carbon::now() <= $record->completed_at)
                    ->label('Session Active')
                    ->alignCenter()
                    ->boolean(),
                Tables\Columns\TextColumn::make('duration')
                    ->label('Duration (minutes)')
                    ->default(fn (Model $record) => $record->started_at->diffInMinutes($record->completed_at))
                    ->alignCenter(),
                Tables\Columns\TextColumn::make('started_at')
                    ->dateTime(timezone: 'Asia/Jakarta')
                    ->sortable(),
                Tables\Columns\TextColumn::make('completed_at')
                    ->dateTime(timezone: 'Asia/Jakarta')
                    ->sortable(),
                Tables\Columns\TextColumn::make('deleted_at')
                    ->dateTime(timezone: 'Asia/Jakarta')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime(timezone: 'Asia/Jakarta')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
                    ->dateTime(timezone: 'Asia/Jakarta')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ViewAction::make(),
                    Tables\Actions\EditAction::make(),
                    Tables\Actions\DeleteAction::make(),
                ]),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->recordUrl(fn (Model $record): string => QuizSessionResource::getUrl('show', ['record' => $record]));
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListQuizSessions::route('/'),
            'create' => Pages\CreateQuizSession::route('/create'),
            'edit' => Pages\EditQuizSession::route('/{record}/edit'),
            'show' => Pages\ShowQuizSession::route('/{record}'),
        ];
    }
}
