<?php

namespace App\Filament\Resources;

use App\Filament\Resources\QuizResource\Pages;
use App\Filament\Resources\QuizResource\RelationManagers;
use App\Models\Quiz;
use Filament\Forms;
use Filament\Forms\Components\Tabs;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;
use Illuminate\Support\Facades\Auth;

class QuizResource extends Resource
{
    protected static ?string $navigationGroup = 'Quizzes';
    protected static ?string $model = Quiz::class;
    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Tabs::make('Tabs')
                    ->columnSpanFull()
                    ->tabs([
                        Tabs\Tab::make('Information')
                            ->icon('heroicon-o-question-mark-circle')
                            ->schema([
                                // automatically use session's user id
                                Forms\Components\Hidden::make('user_id')
                                    ->default(Auth::user()->id),
                                Forms\Components\Grid::make(['default' => 12])
                                    ->schema([
                                        Forms\Components\TextInput::make('title')
                                            ->required()
                                            ->columnSpan(8)
                                            ->maxLength(255),
                                        Forms\Components\TextInput::make('code')
                                            ->prefixIcon('heroicon-o-hashtag')
                                            ->required()
                                            ->columnSpan(4)
                                            ->maxLength(20),
                                    ]),
                                Forms\Components\Textarea::make('description')
                                    ->columnSpanFull()
                                    ->rows(4)
                                    ->required(),
                                Forms\Components\Grid::make(['default' => 12])
                                    ->schema([
                                        Forms\Components\DateTimePicker::make('published_at')
                                            ->columnSpan(5),
                                        Forms\Components\DateTimePicker::make('valid_until')
                                            ->columnSpan(5),
                                        Forms\Components\TextInput::make('time_limit')
                                            ->label('Time Limit (in minutes)')
                                            ->columnSpan(2)
                                            ->numeric(),
                                    ]),
                            ]),
                        Tabs\Tab::make('Quiz Questions')
                            ->icon('heroicon-o-numbered-list')
                            ->schema([
                                Forms\Components\Repeater::make('questions')
                                    ->schema([
                                        Forms\Components\Textarea::make('question')
                                            ->rows(4)
                                            ->required(),
                                        Forms\Components\Grid::make(['default' => 12])
                                            ->schema([
                                                Forms\Components\TextInput::make('answer_1')
                                                    ->columnSpan(11)
                                                    ->prefix('A.')
                                                    ->required(),
                                                Forms\Components\Toggle::make('answer_1_correct')
                                                    ->columnSpan(1)
                                                    ->inline(false)
                                                    ->label('Correct?'),
                                            ]),
                                        Forms\Components\Grid::make(['default' => 12])
                                            ->schema([
                                                Forms\Components\TextInput::make('answer_2')
                                                    ->columnSpan(11)
                                                    ->prefix('B.')
                                                    ->required(),
                                                Forms\Components\Toggle::make('answer_2_correct')
                                                    ->columnSpan(1)
                                                    ->inline(false)
                                                    ->label('Correct?'),
                                            ]),
                                        Forms\Components\Grid::make(['default' => 12])
                                            ->schema([
                                                Forms\Components\TextInput::make('answer_3')
                                                    ->columnSpan(11)
                                                    ->prefix('C.')
                                                    ->required(),
                                                Forms\Components\Toggle::make('answer_3_correct')
                                                    ->columnSpan(1)
                                                    ->inline(false)
                                                    ->label('Correct?'),
                                            ]),
                                        Forms\Components\Grid::make(['default' => 12])
                                            ->schema([
                                                Forms\Components\TextInput::make('answer_4')
                                                    ->columnSpan(11)
                                                    ->prefix('D.')
                                                    ->required(),
                                                Forms\Components\Toggle::make('answer_4_correct')
                                                    ->columnSpan(1)
                                                    ->inline(false)
                                                    ->label('Correct?'),
                                            ]),
                                    ])
                            ]),
                    ])->activeTab(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')
                    ->label('ID'),
                Tables\Columns\TextColumn::make('user.name'),
                Tables\Columns\TextColumn::make('title')
                    ->searchable(),
                Tables\Columns\TextColumn::make('time_limit')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('published_at')
                    ->dateTime()
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('deleted_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
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
            'index' => Pages\ListQuizzes::route('/'),
            'create' => Pages\CreateQuiz::route('/create'),
            'edit' => Pages\EditQuiz::route('/{record}/edit'),
        ];
    }
}
