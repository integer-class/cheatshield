<?php

namespace App\Filament\Resources;

use App\Filament\Resources\QuizResource\Pages;
use App\Models\Quiz;
use Filament\Forms;
use Filament\Forms\Components\Tabs;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder as EloquentBuilder;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\Auth;

class QuizResource extends Resource
{
    protected static ?string $model = Quiz::class;

    protected static ?string $navigationGroup = 'Quizzes';
    protected static ?string $navigationIcon = 'heroicon-o-clipboard-document';

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
                                Forms\Components\TextInput::make('title')
                                    ->required()
                                    ->maxLength(255),
                                Forms\Components\Textarea::make('description')
                                    ->columnSpanFull()
                                    ->rows(4)
                                    ->required(),
                            ]),
                        Tabs\Tab::make('Questions')
                            ->icon('heroicon-o-numbered-list')
                            ->schema([
                                Forms\Components\Repeater::make('questions')
                                    ->relationship('questions')
                                    ->schema([
                                        Forms\Components\TextInput::make('points')
                                            ->numeric()
                                            ->minValue(1)
                                            ->maxValue(10)
                                            ->default(1)
                                            ->hint('Points for this question (1-10)')
                                            ->required(),
                                        Forms\Components\Textarea::make('content')
                                            ->rows(4)
                                            ->required(),
                                        Forms\Components\Repeater::make('answers')
                                            ->relationship('answers')
                                            ->defaultItems(4)
                                            ->minItems(2)
                                            ->maxItems(6)
                                            ->schema([
                                                Forms\Components\TextInput::make('content')
                                                    ->columnSpan(11)
                                                    ->required(),
                                                Forms\Components\Toggle::make('is_correct')
                                                    ->columnSpan(1)
                                                    ->inline(false)
                                                    ->label('Correct?'),
                                            ])->columns(12),
                                    ]),
                            ]),
                    ])->activeTab(1),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('creator.name'),
                Tables\Columns\TextColumn::make('title')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('description')
                    ->searchable(),
                Tables\Columns\TextColumn::make('questions_count')
                    ->label('Questions')
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: false),
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

    public static function getEloquentQuery(): EloquentBuilder
    {
        return parent::getEloquentQuery()->withCount('questions');
    }
}
